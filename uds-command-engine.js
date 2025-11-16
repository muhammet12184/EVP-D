/**
 * ========================================
 * UDS KOMUT ALTYAPISI (ELM327 İletişim Motoru)
 * ========================================
 * 
 * ELM327 OBD-II adaptörü üzerinden UDS (Unified Diagnostic Services) 
 * komutları gönderen ve yanıtları işleyen modül.
 * 
 * Özellikler:
 * - AT SH (CAN Header ayarlama)
 * - AT TP (Protocol seçimi)
 * - Mode 22 (ReadDataByIdentifier) UDS komutları
 * - Ham HEX yanıtları parse etme
 * - Timeout ve hata yönetimi
 */

class UDSCommandEngine {
  constructor(serialPort) {
    this.port = serialPort; // WebSerial API veya Node.js SerialPort
    this.timeout = 3000; // ms
    this.currentHeader = null;
    this.responseBuffer = '';
    this.isInitialized = false;
  }

  /**
   * ELM327 başlatma ve hazırlık
   */
  async initialize() {
    try {
      await this.sendATCommand('ATZ'); // Reset
      await this.delay(1500);
      await this.sendATCommand('ATE0'); // Echo off
      await this.sendATCommand('ATL0'); // Linefeeds off
      await this.sendATCommand('ATS0'); // Spaces off
      await this.sendATCommand('ATH1'); // Headers on
      await this.sendATCommand('ATSP6'); // Set protocol ISO 15765-4 CAN (11 bit, 500kb)
      this.isInitialized = true;
      console.log('✅ ELM327 başarıyla başlatıldı');
      return { success: true };
    } catch (error) {
      console.error('❌ ELM327 başlatma hatası:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * AT komutu gönder (ELM327 kontrol komutları)
   */
  async sendATCommand(command) {
    if (!this.port) {
      throw new Error('Seri port bağlantısı yok');
    }

    const writer = this.port.writable.getWriter();
    const encoder = new TextEncoder();
    
    console.log(`📤 AT Komutu: ${command}`);
    await writer.write(encoder.encode(command + '\r'));
    writer.releaseLock();

    const response = await this.readResponse();
    console.log(`📥 AT Cevap: ${response}`);
    
    if (response.includes('ERROR') || response.includes('?')) {
      throw new Error(`AT komutu başarısız: ${response}`);
    }
    
    return response;
  }

  /**
   * CAN Header ayarla (Hangi ECU ile konuşulacak)
   * @param {string} header - Örnek: "7E4" (BMS), "7E0" (ECM), "7E1" (TCM)
   */
  async setCANHeader(header) {
    if (this.currentHeader === header) {
      return; // Zaten ayarlanmış
    }

    await this.sendATCommand(`ATSH${header}`);
    this.currentHeader = header;
    console.log(`🎯 CAN Header ayarlandı: ${header}`);
  }

  /**
   * CAN Receive Address ayarla (Yanıt filtresi)
   * @param {string} rxAddress - Örnek: "7EC" (BMS'den gelen yanıt)
   */
  async setReceiveAddress(rxAddress) {
    await this.sendATCommand(`ATCRA${rxAddress}`);
    console.log(`📡 Receive Address ayarlandı: ${rxAddress}`);
  }

  /**
   * ⭐ ANA FONKSİYON: UDS Komutu Gönder (Mode 22 - ReadDataByIdentifier)
   * 
   * @param {string} ecuHeader - ECU CAN ID (örn: "7E4" BMS için)
   * @param {string} pidCode - PID kodu (örn: "105B" Tesla SOC için)
   * @param {number} expectedBytes - Beklenen yanıt byte sayısı (varsayılan: 0 = otomatik)
   * @returns {Promise<Object>} { success, raw, bytes, error }
   */
  async sendUdsCommand(ecuHeader, pidCode, expectedBytes = 0) {
    if (!this.isInitialized) {
      await this.initialize();
    }

    try {
      // 1. CAN Header ayarla (Hangi ECU'ya gidiyoruz?)
      await this.setCANHeader(ecuHeader);

      // 2. UDS Mode 22 komutu oluştur
      // Format: 22 [2-byte PID]
      // Örnek: 22 10 5B (Mode 22, PID 105B)
      const cleanPid = pidCode.replace(/^0x/i, '').toUpperCase();
      let udsCommand = `22${cleanPid}`;
      
      // Bazı ECU'lar için padding gerekebilir
      if (udsCommand.length % 2 !== 0) {
        udsCommand += '0';
      }

      console.log(`\n🚀 UDS Komutu Gönderiliyor:`);
      console.log(`   📍 ECU Header: ${ecuHeader}`);
      console.log(`   🔑 PID: ${cleanPid}`);
      console.log(`   📦 Komut: ${udsCommand}`);

      // 3. Komutu gönder
      const writer = this.port.writable.getWriter();
      const encoder = new TextEncoder();
      await writer.write(encoder.encode(udsCommand + '\r'));
      writer.releaseLock();

      // 4. Yanıtı bekle
      const response = await this.readResponse(this.timeout);
      
      console.log(`📥 Ham Yanıt: ${response}`);

      // 5. Yanıtı parse et
      const parsed = this.parseUDSResponse(response, pidCode);

      if (!parsed.success) {
        console.log(`❌ UDS Hatası: ${parsed.error}`);
        return parsed;
      }

      console.log(`✅ Başarılı! Data Bytes: ${parsed.bytes.join(' ')}`);
      return parsed;

    } catch (error) {
      console.error(`❌ UDS Komut Hatası:`, error);
      return {
        success: false,
        error: error.message,
        raw: '',
        bytes: []
      };
    }
  }

  /**
   * UDS yanıtını parse et
   * 
   * Beklenen format örnekleri:
   * - Başarılı: "62 10 5B 8C" (62 = olumlu yanıt, 105B = PID, 8C = data)
   * - Başarılı Multi-byte: "62 10 5B 01 A3 FF" (3 byte data)
   * - Hata: "7F 22 11" (7F = hata, 22 = servis, 11 = hata kodu)
   * - Timeout: "NO DATA"
   * - Desteklenmiyor: "7F 22 31"
   */
  parseUDSResponse(response, requestedPid) {
    // Temizle
    const clean = response
      .replace(/\r/g, '')
      .replace(/\n/g, ' ')
      .replace(/>/g, '')
      .replace(/\s+/g, ' ')
      .trim()
      .toUpperCase();

    // Hata kontrolleri
    if (clean.includes('NO DATA') || clean.includes('STOPPED')) {
      return {
        success: false,
        error: 'ECU yanıt vermiyor (Timeout)',
        raw: clean,
        bytes: []
      };
    }

    if (clean.includes('ERROR') || clean.includes('?')) {
      return {
        success: false,
        error: 'ELM327 komut hatası',
        raw: clean,
        bytes: []
      };
    }

    // Hex byte'ları ayıkla
    const hexBytes = clean.match(/[0-9A-F]{2}/g);
    
    if (!hexBytes || hexBytes.length === 0) {
      return {
        success: false,
        error: 'Geçersiz yanıt formatı',
        raw: clean,
        bytes: []
      };
    }

    // UDS Negative Response kontrolü (7F XX YY)
    if (hexBytes[0] === '7F') {
      const serviceId = hexBytes[1] || '??';
      const errorCode = hexBytes[2] || '??';
      const errorMessages = {
        '11': 'Service Not Supported',
        '12': 'Sub-Function Not Supported', 
        '13': 'Incorrect Message Length',
        '22': 'Conditions Not Correct',
        '31': 'Request Out Of Range',
        '33': 'Security Access Denied',
        '78': 'Response Pending (Busy)'
      };
      
      return {
        success: false,
        error: `UDS Negative Response: ${errorMessages[errorCode] || 'Unknown'} (7F ${serviceId} ${errorCode})`,
        raw: clean,
        bytes: hexBytes,
        errorCode: errorCode
      };
    }

    // Positive Response kontrolü (62 = Mode 22 başarılı yanıt)
    if (hexBytes[0] !== '62') {
      return {
        success: false,
        error: `Beklenmeyen yanıt kodu: ${hexBytes[0]} (Beklenen: 62)`,
        raw: clean,
        bytes: hexBytes
      };
    }

    // PID doğrulama (62 10 5B -> PID = 105B)
    const responsePid = (hexBytes[1] + hexBytes[2]).toUpperCase();
    const expectedPid = requestedPid.replace(/^0x/i, '').toUpperCase();
    
    if (responsePid !== expectedPid) {
      return {
        success: false,
        error: `PID uyuşmazlığı: İstenen ${expectedPid}, Gelen ${responsePid}`,
        raw: clean,
        bytes: hexBytes
      };
    }

    // Data byte'larını al (ilk 3 byte header: 62 + 2-byte PID)
    const dataBytes = hexBytes.slice(3);

    if (dataBytes.length === 0) {
      return {
        success: false,
        error: 'Yanıtta data yok',
        raw: clean,
        bytes: hexBytes
      };
    }

    return {
      success: true,
      raw: clean,
      bytes: dataBytes, // Sadece data kısmı (A, B, C, D byte'ları)
      fullResponse: hexBytes, // Tüm yanıt (62 PID_HI PID_LO DATA...)
      pid: responsePid
    };
  }

  /**
   * Seri porttan yanıt oku
   */
  async readResponse(timeout = this.timeout) {
    const reader = this.port.readable.getReader();
    const decoder = new TextDecoder();
    let buffer = '';
    let timeoutId;

    const timeoutPromise = new Promise((_, reject) => {
      timeoutId = setTimeout(() => {
        reader.releaseLock();
        reject(new Error('Timeout'));
      }, timeout);
    });

    const readPromise = new Promise(async (resolve) => {
      while (true) {
        const { value, done } = await reader.read();
        if (done) break;
        
        buffer += decoder.decode(value);
        
        // Yanıt sonu kontrolü (> işareti veya NO DATA)
        if (buffer.includes('>') || buffer.includes('NO DATA')) {
          break;
        }
      }
      reader.releaseLock();
      resolve(buffer);
    });

    try {
      const result = await Promise.race([readPromise, timeoutPromise]);
      clearTimeout(timeoutId);
      return result;
    } catch (error) {
      clearTimeout(timeoutId);
      if (error.message === 'Timeout') {
        return 'NO DATA';
      }
      throw error;
    }
  }

  /**
   * Yardımcı: Gecikme
   */
  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * Bağlantıyı kapat
   */
  async disconnect() {
    if (this.port) {
      try {
        await this.sendATCommand('ATZ'); // Reset before closing
      } catch (e) {
        // Ignore errors on disconnect
      }
    }
    this.isInitialized = false;
    this.currentHeader = null;
  }
}

// ========================================
// ELM327 CAN HEADER REFERANSı
// ========================================
const ELM327_HEADERS = {
  // Standart OBD-II
  BROADCAST: '7DF',      // Tüm ECU'lara broadcast
  ECM_ENGINE: '7E0',     // Motor kontrol ünitesi
  TCM_TRANS: '7E1',      // Şanzıman kontrol
  
  // Hibrit/EV Sistemleri
  BMS_BATTERY: '7E4',    // Batarya yönetim sistemi (Toyota, Nissan, vb)
  HV_ECU: '7E2',         // Hibrit kontrol ECU
  INVERTER: '7E3',       // İnverter/motor kontrol
  
  // Diğer Sistemler
  ABS_ESP: '7E8',        // Fren sistemi
  AIRBAG_SRS: '7E9',     // Hava yastığı
  STEERING: '7EA',       // Direksiyon
  HVAC: '7EB',           // Klima/ısıtma
  BCM: '7EC',            // Body control module
  
  // Marka Özel
  TESLA_BMS: '7E4',
  LEAF_BMS: '7BB',       // Nissan Leaf özel
  IONIQ_BMS: '7E4',
  BOLT_BMS: '7E4'
};

// ========================================
// KULLANIM ÖRNEKLERİ
// ========================================

/**
 * Örnek 1: Tesla Battery SOC okuma
 * 
async function readTeslaSOC() {
  const uds = new UDSCommandEngine(serialPort);
  await uds.initialize();
  
  const result = await uds.sendUdsCommand('7E4', '1187');
  
  if (result.success) {
    const socValue = result.bytes[0]; // İlk byte = SOC %
    console.log(`Tesla SOC: ${socValue}%`);
  }
}
*/

/**
 * Örnek 2: Nissan Leaf Batarya Voltajı
 * 
async function readLeafVoltage() {
  const uds = new UDSCommandEngine(serialPort);
  await uds.initialize();
  
  const result = await uds.sendUdsCommand('7BB', '015D');
  
  if (result.success) {
    const A = result.bytes[0];
    const B = result.bytes[1];
    const voltage = ((A * 256) + B) / 100;
    console.log(`Leaf Voltage: ${voltage.toFixed(2)} V`);
  }
}
*/

/**
 * Örnek 3: Standart OBD-II Motor Sıcaklığı (Mode 01)
 * 
async function readEngineCoolant() {
  const uds = new UDSCommandEngine(serialPort);
  await uds.initialize();
  
  // Mode 01, PID 05 için: "01 05" komutu gönder
  // (Bu engine'de Mode 01 için sendUdsCommand'i "01" + PID şeklinde kullan)
  const result = await uds.sendUdsCommand('7E0', '0105');
  
  if (result.success) {
    const temp = result.bytes[0] - 40; // A - 40
    console.log(`Motor Sıcaklığı: ${temp}°C`);
  }
}
*/

// Export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { UDSCommandEngine, ELM327_HEADERS };
}
