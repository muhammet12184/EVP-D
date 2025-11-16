# 🚗 Komple OBD-II / UDS Okuyucu Sistemi

**799+ PID | 3 Modül | Tam Entegrasyon | TOGG, Tesla, Nissan, Hyundai destekli**

---

## ⚡ Hızlı Başlangıç (3 Adım)

```javascript
const { OBDUDSMasterController } = require('./complete-integration-example.js');
const { VEHICLE_PROFILES } = require('./pid-database-manager.js');

// 1. Bağlan
const master = new OBDUDSMasterController();

// 2. Başlat
await master.initialize(
  serialPort, 
  './comprehensive_automotive_pids.csv',
  VEHICLE_PROFILES.TOGG_T10X
);

// 3. Oku
const soc = await master.readPID('0x015C');
console.log(soc.formatted); // "87.00 %"
```

---

## 📦 Paket İçeriği

| Dosya | Boyut | Açıklama |
|-------|-------|----------|
| **uds-command-engine.js** | 12 KB | ELM327 iletişim motoru (AT komutları, UDS) |
| **pid-database-manager.js** | 13 KB | Akıllı veritabanı yöneticisi (CSV parser, filtreleme) |
| **formula-calculator.js** | 12 KB | Formül hesaplayıcı (hex → gerçek değer) |
| **complete-integration-example.js** | 17 KB | Master controller + 6 kullanım örneği |
| **comprehensive_automotive_pids.csv** | 91 KB | 799 PID veritabanı (tüm araç tipleri) |
| **test-example.js** | 12 KB | Simülasyon testleri (ELM327 olmadan) |
| **README_KULLANIM_KILAVUZU.md** | 14 KB | Detaylı dokümantasyon |

**Toplam:** 7 dosya, 181 KB

---

## 🎯 Özellikler

### ✅ 1. UDS Command Engine
- ELM327 başlatma ve AT komutları
- CAN Header ayarlama (`AT SH 7E4`)
- UDS Mode 22 komutları (`22 105B`)
- Ham yanıt parse etme (`62 10 5B 8C`)
- Timeout ve hata yönetimi

### ✅ 2. PID Database Manager
- 799+ PID veritabanı (CSV)
- Marka/model bazlı filtreleme
- Akıllı PID önerileri
- ECU tipi gruplama
- Arama ve istatistikler

### ✅ 3. Formula Calculator
- 20+ formül tipi
- Signed/unsigned integer
- Multi-byte işlemler (2-4 byte)
- Bit-encoded decode
- DTC kod çözümleme

### ✅ 4. Master Controller
- Tek komutla PID okuma
- Çoklu PID batch okuma
- Canlı izleme (polling)
- 6 hazır kullanım örneği

---

## 🚀 Kullanım Örnekleri

### 🔋 TOGG T10X - Batarya Durumu

```javascript
await master.initialize(port, csvPath, VEHICLE_PROFILES.TOGG_T10X);

const soc = await master.readPID('0x015C');       // SOC: 87%
const voltage = await master.readPID('0x015D');   // Voltaj: 398V
const current = await master.readPID('0x015E');   // Akım: -54A
const temp = await master.readPID('0x015F');      // Sıcaklık: 28°C
```

### ⚡ Tesla Model 3 - Canlı İzleme

```javascript
master.startLiveMonitoring(['0x1187', '0x1188', '0x1189'], (results) => {
  console.clear();
  results.forEach(r => console.log(`${r.description}: ${r.formatted}`));
}, 1000);
```

### 🍃 Nissan Leaf - Otomatik Tarama

```javascript
const results = await master.readSuggestedPIDs();
results.forEach(r => console.log(r.formatted));
```

### 🌐 Web Dashboard (WebSerial)

```javascript
const port = await navigator.serial.requestPort();
const master = new OBDUDSMasterController();
await master.initialize(port, csvContent, VEHICLE_PROFILES.GENERIC_EV);
master.startLiveMonitoring(pids, updateDashboard);
```

---

## 🎯 Desteklenen Araçlar

### Hazır Profiller
- ✅ **TOGG T10X** (EV)
- ✅ **Tesla Model 3/Y** (EV)
- ✅ **Nissan Leaf** (EV)
- ✅ **Hyundai Ioniq 5** (EV)
- ✅ **Kia EV6** (EV)
- ✅ **Generic EV** (Tüm elektrikli)
- ✅ **Generic Hybrid** (HEV/PHEV)
- ✅ **Generic Gas/Diesel**

### CSV Veritabanında
Ayrıca şu markalar için özel PID'ler:
- BMW (i3, iX)
- Mercedes (EQ serisi)
- Audi (e-tron)
- VW (ID serisi)
- Ford (Mach-E)
- GM (Bolt)
- Polestar 2
- BYD, MG, Mazda MX-30...

---

## 🧪 Test (Simülasyon Modu)

ELM327 bağlantısı olmadan test edin:

```bash
node test-example.js
```

**Çıktı:**
```
╔═══════════════════════════════════════════════════════╗
║      OBD-II / UDS SİSTEM TEST PAKETİ                 ║
╚═══════════════════════════════════════════════════════╝

📊 Tesla SOC (Tek byte)
   Raw Bytes: 57
   Formula: A
   ✅ Result: 87.00 %

📊 Leaf Voltage (İki byte)
   Raw Bytes: 01 90
   Formula: ((A*256)+B)/100
   ✅ Result: 4.00 V

✅ TÜM TESTLER BAŞARIYLA TAMAMLANDI!
```

---

## 📊 Veritabanı Kapsamı

| Kategori | PID Sayısı | Örnekler |
|----------|-----------|----------|
| **OBD-II Mode 01** | 160+ | Motor devri, sıcaklık, hız |
| **OBD-II Mode 09** | 13 | VIN, kalibrasyon bilgisi |
| **EV Batarya** | 49 | SOC, SOH, voltaj, akım, sıcaklık |
| **EV Motor** | 29 | RPM, tork, güç, sıcaklık |
| **EV Şarj** | 28 | AC/DC güç, voltaj, akım, süre |
| **Transmisyon** | 42 | Vites, basınç, sıcaklık |
| **ABS/ESP** | 38 | Tekerlek hızı, fren basıncı |
| **Airbag/SRS** | 26 | Airbag durumu, sensörler |
| **Direksiyon** | 16 | Açı, tork, motor akımı |
| **HVAC** | 26 | Klima, ısıtma, sensörler |
| **ADAS** | 20+ | ACC, LKA, park sensörleri |
| **Üretici Özel** | 200+ | Tesla, TOGG, Nissan, vb. |

**TOPLAM:** 799 PID

---

## 🔧 Kurulum

```bash
# Node.js için
npm install serialport

# Veya tarayıcıda WebSerial API (Chrome 89+)
```

---

## 📖 Dokümantasyon

- **Hızlı Başlangıç:** Bu dosya (README.md)
- **Detaylı Kılavuz:** [README_KULLANIM_KILAVUZU.md](README_KULLANIM_KILAVUZU.md)
- **PID Veritabanı:** [PID_DATABASE_README.md](PID_DATABASE_README.md)
- **Testler:** [test-example.js](test-example.js)

---

## 🔌 Donanım Desteği

### ELM327 Adaptörleri
- ✅ **Bluetooth** (Android, Linux)
- ✅ **USB** (Windows, Linux, macOS)
- ✅ **WiFi** (TCP socket)

### Platform Desteği
- ✅ **Node.js** (Desktop uygulamaları)
- ✅ **Browser** (WebSerial API)
- ✅ **Electron** (Cross-platform)
- ✅ **React Native** (Mobil - BluetoothSerial)

---

## ⚠️ Önemli Notlar

### Güvenlik
- UDS Mode 22 bazı ECU'larda **Security Access (0x27)** gerektirir
- Bazı PID'ler **Extended Diagnostic Session (0x10 03)** gerektirir

### Uyumluluk
- Tüm araçlar tüm PID'leri desteklemez
- `7F 22 31` hatası = PID desteklenmiyor
- Önce standart Mode 01 PID'leri deneyin

### Performans
- ECU'ya min 100ms aralıkla istek gönderin
- Batch okumada max 10-15 PID kullanın
- CAN bus yükünü izleyin

---

## 🎓 API Özeti

```javascript
// Master Controller
const master = new OBDUDSMasterController();
await master.initialize(port, csvPath, profile);

// Tek PID oku
const result = await master.readPID('0x015C');

// Çoklu PID oku
const results = await master.readMultiplePIDs(['0x015C', '0x015D']);

// Canlı izleme
master.startLiveMonitoring(pids, callback, interval);

// Arama
const results = master.searchPIDs('temperature');

// İstatistikler
master.showStatistics();
```

---

## 🌟 Örnek Çıktılar

### TOGG T10X Batarya Raporu
```
🔋 TOGG T10X - BATARYA DURUMU
═════════════════════════════

Battery State of Charge       : 87.00 %
Battery Voltage                : 398.50 V
Battery Current                : -54.30 A (deşarj)
Battery Temperature            : 28.00 °C
Battery State of Health        : 98.00 %
Cell Voltage Delta             : 0.05 V
```

### Tesla Model 3 Canlı İzleme
```
═══════════════════════════════════════
🔴 TESLA MODEL 3 - CANLI İZLEME
═══════════════════════════════════════

Tesla Battery SOC              : 72.00 %
Tesla Battery Voltage          : 385.20 V
Tesla Battery Current          : -125.40 A
Tesla Battery Temperature      : 31.00 °C

18:45:32
```

---

## 📞 Destek ve Katkı

- 📧 **Email:** support@obduds.com
- 💬 **Issues:** GitHub Issues
- 🤝 **Katkı:** Pull Request gönderin

---

## 📄 Lisans

**MIT License** - Ticari ve kişisel kullanım için ücretsizdir.

---

## 🚀 Sonraki Adımlar

1. **Test edin:**
   ```bash
   node test-example.js
   ```

2. **Dokümantasyonu okuyun:**
   ```bash
   cat README_KULLANIM_KILAVUZU.md
   ```

3. **Gerçek bağlantı yapın:**
   ```javascript
   // Kendi ELM327'nizi bağlayın
   const port = new SerialPort('/dev/ttyUSB0', { baudRate: 38400 });
   ```

4. **Web dashboard oluşturun:**
   - WebSerial API ile tarayıcıda çalıştırın
   - React/Vue ile modern UI ekleyin

---

**🎯 İyi kullanımlar! TOGG ve tüm EV'ler için mutlu okumalar!** 🔋⚡

---

*Son güncelleme: 2024-11-16*  
*Versiyon: 1.0.0*
