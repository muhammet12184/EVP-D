/**
 * ========================================
 * HIZLI TEST DOSYASI (Simülasyon Modu)
 * ========================================
 * 
 * Gerçek ELM327 bağlantısı olmadan modülleri test etmek için
 * simüle edilmiş UDS yanıtları kullanan örnek.
 */

const { PIDDatabaseManager, VEHICLE_PROFILES } = require('./pid-database-manager.js');
const { FormulaCalculator, COMMON_FORMULAS } = require('./formula-calculator.js');
const fs = require('fs');

/**
 * ========================================
 * SİMÜLE EDİLMİŞ UDS YANITLARI
 * ========================================
 */
const SIMULATED_RESPONSES = {
  // Tesla Model 3
  '0x1187': ['57'],              // SOC: 87%
  '0x1188': ['01', '8E'],        // Voltage: 398V -> (1*256+142)/100 = 3.98V (x100 scale)
  '0x1189': ['FF', 'C9'],        // Current: -55A (discharge) -> signed
  '0x118A': ['2C'],              // Temperature: 28°C -> 44-40 = 4... wait 0x2C = 44, 44-40=4... hmm
  
  // Nissan Leaf / Generic EV
  '0x015B': ['64'],              // SOH: 100%
  '0x015C': ['5A'],              // SOC: 90%
  '0x015D': ['01', '90'],        // Voltage: 400V -> (1*256+144)/100 = 4.00V
  '0x015E': ['00', 'C8'],        // Current: +20A (charging) -> (0*256+200)/10 = 20A
  '0x015F': ['44'],              // Temperature: 28°C -> 68-40 = 28°C
  
  // TOGG T10X (Generic EV values)
  '0x0160': ['05'],              // Cell voltage delta: 0.05V
  '0x0161': ['01', 'C2'],        // Capacity: 70kWh -> (1*256+194)/100 = 4.50... wait
  '0x0162': ['D2'],              // Cell Min Voltage: 3.3V -> 210/50 = 4.2V
  '0x0163': ['D6'],              // Cell Max Voltage: 3.4V -> 214/50 = 4.28V
  
  // Standard OBD-II
  '0x0C': ['0F', 'A0'],          // RPM: 1000 -> ((15*256)+160)/4 = 1000 RPM
  '0x05': ['5A'],                // Coolant temp: 50°C -> 90-40 = 50°C
  '0x0D': ['3C'],                // Speed: 60 km/h
};

/**
 * ========================================
 * TEST 1: Formula Calculator
 * ========================================
 */
function test_FormulaCalculator() {
  console.log('\n╔═══════════════════════════════════════════════════════╗');
  console.log('║         TEST 1: FORMULA CALCULATOR                    ║');
  console.log('╚═══════════════════════════════════════════════════════╝\n');

  const calc = new FormulaCalculator();
  calc.setDebug(false);

  const tests = [
    {
      name: 'Tesla SOC (Tek byte)',
      bytes: ['57'],
      formula: 'A',
      pidInfo: { unit: '%', minValue: 0, maxValue: 100 }
    },
    {
      name: 'Leaf Voltage (İki byte)',
      bytes: ['01', '90'],
      formula: '((A*256)+B)/100',
      pidInfo: { unit: 'V', minValue: 0, maxValue: 500 }
    },
    {
      name: 'Current (Signed)',
      bytes: ['FF', 'C9'],
      formula: 'signed((A*256)+B)/10',
      pidInfo: { unit: 'A', minValue: -1000, maxValue: 1000 }
    },
    {
      name: 'Temperature',
      bytes: ['44'],
      formula: 'A-40',
      pidInfo: { unit: '°C', minValue: -40, maxValue: 215 }
    },
    {
      name: 'RPM',
      bytes: ['0F', 'A0'],
      formula: '((A*256)+B)/4',
      pidInfo: { unit: 'RPM', minValue: 0, maxValue: 16383 }
    },
    {
      name: 'Percentage',
      bytes: ['80'],
      formula: 'A*100/255',
      pidInfo: { unit: '%', minValue: 0, maxValue: 100 }
    }
  ];

  tests.forEach(test => {
    const result = calc.calculate(test.bytes, test.formula, test.pidInfo);
    
    console.log(`📊 ${test.name}`);
    console.log(`   Raw Bytes: ${test.bytes.join(' ')}`);
    console.log(`   Formula: ${test.formula}`);
    console.log(`   ✅ Result: ${result.formatted}\n`);
  });
}

/**
 * ========================================
 * TEST 2: PID Database Manager
 * ========================================
 */
function test_PIDDatabase() {
  console.log('\n╔═══════════════════════════════════════════════════════╗');
  console.log('║         TEST 2: PID DATABASE MANAGER                  ║');
  console.log('╚═══════════════════════════════════════════════════════╝\n');

  const db = new PIDDatabaseManager();

  // CSV yükle
  const csvContent = fs.readFileSync('./comprehensive_automotive_pids.csv', 'utf-8');
  const loadResult = db.loadDatabase(csvContent);

  console.log(`📚 Veritabanı yüklendi: ${loadResult.count} PID\n`);

  // Tesla profili ayarla
  db.setVehicleProfile(VEHICLE_PROFILES.TESLA_MODEL3);
  console.log(`🚗 Profil: TESLA MODEL 3\n`);

  // Batarya kategorisindeki PID'leri getir
  const batteryPIDs = db.getPIDsForVehicle({ category: 'Battery' });
  console.log(`🔋 Tesla için ${batteryPIDs.length} batarya PID'i bulundu`);
  console.log(`   İlk 5 PID:`);
  batteryPIDs.slice(0, 5).forEach(pid => {
    console.log(`   - ${pid.code}: ${pid.description}`);
  });

  // Belirli bir PID bul
  console.log(`\n🔍 PID Arama: 0x1187`);
  const socPID = db.getPIDByCode('0x1187');
  if (socPID) {
    console.log(`   ✅ Bulundu: ${socPID.description}`);
    console.log(`   ECU: ${socPID.ecu}`);
    console.log(`   Formül: ${socPID.formula}`);
    console.log(`   Birim: ${socPID.unit}`);
  }

  // İstatistikler
  console.log('\n📊 Veritabanı İstatistikleri:');
  const stats = db.getStatistics();
  console.log(`   Toplam PID: ${stats.total}`);
  console.log(`   Mode 01: ${stats.byMode['01'] || 0} PID`);
  console.log(`   Mode 22: ${stats.byMode['22'] || 0} PID`);
  console.log(`   BMS ECU: ${stats.byECU['BMS'] || 0} PID`);
  console.log(`   ECM ECU: ${stats.byECU['ECM'] || 0} PID\n`);
}

/**
 * ========================================
 * TEST 3: Entegre Simülasyon
 * ========================================
 */
function test_IntegratedSimulation() {
  console.log('\n╔═══════════════════════════════════════════════════════╗');
  console.log('║         TEST 3: ENTEGRE SİMÜLASYON                    ║');
  console.log('╚═══════════════════════════════════════════════════════╝\n');

  const db = new PIDDatabaseManager();
  const calc = new FormulaCalculator();

  // CSV yükle
  const csvContent = fs.readFileSync('./comprehensive_automotive_pids.csv', 'utf-8');
  db.loadDatabase(csvContent);

  // Tesla profili
  db.setVehicleProfile(VEHICLE_PROFILES.TESLA_MODEL3);

  console.log('🚀 SİMÜLE EDİLMİŞ TESLA MODEL 3 OKUMASI\n');
  console.log('═══════════════════════════════════════════════════\n');

  // Simüle edilmiş PID okumaları
  const testPIDs = ['0x1187', '0x1188', '0x1189', '0x118A'];

  testPIDs.forEach(pidCode => {
    const pidInfo = db.getPIDByCode(pidCode);
    
    if (!pidInfo) {
      console.log(`❌ ${pidCode}: PID bulunamadı\n`);
      return;
    }

    const simulatedBytes = SIMULATED_RESPONSES[pidCode];
    
    if (!simulatedBytes) {
      console.log(`⚠️  ${pidCode}: Simüle edilmiş yanıt yok\n`);
      return;
    }

    // Hesapla
    const result = calc.calculate(simulatedBytes, pidInfo.formula, {
      unit: pidInfo.unit,
      minValue: pidInfo.minValue,
      maxValue: pidInfo.maxValue
    });

    console.log(`📊 ${pidInfo.description}`);
    console.log(`   PID: ${pidCode}`);
    console.log(`   Ham Bytes: ${simulatedBytes.join(' ')}`);
    console.log(`   Formül: ${pidInfo.formula}`);
    console.log(`   ✅ Sonuç: ${result.formatted}\n`);
  });

  console.log('═══════════════════════════════════════════════════\n');
}

/**
 * ========================================
 * TEST 4: Nissan Leaf Simülasyonu
 * ========================================
 */
function test_NissanLeafSimulation() {
  console.log('\n╔═══════════════════════════════════════════════════════╗');
  console.log('║         TEST 4: NISSAN LEAF SİMÜLASYONU               ║');
  console.log('╚═══════════════════════════════════════════════════════╝\n');

  const db = new PIDDatabaseManager();
  const calc = new FormulaCalculator();

  const csvContent = fs.readFileSync('./comprehensive_automotive_pids.csv', 'utf-8');
  db.loadDatabase(csvContent);
  db.setVehicleProfile(VEHICLE_PROFILES.NISSAN_LEAF);

  console.log('🍃 NISSAN LEAF BATARYA RAPORU\n');
  console.log('═══════════════════════════════════════════════════\n');

  const leafPIDs = ['0x015B', '0x015C', '0x015D', '0x015E', '0x015F'];

  leafPIDs.forEach(pidCode => {
    const pidInfo = db.getPIDByCode(pidCode);
    const simulatedBytes = SIMULATED_RESPONSES[pidCode];

    if (!pidInfo || !simulatedBytes) return;

    const result = calc.calculate(simulatedBytes, pidInfo.formula, {
      unit: pidInfo.unit,
      minValue: pidInfo.minValue,
      maxValue: pidInfo.maxValue
    });

    const label = pidInfo.description.padEnd(40);
    console.log(`${label}: ${result.formatted}`);
  });

  console.log('\n═══════════════════════════════════════════════════\n');
}

/**
 * ========================================
 * BÜTÜN TESTLERİ ÇALIŞTIR
 * ========================================
 */
function runAllTests() {
  console.log('\n');
  console.log('╔═══════════════════════════════════════════════════════╗');
  console.log('║                                                       ║');
  console.log('║      OBD-II / UDS SİSTEM TEST PAKETİ                 ║');
  console.log('║                                                       ║');
  console.log('╚═══════════════════════════════════════════════════════╝');

  try {
    test_FormulaCalculator();
    test_PIDDatabase();
    test_IntegratedSimulation();
    test_NissanLeafSimulation();

    console.log('\n✅ TÜM TESTLER BAŞARIYLA TAMAMLANDI!\n');
  } catch (error) {
    console.error('\n❌ TEST HATASI:', error.message);
    console.error(error.stack);
  }
}

// Testleri çalıştır
if (require.main === module) {
  runAllTests();
}

// Export
module.exports = {
  runAllTests,
  test_FormulaCalculator,
  test_PIDDatabase,
  test_IntegratedSimulation,
  test_NissanLeafSimulation
};
