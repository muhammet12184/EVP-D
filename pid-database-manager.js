/**
 * ========================================
 * PID VERİTABANI YÖNETİCİSİ (Akıllı Beyin)
 * ========================================
 * 
 * CSV veritabanından PID'leri yükler, filtreler ve bağlanan
 * aracın markasına/modeline göre doğru PID'leri seçer.
 * 
 * Özellikler:
 * - CSV parse etme
 * - Marka/model bazlı filtreleme
 * - ECU tipi bazlı gruplama
 * - Akıllı PID önerileri
 */

class PIDDatabaseManager {
  constructor() {
    this.database = [];
    this.isLoaded = false;
    this.vehicleProfile = null;
  }

  /**
   * CSV veritabanını yükle ve parse et
   * @param {string} csvContent - CSV dosya içeriği
   */
  async loadDatabase(csvContent) {
    try {
      console.log('📚 PID veritabanı yükleniyor...');
      
      const lines = csvContent.split('\n');
      const header = lines[0].split(',');
      
      // Header'ı bul
      const columnMap = {
        PID_Code: header.indexOf('PID_Code'),
        Mode: header.indexOf('Mode'),
        ECU_Type: header.indexOf('ECU_Type'),
        Description: header.indexOf('Description'),
        Formula: header.indexOf('Formula'),
        Byte_Positions: header.indexOf('Byte_Positions'),
        Min_Value: header.indexOf('Min_Value'),
        Max_Value: header.indexOf('Max_Value'),
        Unit: header.indexOf('Unit'),
        Category: header.indexOf('Category'),
        Vehicle_Type: header.indexOf('Vehicle_Type'),
        Technical_Notes: header.indexOf('Technical_Notes')
      };

      // CSV satırlarını parse et
      for (let i = 1; i < lines.length; i++) {
        const line = lines[i].trim();
        
        // Boş satırları ve separator satırları atla
        if (!line || line.startsWith('=') || line.startsWith('===')) {
          continue;
        }

        const columns = this.parseCSVLine(line);
        
        if (columns.length < 3) continue;

        const pidCode = columns[columnMap.PID_Code]?.trim();
        
        // Geçerli PID formatı kontrolü
        if (!pidCode || !pidCode.match(/^0x[0-9A-Fa-f]+$/)) {
          continue;
        }

        const pid = {
          code: pidCode,
          mode: columns[columnMap.Mode]?.trim() || '01',
          ecu: columns[columnMap.ECU_Type]?.trim() || 'ECM',
          description: columns[columnMap.Description]?.trim() || '',
          formula: columns[columnMap.Formula]?.trim() || 'A',
          bytePositions: columns[columnMap.Byte_Positions]?.trim() || 'A',
          minValue: parseFloat(columns[columnMap.Min_Value]) || 0,
          maxValue: parseFloat(columns[columnMap.Max_Value]) || 255,
          unit: columns[columnMap.Unit]?.trim() || '',
          category: columns[columnMap.Category]?.trim() || 'Unknown',
          vehicleType: columns[columnMap.Vehicle_Type]?.trim() || 'All',
          notes: columns[columnMap.Technical_Notes]?.trim() || ''
        };

        this.database.push(pid);
      }

      this.isLoaded = true;
      console.log(`✅ ${this.database.length} adet PID yüklendi`);
      return { success: true, count: this.database.length };

    } catch (error) {
      console.error('❌ Veritabanı yükleme hatası:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * CSV satırını doğru şekilde parse et (virgül + tırnak desteği)
   */
  parseCSVLine(line) {
    const result = [];
    let current = '';
    let inQuotes = false;

    for (let i = 0; i < line.length; i++) {
      const char = line[i];
      
      if (char === '"') {
        inQuotes = !inQuotes;
      } else if (char === ',' && !inQuotes) {
        result.push(current);
        current = '';
      } else {
        current += char;
      }
    }
    
    result.push(current);
    return result;
  }

  /**
   * Araç profilini ayarla (Marka/Model/Yıl/Tip)
   * @param {Object} profile - { brand, model, year, type }
   */
  setVehicleProfile(profile) {
    this.vehicleProfile = {
      brand: profile.brand?.toUpperCase() || 'GENERIC',
      model: profile.model?.toUpperCase() || '',
      year: profile.year || new Date().getFullYear(),
      type: profile.type || 'All', // 'Gas', 'Diesel', 'HEV', 'PHEV', 'EV'
    };
    
    console.log('🚗 Araç profili ayarlandı:', this.vehicleProfile);
  }

  /**
   * ⭐ AKILLI FİLTRELEME: Araç profiline göre uygun PID'leri getir
   * @param {Object} filters - { ecu, category, brand }
   * @returns {Array} Filtrelenmiş PID listesi
   */
  getPIDsForVehicle(filters = {}) {
    if (!this.isLoaded) {
      console.warn('⚠️ Veritabanı henüz yüklenmedi!');
      return [];
    }

    let results = [...this.database];

    // 1. Araç tipi filtresi (EV, Hibrit, Benzin, Dizel)
    if (this.vehicleProfile?.type && this.vehicleProfile.type !== 'All') {
      results = results.filter(pid => {
        const vType = pid.vehicleType.toUpperCase();
        return vType === 'ALL' || 
               vType.includes(this.vehicleProfile.type.toUpperCase());
      });
    }

    // 2. Marka filtresi (Tesla, TOGG, Nissan, vb.)
    if (filters.brand || this.vehicleProfile?.brand) {
      const targetBrand = (filters.brand || this.vehicleProfile.brand).toUpperCase();
      
      results = results.filter(pid => {
        const vType = pid.vehicleType.toUpperCase();
        const notes = pid.notes.toUpperCase();
        const desc = pid.description.toUpperCase();
        
        // Generic PID'ler her zaman dahil
        if (vType === 'ALL' || vType === 'GENERIC') {
          return true;
        }
        
        // Markaya özel PID kontrolü
        return vType.includes(targetBrand) || 
               notes.includes(targetBrand) ||
               desc.includes(targetBrand);
      });
    }

    // 3. ECU tipi filtresi (BMS, ECM, TCM, vb.)
    if (filters.ecu) {
      const targetECU = filters.ecu.toUpperCase();
      results = results.filter(pid => pid.ecu.toUpperCase() === targetECU);
    }

    // 4. Kategori filtresi (Battery, Motor, Charging, vb.)
    if (filters.category) {
      const targetCategory = filters.category.toUpperCase();
      results = results.filter(pid => 
        pid.category.toUpperCase().includes(targetCategory)
      );
    }

    // 5. Mode filtresi
    if (filters.mode) {
      results = results.filter(pid => pid.mode === filters.mode);
    }

    console.log(`🔍 Filtreleme: ${results.length} PID bulundu`);
    return results;
  }

  /**
   * PID koduna göre tek bir PID getir
   * @param {string} pidCode - Örnek: "0x105B" veya "105B"
   */
  getPIDByCode(pidCode) {
    const cleanCode = pidCode.toUpperCase().replace(/^0X/, '0x');
    return this.database.find(pid => 
      pid.code.toUpperCase() === cleanCode
    );
  }

  /**
   * ECU tiplerine göre grupla
   */
  getGroupedByECU() {
    const grouped = {};
    
    this.database.forEach(pid => {
      if (!grouped[pid.ecu]) {
        grouped[pid.ecu] = [];
      }
      grouped[pid.ecu].push(pid);
    });
    
    return grouped;
  }

  /**
   * Kategorilere göre grupla
   */
  getGroupedByCategory() {
    const grouped = {};
    
    this.database.forEach(pid => {
      if (!grouped[pid.category]) {
        grouped[pid.category] = [];
      }
      grouped[pid.category].push(pid);
    });
    
    return grouped;
  }

  /**
   * ⭐ ÖNERİLEN PID'LER: Araç tipine göre öncelikli PID'leri öner
   */
  getSuggestedPIDs() {
    if (!this.vehicleProfile) {
      return this.getTopPIDs(20);
    }

    const type = this.vehicleProfile.type.toUpperCase();
    
    // EV için öneriler
    if (type === 'EV') {
      return this.getPIDsForVehicle({ 
        category: 'Battery' 
      }).concat(
        this.getPIDsForVehicle({ category: 'Motor' })
      ).concat(
        this.getPIDsForVehicle({ category: 'Charging' })
      ).slice(0, 30);
    }
    
    // Hibrit için öneriler
    if (type === 'HEV' || type === 'PHEV') {
      return this.getPIDsForVehicle({ 
        category: 'Battery' 
      }).concat(
        this.getPIDsForVehicle({ category: 'Engine' })
      ).concat(
        this.getPIDsForVehicle({ category: 'Motor' })
      ).slice(0, 30);
    }
    
    // Benzin/Dizel için öneriler
    return this.getPIDsForVehicle({ 
      category: 'Engine' 
    }).concat(
      this.getPIDsForVehicle({ category: 'Fuel' })
    ).slice(0, 30);
  }

  /**
   * En yaygın kullanılan PID'leri getir
   */
  getTopPIDs(count = 20) {
    // Standart OBD-II Mode 01 PID'lerini önceliklendir
    return this.database
      .filter(pid => pid.mode === '01' || pid.vehicleType === 'All')
      .slice(0, count);
  }

  /**
   * Marka bazlı CAN header öner
   */
  suggestCANHeader(ecuType) {
    const headerMap = {
      'BMS': '7E4',
      'ECM': '7E0',
      'TCM': '7E1',
      'ABS': '7E8',
      'SRS': '7E9',
      'EPS': '7EA',
      'HVAC': '7EB',
      'MCU': '7E3',
      'OBC': '7E4',
      'DCFC': '7E4'
    };

    // Marka özel headerlar
    if (this.vehicleProfile?.brand === 'NISSAN' && ecuType === 'BMS') {
      return '7BB'; // Nissan Leaf özel
    }

    return headerMap[ecuType.toUpperCase()] || '7DF'; // Fallback: broadcast
  }

  /**
   * İstatistikler
   */
  getStatistics() {
    if (!this.isLoaded) return null;

    const stats = {
      total: this.database.length,
      byMode: {},
      byECU: {},
      byVehicleType: {},
      byCategory: {}
    };

    this.database.forEach(pid => {
      stats.byMode[pid.mode] = (stats.byMode[pid.mode] || 0) + 1;
      stats.byECU[pid.ecu] = (stats.byECU[pid.ecu] || 0) + 1;
      stats.byVehicleType[pid.vehicleType] = (stats.byVehicleType[pid.vehicleType] || 0) + 1;
      stats.byCategory[pid.category] = (stats.byCategory[pid.category] || 0) + 1;
    });

    return stats;
  }

  /**
   * Arama fonksiyonu (açıklama, kategori, not içinde ara)
   */
  search(query) {
    const q = query.toLowerCase();
    
    return this.database.filter(pid => 
      pid.description.toLowerCase().includes(q) ||
      pid.category.toLowerCase().includes(q) ||
      pid.notes.toLowerCase().includes(q) ||
      pid.code.toLowerCase().includes(q)
    );
  }
}

// ========================================
// ARAÇ PROFİL ŞABLONLARı (Hızlı başlatma)
// ========================================

const VEHICLE_PROFILES = {
  TOGG_T10X: {
    brand: 'TOGG',
    model: 'T10X',
    year: 2024,
    type: 'EV',
    ecuHeaders: {
      BMS: '7E4',
      MCU: '7E3',
      OBC: '7E4'
    }
  },

  TESLA_MODEL3: {
    brand: 'TESLA',
    model: 'MODEL3',
    year: 2023,
    type: 'EV',
    ecuHeaders: {
      BMS: '7E4',
      MCU: '7E3'
    }
  },

  NISSAN_LEAF: {
    brand: 'NISSAN',
    model: 'LEAF',
    year: 2022,
    type: 'EV',
    ecuHeaders: {
      BMS: '7BB', // Nissan özel
      MCU: '7E3'
    }
  },

  HYUNDAI_IONIQ5: {
    brand: 'HYUNDAI',
    model: 'IONIQ5',
    year: 2023,
    type: 'EV',
    ecuHeaders: {
      BMS: '7E4',
      MCU: '7E3',
      DCFC: '7E4'
    }
  },

  KIA_EV6: {
    brand: 'KIA',
    model: 'EV6',
    year: 2023,
    type: 'EV',
    ecuHeaders: {
      BMS: '7E4',
      MCU: '7E3'
    }
  },

  GENERIC_EV: {
    brand: 'GENERIC',
    model: 'EV',
    year: 2023,
    type: 'EV',
    ecuHeaders: {
      BMS: '7E4',
      MCU: '7E3'
    }
  },

  GENERIC_HYBRID: {
    brand: 'GENERIC',
    model: 'HYBRID',
    year: 2023,
    type: 'HEV',
    ecuHeaders: {
      ECM: '7E0',
      BMS: '7E4',
      MCU: '7E3'
    }
  },

  GENERIC_GAS: {
    brand: 'GENERIC',
    model: 'GASOLINE',
    year: 2023,
    type: 'Gas',
    ecuHeaders: {
      ECM: '7E0',
      TCM: '7E1'
    }
  }
};

// ========================================
// KULLANIM ÖRNEKLERİ
// ========================================

/**
 * Örnek 1: CSV yükle ve Tesla için PID'leri getir
 * 
const db = new PIDDatabaseManager();

// CSV yükle
const csvContent = await fetch('comprehensive_automotive_pids.csv').then(r => r.text());
await db.loadDatabase(csvContent);

// Tesla profili ayarla
db.setVehicleProfile(VEHICLE_PROFILES.TESLA_MODEL3);

// Batarya PID'lerini getir
const batteryPIDs = db.getPIDsForVehicle({ category: 'Battery' });
console.log(`${batteryPIDs.length} batarya PID'i bulundu`);

// Belirli bir PID bul
const socPID = db.getPIDByCode('0x1187'); // Tesla SOC
console.log(socPID);
*/

/**
 * Örnek 2: TOGG için önerilen PID'leri getir
 * 
const db = new PIDDatabaseManager();
await db.loadDatabase(csvContent);

db.setVehicleProfile(VEHICLE_PROFILES.TOGG_T10X);

const suggested = db.getSuggestedPIDs();
console.log('TOGG için önerilen PID\'ler:', suggested);
*/

/**
 * Örnek 3: Arama yap
 * 
const results = db.search('temperature');
console.log(`${results.length} adet temperature ile ilgili PID bulundu`);
*/

// Export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { PIDDatabaseManager, VEHICLE_PROFILES };
}
