/**
 * ========================================
 * KOMPLE ENTEGRASYON ÖRNEĞİ
 * ========================================
 * 
 * UDS Command Engine + PID Database Manager + Formula Calculator
 * 
 * Bu dosya 3 modülü bir araya getirerek tam çalışan
 * bir OBD-II/UDS okuyucu sistemi oluşturur.
 */

// Modülleri import et
const { UDSCommandEngine, ELM327_HEADERS } = require('./uds-command-engine.js');
const { PIDDatabaseManager, VEHICLE_PROFILES } = require('./pid-database-manager.js');
const { FormulaCalculator, COMMON_FORMULAS } = require('./formula-calculator.js');
const fs = require('fs'); // Node.js için

/**
 * ========================================
 * MASTER CONTROLLER
 * ========================================
 */
class OBDUDSMasterController {
  constructor() {
    this.udsEngine = null;
    this.pidDatabase = new PIDDatabaseManager();
    this.calculator = new FormulaCalculator();
    this.isReady = false;
  }

  /**
   * Sistemi başlat
   * @param {Object} serialPort - WebSerial veya Node SerialPort
   * @param {string} csvPath - PID veritabanı CSV dosya yolu
   * @param {Object} vehicleProfile - Araç profili (VEHICLE_PROFILES'dan)
   */
  async initialize(serialPort, csvPath, vehicleProfile) {
    console.log('🚀 OBD/UDS Master Controller başlatılıyor...\n');

    try {
      // 1. UDS Engine başlat
      console.log('📡 1/3: ELM327 bağlantısı başlatılıyor...');
      this.udsEngine = new UDSCommandEngine(serialPort);
      const initResult = await this.udsEngine.initialize();
      
      if (!initResult.success) {
        throw new Error('ELM327 başlatma hatası: ' + initResult.error);
      }
      console.log('✅ ELM327 hazır\n');

      // 2. PID Veritabanı yükle
      console.log('📚 2/3: PID veritabanı yükleniyor...');
      const csvContent = fs.readFileSync(csvPath, 'utf-8');
      const dbResult = await this.pidDatabase.loadDatabase(csvContent);
      
      if (!dbResult.success) {
        throw new Error('Veritabanı yükleme hatası: ' + dbResult.error);
      }
      console.log(`✅ ${dbResult.count} PID yüklendi\n`);

      // 3. Araç profili ayarla
      console.log('🚗 3/3: Araç profili ayarlanıyor...');
      this.pidDatabase.setVehicleProfile(vehicleProfile);
      console.log(`✅ Profil: ${vehicleProfile.brand} ${vehicleProfile.model} (${vehicleProfile.type})\n`);

      this.isReady = true;
      console.log('🎯 Sistem hazır! PID okumaya başlayabilirsiniz.\n');
      
      return { success: true };

    } catch (error) {
      console.error('❌ Başlatma hatası:', error.message);
      return { success: false, error: error.message };
    }
  }

  /**
   * ⭐ TEK PID OKU (End-to-end)
   * 
   * @param {string} pidCode - PID kodu (örn: "0x1187")
   * @returns {Object} { success, value, formatted, unit, description }
   */
  async readPID(pidCode) {
    if (!this.isReady) {
      return { success: false, error: 'Sistem hazır değil. initialize() çağırın.' };
    }

    try {
      console.log(`\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
      console.log(`📖 PID Okuma: ${pidCode}`);
      console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n`);

      // 1. Veritabanından PID bilgisini al
      const pidInfo = this.pidDatabase.getPIDByCode(pidCode);
      
      if (!pidInfo) {
        return { success: false, error: `PID ${pidCode} veritabanında bulunamadı` };
      }

      console.log(`📋 PID Bilgisi:`);
      console.log(`   Açıklama: ${pidInfo.description}`);
      console.log(`   ECU: ${pidInfo.ecu}`);
      console.log(`   Mode: ${pidInfo.mode}`);
      console.log(`   Formül: ${pidInfo.formula}`);
      console.log(`   Birim: ${pidInfo.unit}\n`);

      // 2. CAN Header belirle
      const canHeader = this.pidDatabase.suggestCANHeader(pidInfo.ecu);
      console.log(`🎯 CAN Header: ${canHeader}\n`);

      // 3. UDS komutu gönder
      const cleanPid = pidCode.replace(/^0x/i, '');
      const udsResult = await this.udsEngine.sendUdsCommand(canHeader, cleanPid);

      if (!udsResult.success) {
        return { 
          success: false, 
          error: udsResult.error,
          pidInfo: pidInfo
        };
      }

      console.log(`\n📊 Ham Veri: ${udsResult.bytes.join(' ')}\n`);

      // 4. Formül ile hesapla
      const calcResult = this.calculator.calculate(
        udsResult.bytes,
        pidInfo.formula,
        {
          unit: pidInfo.unit,
          minValue: pidInfo.minValue,
          maxValue: pidInfo.maxValue
        }
      );

      if (!calcResult.success) {
        return {
          success: false,
          error: `Hesaplama hatası: ${calcResult.error}`,
          rawData: udsResult.bytes
        };
      }

      console.log(`✅ SONUÇ: ${calcResult.formatted}\n`);
      console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n`);

      return {
        success: true,
        value: calcResult.value,
        formatted: calcResult.formatted,
        unit: calcResult.unit,
        description: pidInfo.description,
        raw: udsResult.bytes,
        pidInfo: pidInfo
      };

    } catch (error) {
      console.error('❌ PID okuma hatası:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * ⭐ ÇOKLU PID OKU (Batch)
   * 
   * @param {Array} pidCodes - PID kodları array'i ["0x1187", "0x015D", ...]
   * @returns {Array} Sonuçlar array'i
   */
  async readMultiplePIDs(pidCodes) {
    const results = [];

    for (const pidCode of pidCodes) {
      const result = await this.readPID(pidCode);
      results.push(result);
      
      // ECU'ya nefes aldır (100ms delay)
      await this.delay(100);
    }

    return results;
  }

  /**
   * ⭐ ÖNERİLEN PID'LERİ OKU
   * Araç profiline göre otomatik PID seçimi ve okuma
   */
  async readSuggestedPIDs() {
    if (!this.isReady) {
      return { success: false, error: 'Sistem hazır değil' };
    }

    const suggested = this.pidDatabase.getSuggestedPIDs();
    const pidCodes = suggested.slice(0, 10).map(p => p.code); // İlk 10 PID

    console.log(`\n🎯 ${pidCodes.length} önerilen PID okunacak...\n`);

    return await this.readMultiplePIDs(pidCodes);
  }

  /**
   * ⭐ CANLI İZLEME (Polling)
   * Belirtilen PID'leri sürekli oku (saniyede 1 kez)
   * 
   * @param {Array} pidCodes - İzlenecek PID'ler
   * @param {Function} callback - Her okumada çağrılacak fonksiyon
   * @param {number} interval - Okuma aralığı (ms, varsayılan: 1000)
   */
  startLiveMonitoring(pidCodes, callback, interval = 1000) {
    if (!this.isReady) {
      console.error('❌ Sistem hazır değil');
      return null;
    }

    console.log(`\n📡 Canlı izleme başladı (${interval}ms aralık)`);
    console.log(`📍 İzlenen PID'ler: ${pidCodes.join(', ')}\n`);

    const intervalId = setInterval(async () => {
      const results = await this.readMultiplePIDs(pidCodes);
      callback(results);
    }, interval);

    return intervalId; // Durdurmak için clearInterval(intervalId)
  }

  /**
   * Canlı izlemeyi durdur
   */
  stopLiveMonitoring(intervalId) {
    if (intervalId) {
      clearInterval(intervalId);
      console.log('\n⏸️  Canlı izleme durduruldu\n');
    }
  }

  /**
   * Veritabanında arama yap
   */
  searchPIDs(query) {
    return this.pidDatabase.search(query);
  }

  /**
   * İstatistikleri göster
   */
  showStatistics() {
    const stats = this.pidDatabase.getStatistics();
    
    console.log('\n📊 VERITABANI İSTATİSTİKLERİ');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log(`Toplam PID: ${stats.total}`);
    console.log(`\nMode Dağılımı:`);
    Object.entries(stats.byMode).forEach(([mode, count]) => {
      console.log(`  Mode ${mode}: ${count} PID`);
    });
    console.log(`\nECU Dağılımı:`);
    Object.entries(stats.byECU).slice(0, 10).forEach(([ecu, count]) => {
      console.log(`  ${ecu}: ${count} PID`);
    });
    console.log('\n');
  }

  /**
   * Bağlantıyı kapat
   */
  async disconnect() {
    if (this.udsEngine) {
      await this.udsEngine.disconnect();
    }
    this.isReady = false;
    console.log('🔌 Bağlantı kapatıldı\n');
  }

  /**
   * Yardımcı: Gecikme
   */
  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

// ========================================
// KULLANIM ÖRNEKLERİ
// ========================================

/**
 * ⭐⭐⭐ ÖRNEK 1: TOGG T10X - Batarya Durumu Okuma
 */
async function example_TOGG_Battery() {
  const SerialPort = require('serialport'); // npm install serialport
  const port = new SerialPort('/dev/ttyUSB0', { baudRate: 38400 });

  const master = new OBDUDSMasterController();

  // Başlat
  await master.initialize(
    port,
    './comprehensive_automotive_pids.csv',
    VEHICLE_PROFILES.TOGG_T10X
  );

  // Batarya SOC oku
  const soc = await master.readPID('0x015C');
  console.log(`🔋 TOGG Batarya SOC: ${soc.formatted}`);

  // Batarya Voltajı oku
  const voltage = await master.readPID('0x015D');
  console.log(`⚡ TOGG Batarya Voltajı: ${voltage.formatted}`);

  // Batarya Akımı oku
  const current = await master.readPID('0x015E');
  console.log(`🔌 TOGG Batarya Akımı: ${current.formatted}`);

  await master.disconnect();
}

/**
 * ⭐⭐⭐ ÖRNEK 2: Tesla Model 3 - Canlı İzleme
 */
async function example_Tesla_LiveMonitoring() {
  const port = getSerialPort(); // Seri port bağlantısı

  const master = new OBDUDSMasterController();

  await master.initialize(
    port,
    './comprehensive_automotive_pids.csv',
    VEHICLE_PROFILES.TESLA_MODEL3
  );

  // Canlı izleme başlat
  const monitoringPIDs = [
    '0x1187', // SOC
    '0x1188', // Voltage
    '0x1189', // Current
    '0x118A'  // Temperature
  ];

  const intervalId = master.startLiveMonitoring(monitoringPIDs, (results) => {
    console.clear();
    console.log('═══════════════════════════════════════');
    console.log('🔴 TESLA MODEL 3 - CANLI İZLEME');
    console.log('═══════════════════════════════════════\n');
    
    results.forEach(r => {
      if (r.success) {
        console.log(`${r.description}: ${r.formatted}`);
      }
    });
    
    console.log(`\n${new Date().toLocaleTimeString()}`);
  });

  // 60 saniye sonra durdur
  setTimeout(() => {
    master.stopLiveMonitoring(intervalId);
    master.disconnect();
  }, 60000);
}

/**
 * ⭐⭐⭐ ÖRNEK 3: Nissan Leaf - Tüm Batarya Parametreleri
 */
async function example_Leaf_CompleteBattery() {
  const port = getSerialPort();
  const master = new OBDUDSMasterController();

  await master.initialize(
    port,
    './comprehensive_automotive_pids.csv',
    VEHICLE_PROFILES.NISSAN_LEAF
  );

  // Batarya kategorisindeki tüm PID'leri oku
  const batteryPIDs = master.pidDatabase.getPIDsForVehicle({ 
    category: 'Battery' 
  });

  console.log(`\n🔋 Nissan Leaf - ${batteryPIDs.length} Batarya Parametresi\n`);

  const results = await master.readMultiplePIDs(
    batteryPIDs.slice(0, 15).map(p => p.code)
  );

  // Sonuçları tablo halinde göster
  console.log('╔═══════════════════════════════════════════════════════════╗');
  console.log('║                 NISSAN LEAF BATARYA RAPORU                 ║');
  console.log('╠═══════════════════════════════════════════════════════════╣');
  
  results.forEach(r => {
    if (r.success) {
      const desc = r.description.padEnd(40);
      const value = r.formatted.padStart(15);
      console.log(`║ ${desc} │ ${value} ║`);
    }
  });
  
  console.log('╚═══════════════════════════════════════════════════════════╝\n');

  await master.disconnect();
}

/**
 * ⭐⭐⭐ ÖRNEK 4: Generic EV - Önerilen PID'leri Otomatik Oku
 */
async function example_AutoScan() {
  const port = getSerialPort();
  const master = new OBDUDSMasterController();

  await master.initialize(
    port,
    './comprehensive_automotive_pids.csv',
    VEHICLE_PROFILES.GENERIC_EV
  );

  // İstatistikleri göster
  master.showStatistics();

  // Önerilen PID'leri oku
  const results = await master.readSuggestedPIDs();

  console.log('\n📋 OTOMATIK TARAMA SONUÇLARI\n');
  results.forEach(r => {
    if (r.success) {
      console.log(`✅ ${r.description}: ${r.formatted}`);
    } else {
      console.log(`❌ ${r.pidInfo?.description || 'Unknown'}: ${r.error}`);
    }
  });

  await master.disconnect();
}

/**
 * ⭐⭐⭐ ÖRNEK 5: Web Dashboard (Browser + WebSerial API)
 */
async function example_WebDashboard() {
  // Web tarayıcısında WebSerial API kullanımı
  
  // HTML'de button tıklandığında:
  const connectButton = document.getElementById('connect');
  
  connectButton.addEventListener('click', async () => {
    // WebSerial ile bağlan
    const port = await navigator.serial.requestPort();
    await port.open({ baudRate: 38400 });

    const master = new OBDUDSMasterController();
    
    // CSV'yi fetch ile al
    const csvContent = await fetch('comprehensive_automotive_pids.csv')
      .then(r => r.text());

    await master.initialize(
      port,
      csvContent, // String olarak geç
      VEHICLE_PROFILES.GENERIC_EV
    );

    // Canlı dashboard
    master.startLiveMonitoring(['0x015C', '0x015D', '0x015E'], (results) => {
      results.forEach(r => {
        if (r.success) {
          document.getElementById(`pid-${r.pidInfo.code}`).innerText = r.formatted;
        }
      });
    });
  });
}

/**
 * ⭐⭐⭐ ÖRNEK 6: Hata Durumu Kontrolü ve Loglama
 */
async function example_ErrorHandling() {
  const port = getSerialPort();
  const master = new OBDUDSMasterController();

  await master.initialize(
    port,
    './comprehensive_automotive_pids.csv',
    VEHICLE_PROFILES.HYUNDAI_IONIQ5
  );

  // Hata durumunu kontrol et
  const pidCodes = ['0x015C', '0x015D', '0xFFFF']; // Son PID geçersiz

  for (const pidCode of pidCodes) {
    const result = await master.readPID(pidCode);
    
    if (result.success) {
      console.log(`✅ ${pidCode}: ${result.formatted}`);
      
      // Loglama (dosyaya yaz)
      logToFile({
        timestamp: new Date().toISOString(),
        pid: pidCode,
        value: result.value,
        unit: result.unit
      });
    } else {
      console.log(`❌ ${pidCode}: HATA - ${result.error}`);
      
      // Hata loglama
      logErrorToFile({
        timestamp: new Date().toISOString(),
        pid: pidCode,
        error: result.error
      });
    }
  }

  await master.disconnect();
}

// ========================================
// YARDIMCI FONKSİYONLAR
// ========================================

function getSerialPort() {
  // Node.js ortamı için
  const SerialPort = require('serialport');
  return new SerialPort('/dev/ttyUSB0', { baudRate: 38400 });
}

function logToFile(data) {
  const logLine = JSON.stringify(data) + '\n';
  fs.appendFileSync('obd_data.log', logLine);
}

function logErrorToFile(data) {
  const logLine = JSON.stringify(data) + '\n';
  fs.appendFileSync('obd_errors.log', logLine);
}

// Export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { 
    OBDUDSMasterController,
    // Örnekler
    example_TOGG_Battery,
    example_Tesla_LiveMonitoring,
    example_Leaf_CompleteBattery,
    example_AutoScan,
    example_WebDashboard,
    example_ErrorHandling
  };
}

// ========================================
// HIZLI BAŞLATMA KOMUTLARı
// ========================================

/*

# Node.js ortamında çalıştırma:

node complete-integration-example.js

# Veya belirli bir örnek fonksiyonu:

node -e "require('./complete-integration-example.js').example_TOGG_Battery()"

# Web tarayıcısında:
# HTML'e script tag ile dahil et ve WebSerial API kullan

*/
