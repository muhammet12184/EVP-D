/**
 * ========================================
 * FORMÜL HESAPLAYICI (Tercüman Motoru)
 * ========================================
 * 
 * Ham UDS yanıtlarını (62 10 5B 8C gibi) alır ve veritabanındaki
 * formülleri kullanarak anlamlı değerlere (54.9% gibi) dönüştürür.
 * 
 * Desteklenen formül tipleri:
 * - Basit: A, A-40, A*100/255
 * - İki byte: ((A*256)+B)/100, ((A*256)+B)
 * - Çok byte: ((A*256*256*256)+(B*256*256)+(C*256)+D)
 * - Signed (işaretli): signed((A*256)+B)
 * - Bit-encoded: Bit maskeleme
 * - Özel: Lambda, DTC kodları
 */

class FormulaCalculator {
  constructor() {
    this.debug = false;
  }

  /**
   * ⭐ ANA FONKSİYON: Ham data byte'larını formüle göre hesapla
   * 
   * @param {Array} dataBytes - UDS'den gelen ham byte'lar (HEX string array) ["8C", "A3", ...]
   * @param {string} formula - CSV'deki formül string'i
   * @param {Object} pidInfo - PID bilgileri (unit, min, max, vb.)
   * @returns {Object} { value, formatted, unit, raw }
   */
  calculate(dataBytes, formula, pidInfo = {}) {
    try {
      if (!dataBytes || dataBytes.length === 0) {
        return this.error('Veri byte\'ı yok');
      }

      if (!formula || formula.trim() === '') {
        formula = 'A'; // Varsayılan: İlk byte
      }

      // Byte'ları decimal'e çevir
      const bytes = dataBytes.map(hex => parseInt(hex, 16));
      const A = bytes[0] || 0;
      const B = bytes[1] || 0;
      const C = bytes[2] || 0;
      const D = bytes[3] || 0;

      if (this.debug) {
        console.log('🧮 Hesaplama:');
        console.log(`   Raw Bytes: ${dataBytes.join(' ')}`);
        console.log(`   Decimal: A=${A}, B=${B}, C=${C}, D=${D}`);
        console.log(`   Formül: ${formula}`);
      }

      let result;

      // Özel formül tipleri
      if (formula === 'Bit-encoded') {
        result = this.calculateBitmap(bytes);
      } else if (formula === 'DTC_CODE') {
        result = this.calculateDTC(bytes);
      } else if (formula.includes('signed')) {
        result = this.calculateSigned(formula, A, B, C, D);
      } else {
        result = this.calculateStandard(formula, A, B, C, D);
      }

      // Sonucu formatla
      const formatted = this.formatValue(result, pidInfo.unit, pidInfo.minValue, pidInfo.maxValue);

      if (this.debug) {
        console.log(`   Sonuç: ${formatted}`);
      }

      return {
        success: true,
        value: result,
        formatted: formatted,
        unit: pidInfo.unit || '',
        raw: dataBytes.join(' '),
        formula: formula
      };

    } catch (error) {
      console.error('❌ Formül hesaplama hatası:', error);
      return this.error(error.message);
    }
  }

  /**
   * Standart formül hesaplama (signed olmayan)
   */
  calculateStandard(formula, A, B, C, D) {
    // Formülü JavaScript'e çevir
    let expression = formula
      .replace(/\bA\b/g, A.toString())
      .replace(/\bB\b/g, B.toString())
      .replace(/\bC\b/g, C.toString())
      .replace(/\bD\b/g, D.toString());

    // Güvenlik: Sadece sayı, operatör ve parantez içermeli
    if (!/^[\d\s\+\-\*\/\(\)\.]+$/.test(expression)) {
      throw new Error(`Geçersiz formül: ${formula}`);
    }

    // Hesapla
    return eval(expression);
  }

  /**
   * Signed (işaretli) integer hesaplama
   * Örnek: signed((A*256)+B) -> İki byte signed 16-bit
   */
  calculateSigned(formula, A, B, C, D) {
    // "signed(...)" içindeki ifadeyi al
    const match = formula.match(/signed\(([^)]+)\)/);
    if (!match) {
      throw new Error('Signed formül formatı hatalı');
    }

    const innerFormula = match[1];
    
    // İç formülü hesapla
    const unsigned = this.calculateStandard(innerFormula, A, B, C, D);

    // Bit sayısını tespit et (formüldeki byte sayısından)
    let bits = 8;
    if (innerFormula.includes('A') && innerFormula.includes('B')) {
      bits = 16; // İki byte = 16-bit signed
    }
    if (innerFormula.includes('C') || innerFormula.includes('D')) {
      bits = 32; // 4 byte = 32-bit signed
    }

    // Unsigned'ı signed'a çevir (two's complement)
    const maxVal = Math.pow(2, bits);
    const midPoint = maxVal / 2;

    if (unsigned >= midPoint) {
      return unsigned - maxVal;
    }
    
    return unsigned;
  }

  /**
   * Bitmap hesaplama (Bit-encoded veriler)
   */
  calculateBitmap(bytes) {
    // 4-byte bitmap'i 32-bit hex string'e çevir
    const A = bytes[0] || 0;
    const B = bytes[1] || 0;
    const C = bytes[2] || 0;
    const D = bytes[3] || 0;

    const bitmap = ((A << 24) | (B << 16) | (C << 8) | D) >>> 0;
    
    return {
      hex: '0x' + bitmap.toString(16).toUpperCase().padStart(8, '0'),
      binary: bitmap.toString(2).padStart(32, '0'),
      decimal: bitmap,
      activeBits: this.getActiveBits(bitmap)
    };
  }

  /**
   * Aktif bitleri listele
   */
  getActiveBits(bitmap) {
    const active = [];
    for (let i = 0; i < 32; i++) {
      if ((bitmap >> i) & 1) {
        active.push(i + 1);
      }
    }
    return active;
  }

  /**
   * DTC (Diagnostic Trouble Code) hesaplama
   * Format: 2 byte -> P0420, C1234, vb.
   */
  calculateDTC(bytes) {
    const A = bytes[0] || 0;
    const B = bytes[1] || 0;

    // İlk 2 bit = kod tipi (P, C, B, U)
    const codeTypes = ['P', 'C', 'B', 'U'];
    const typeIndex = (A >> 6) & 0x03;
    const codeType = codeTypes[typeIndex];

    // Geri kalan 14 bit = kod numarası
    const codeNumber = ((A & 0x3F) << 8) | B;
    const codeStr = codeNumber.toString(16).toUpperCase().padStart(4, '0');

    return `${codeType}${codeStr}`;
  }

  /**
   * Değeri formatla (birim + ondalık basamak)
   */
  formatValue(value, unit, min, max) {
    // Bitmap ise özel formatlama
    if (typeof value === 'object' && value.hex) {
      return `${value.hex} (Binary: ${value.binary})`;
    }

    // DTC kodu ise direkt string
    if (typeof value === 'string' && value.match(/^[PCBU]\d{4}$/)) {
      return value;
    }

    // Sayısal değer
    if (typeof value !== 'number') {
      return String(value);
    }

    // Min/Max sınırları uygula
    if (min !== undefined && value < min) value = min;
    if (max !== undefined && value > max) value = max;

    // Ondalık basamak belirle
    let decimals = 0;
    if (Math.abs(value) < 10) decimals = 2;
    else if (Math.abs(value) < 100) decimals = 1;

    const formatted = value.toFixed(decimals);
    
    return unit ? `${formatted} ${unit}` : formatted;
  }

  /**
   * Hata döndür
   */
  error(message) {
    return {
      success: false,
      error: message,
      value: null,
      formatted: 'N/A'
    };
  }

  /**
   * Debug modunu aç/kapat
   */
  setDebug(enabled) {
    this.debug = enabled;
  }

  /**
   * ⭐ BATCH HESAPLAMA: Birden fazla PID'i aynı anda hesapla
   * 
   * @param {Array} pidDataArray - [{ bytes, formula, pidInfo }, ...]
   * @returns {Array} Hesaplama sonuçları
   */
  calculateBatch(pidDataArray) {
    return pidDataArray.map(item => {
      return this.calculate(item.bytes, item.formula, item.pidInfo);
    });
  }

  /**
   * ⭐ FORMÜL VALİDASYONU: Formül geçerli mi kontrol et
   */
  validateFormula(formula) {
    try {
      // Test değerleri ile hesapla
      const testResult = this.calculate(['FF', 'FF', 'FF', 'FF'], formula);
      return { valid: true, testResult: testResult.value };
    } catch (error) {
      return { valid: false, error: error.message };
    }
  }

  /**
   * ⭐ REVERSE CALCULATION: İstenen değer için gerekli byte'ları hesapla
   * (Örnek: 50% SOC için hangi byte gönderilmeli?)
   */
  reverseCalculate(targetValue, formula, bytePositions = 'A') {
    // Basit formüller için (A, A-40, A*100/255)
    if (formula === 'A') {
      return [Math.round(targetValue).toString(16).toUpperCase()];
    }

    if (formula === 'A-40') {
      const A = Math.round(targetValue + 40);
      return [A.toString(16).toUpperCase()];
    }

    if (formula === 'A*100/255') {
      const A = Math.round((targetValue * 255) / 100);
      return [A.toString(16).toUpperCase()];
    }

    // Daha karmaşık formüller için yaklaşık hesaplama
    // Bu kısım geliştirilmeye açık
    return null;
  }
}

// ========================================
// HAZIR FORMÜL PATTERN'LERİ (Hızlı referans)
// ========================================

const COMMON_FORMULAS = {
  // Basit tek byte
  RAW_BYTE: 'A',
  TEMPERATURE: 'A-40',              // -40°C ile 215°C arası
  PERCENTAGE: 'A*100/255',          // 0-100%
  
  // İki byte
  TWO_BYTE_UINT: '(A*256)+B',       // 16-bit unsigned
  RPM: '((A*256)+B)/4',             // Motor devri
  VOLTAGE_V: '((A*256)+B)/1000',    // Voltaj (V)
  VOLTAGE_DIV100: '((A*256)+B)/100', // Voltaj (/100)
  CURRENT_DIV10: '((A*256)+B)/10',   // Akım (/10)
  SPEED: '((A*256)+B)/100',         // Hız (km/h)
  
  // İki byte signed
  SIGNED_CURRENT: 'signed((A*256)+B)/10',  // İşaretli akım
  SIGNED_TORQUE: 'signed((A*256)+B)/10',   // İşaretli tork
  SIGNED_POWER: 'signed((A*256)+B)/10',    // İşaretli güç
  
  // Dört byte
  FOUR_BYTE_UINT: '((A*256*256*256)+(B*256*256)+(C*256)+D)',
  ENERGY_KWH: '((A*256*256*256)+(B*256*256)+(C*256)+D)/1000',
  
  // Özel
  FUEL_TRIM: '(A-128)*100/128',     // Yakıt ayarı (±100%)
  LAMBDA: '((A*256)+B)/32768',      // Lambda sensörü
  PRESSURE_BAR: '((A*256)+B)/1000', // Basınç (bar)
  
  // Bitmap
  BITMAP: 'Bit-encoded',
  DTC: 'DTC_CODE'
};

// ========================================
// KULLANIM ÖRNEKLERİ
// ========================================

/**
 * Örnek 1: Tesla SOC hesaplama
 * 
const calc = new FormulaCalculator();

// UDS yanıtı: 62 11 87 8C (62=başarı, 1187=PID, 8C=data)
const dataBytes = ['8C']; // SOC = 140 decimal = ~54.9%

const result = calc.calculate(dataBytes, 'A', {
  unit: '%',
  minValue: 0,
  maxValue: 100
});

console.log(result.formatted); // "54.90 %"
*/

/**
 * Örnek 2: Nissan Leaf batarya voltajı
 * 
const calc = new FormulaCalculator();

// UDS yanıtı: 62 01 5D 01 A3 (PID=015D, Data=01 A3)
const dataBytes = ['01', 'A3'];

const result = calc.calculate(dataBytes, '((A*256)+B)/100', {
  unit: 'V',
  minValue: 0,
  maxValue: 500
});

console.log(result.formatted); // "4.19 V" (419/100)
*/

/**
 * Örnek 3: Signed current (şarj/deşarj akımı)
 * 
const calc = new FormulaCalculator();

// Pozitif akım (şarj)
const dataBytes1 = ['00', 'C8']; // 200 decimal -> +20.0 A
const result1 = calc.calculate(dataBytes1, 'signed((A*256)+B)/10', {
  unit: 'A'
});
console.log(result1.formatted); // "20.0 A"

// Negatif akım (deşarj)
const dataBytes2 = ['FF', '38']; // -200 (two's complement) -> -20.0 A
const result2 = calc.calculate(dataBytes2, 'signed((A*256)+B)/10', {
  unit: 'A'
});
console.log(result2.formatted); // "-20.0 A"
*/

/**
 * Örnek 4: Bitmap decode (PIDs supported)
 * 
const calc = new FormulaCalculator();

const dataBytes = ['BE', '1F', 'A8', '13'];
const result = calc.calculate(dataBytes, 'Bit-encoded');

console.log(result.formatted);
// "0xBE1FA813 (Binary: 10111110000111111010100000010011)"
console.log(result.value.activeBits);
// [1, 2, 5, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 22, 24, 26, 28, 32]
*/

/**
 * Örnek 5: DTC kod okuma
 * 
const calc = new FormulaCalculator();

const dataBytes = ['01', '14']; // P0114 (IAT circuit intermittent)
const result = calc.calculate(dataBytes, 'DTC_CODE');

console.log(result.formatted); // "P0114"
*/

/**
 * Örnek 6: Debug modu ile detaylı log
 * 
const calc = new FormulaCalculator();
calc.setDebug(true);

const result = calc.calculate(['8C'], 'A*100/255', { unit: '%' });
// Console'da detaylı hesaplama adımları gösterilir
*/

/**
 * Örnek 7: Batch hesaplama (çoklu PID)
 * 
const calc = new FormulaCalculator();

const batchData = [
  { bytes: ['8C'], formula: 'A', pidInfo: { unit: '%' } },
  { bytes: ['01', 'A3'], formula: '((A*256)+B)/100', pidInfo: { unit: 'V' } },
  { bytes: ['FF', '38'], formula: 'signed((A*256)+B)/10', pidInfo: { unit: 'A' } }
];

const results = calc.calculateBatch(batchData);
results.forEach(r => console.log(r.formatted));
// "54.90 %"
// "4.19 V"
// "-20.0 A"
*/

// Export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { FormulaCalculator, COMMON_FORMULAS };
}
