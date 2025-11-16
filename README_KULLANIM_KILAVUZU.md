# 🚗 OBD-II / UDS Komple Okuyucu Sistemi - Kullanım Kılavuzu

## 📦 Paket İçeriği

Bu sistem **3 ana modül** ve **1 entegrasyon katmanı** içerir:

### ✅ **1. UDS Command Engine** (`uds-command-engine.js`)
ELM327 OBD-II adaptörü ile donanımsal iletişim kurar.

**Özellikler:**
- ✅ ELM327 başlatma ve konfigürasyon (AT komutları)
- ✅ CAN Header ayarlama (`AT SH 7E4`)
- ✅ Mode 22 UDS komutları gönderme (`22 105B`)
- ✅ Ham yanıtları parse etme (`62 10 5B 8C`)
- ✅ Timeout ve hata yönetimi
- ✅ Negatif yanıt decode (`7F 22 31`)

### ✅ **2. PID Database Manager** (`pid-database-manager.js`)
799+ PID'den oluşan CSV veritabanını yönetir.

**Özellikler:**
- ✅ CSV parse ve yükleme
- ✅ Araç profili bazlı filtreleme (TOGG, Tesla, Nissan, vb.)
- ✅ Marka/model/tip bazlı akıllı PID seçimi
- ✅ ECU tipi ve kategori bazlı gruplama
- ✅ Önerilen PID'leri otomatik belirleme
- ✅ Arama ve istatistik fonksiyonları

### ✅ **3. Formula Calculator** (`formula-calculator.js`)
Ham hex byte'ları gerçek değerlere çevirir.

**Özellikler:**
- ✅ 20+ farklı formül tipi desteği
- ✅ Signed/unsigned integer hesaplama
- ✅ Multi-byte işlemler (2-4 byte)
- ✅ Bit-encoded değerleri decode
- ✅ DTC kod çözümleme
- ✅ Batch hesaplama
- ✅ Min/max limitleme ve formatla

### ✅ **4. Master Controller** (`complete-integration-example.js`)
3 modülü entegre eden tam çözüm.

**Özellikler:**
- ✅ Tek komutla PID okuma (`readPID()`)
- ✅ Çoklu PID okuma (batch)
- ✅ Canlı izleme (polling)
- ✅ Otomatik araç profili seçimi
- ✅ 6 hazır kullanım örneği

---

## 🚀 Hızlı Başlangıç

### 1️⃣ Gereksinimler

```bash
# Node.js ortamı için
npm install serialport

# Tarayıcı ortamı için
# WebSerial API desteği (Chrome 89+, Edge 89+)
```

### 2️⃣ Temel Kullanım (3 Adım)

```javascript
const { OBDUDSMasterController } = require('./complete-integration-example.js');
const { VEHICLE_PROFILES } = require('./pid-database-manager.js');
const SerialPort = require('serialport');

// ADIM 1: Bağlantı kur
const port = new SerialPort('/dev/ttyUSB0', { baudRate: 38400 });
const master = new OBDUDSMasterController();

// ADIM 2: Başlat
await master.initialize(
  port,
  './comprehensive_automotive_pids.csv',
  VEHICLE_PROFILES.TOGG_T10X  // veya Tesla, Nissan, Hyundai...
);

// ADIM 3: Oku
const soc = await master.readPID('0x015C');
console.log(`Batarya SOC: ${soc.formatted}`);
// Çıktı: "Batarya SOC: 87.00 %"
```

---

## 📖 Detaylı Kullanım Örnekleri

### 🔋 **Örnek 1: TOGG T10X - Batarya Durumu**

```javascript
const master = new OBDUDSMasterController();

await master.initialize(
  port,
  './comprehensive_automotive_pids.csv',
  VEHICLE_PROFILES.TOGG_T10X
);

// Batarya SOC
const soc = await master.readPID('0x015C');
console.log(`🔋 SOC: ${soc.formatted}`);

// Batarya Voltajı
const voltage = await master.readPID('0x015D');
console.log(`⚡ Voltaj: ${voltage.formatted}`);

// Batarya Akımı
const current = await master.readPID('0x015E');
console.log(`🔌 Akım: ${current.formatted}`);

// Batarya Sıcaklığı
const temp = await master.readPID('0x015F');
console.log(`🌡️  Sıcaklık: ${temp.formatted}`);
```

**Çıktı:**
```
🔋 SOC: 87.00 %
⚡ Voltaj: 398.50 V
🔌 Akım: -54.30 A
🌡️  Sıcaklık: 28.00 °C
```

---

### 🚘 **Örnek 2: Tesla Model 3 - Canlı İzleme**

```javascript
const master = new OBDUDSMasterController();

await master.initialize(
  port,
  './comprehensive_automotive_pids.csv',
  VEHICLE_PROFILES.TESLA_MODEL3
);

// Canlı izleme başlat (1 saniyede bir)
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
}, 1000);

// 60 saniye sonra durdur
setTimeout(() => {
  master.stopLiveMonitoring(intervalId);
}, 60000);
```

---

### 🌐 **Örnek 3: Web Dashboard (WebSerial API)**

```html
<!DOCTYPE html>
<html>
<head>
  <title>OBD-II Dashboard</title>
</head>
<body>
  <button id="connect">Bağlan</button>
  
  <div id="dashboard">
    <h2>Batarya Durumu</h2>
    <p>SOC: <span id="pid-0x015C">--</span></p>
    <p>Voltaj: <span id="pid-0x015D">--</span></p>
    <p>Akım: <span id="pid-0x015E">--</span></p>
  </div>

  <script type="module">
    import { OBDUDSMasterController } from './complete-integration-example.js';
    import { VEHICLE_PROFILES } from './pid-database-manager.js';

    document.getElementById('connect').addEventListener('click', async () => {
      // WebSerial bağlantısı
      const port = await navigator.serial.requestPort();
      await port.open({ baudRate: 38400 });

      const master = new OBDUDSMasterController();
      
      // CSV'yi fetch ile al
      const csvContent = await fetch('comprehensive_automotive_pids.csv')
        .then(r => r.text());

      await master.initialize(port, csvContent, VEHICLE_PROFILES.GENERIC_EV);

      // Canlı izleme
      master.startLiveMonitoring(['0x015C', '0x015D', '0x015E'], (results) => {
        results.forEach(r => {
          if (r.success) {
            const elementId = `pid-${r.pidInfo.code}`;
            document.getElementById(elementId).innerText = r.formatted;
          }
        });
      }, 1000);
    });
  </script>
</body>
</html>
```

---

### 🔍 **Örnek 4: Otomatik Tarama ve Filtreleme**

```javascript
const master = new OBDUDSMasterController();

await master.initialize(
  port,
  './comprehensive_automotive_pids.csv',
  VEHICLE_PROFILES.NISSAN_LEAF
);

// Veritabanı istatistiklerini göster
master.showStatistics();

// Önerilen PID'leri otomatik oku
const results = await master.readSuggestedPIDs();

// Başarılı okumaları göster
results.filter(r => r.success).forEach(r => {
  console.log(`✅ ${r.description}: ${r.formatted}`);
});

// Arama yap
const tempPIDs = master.searchPIDs('temperature');
console.log(`${tempPIDs.length} adet sıcaklık PID'i bulundu`);

// Belirli kategorideki PID'leri getir
const motorPIDs = master.pidDatabase.getPIDsForVehicle({ 
  category: 'Motor' 
});
console.log(`Motor kategorisinde ${motorPIDs.length} PID var`);
```

---

## 🎯 Araç Profilleri

Sistem 8 hazır araç profili içerir:

| Profil | Marka | Model | Tip | Kullanım |
|--------|-------|-------|-----|----------|
| `TOGG_T10X` | TOGG | T10X | EV | `VEHICLE_PROFILES.TOGG_T10X` |
| `TESLA_MODEL3` | Tesla | Model 3 | EV | `VEHICLE_PROFILES.TESLA_MODEL3` |
| `NISSAN_LEAF` | Nissan | Leaf | EV | `VEHICLE_PROFILES.NISSAN_LEAF` |
| `HYUNDAI_IONIQ5` | Hyundai | Ioniq 5 | EV | `VEHICLE_PROFILES.HYUNDAI_IONIQ5` |
| `KIA_EV6` | Kia | EV6 | EV | `VEHICLE_PROFILES.KIA_EV6` |
| `GENERIC_EV` | Generic | EV | EV | `VEHICLE_PROFILES.GENERIC_EV` |
| `GENERIC_HYBRID` | Generic | Hybrid | HEV | `VEHICLE_PROFILES.GENERIC_HYBRID` |
| `GENERIC_GAS` | Generic | Gas | Gas | `VEHICLE_PROFILES.GENERIC_GAS` |

### Özel Profil Oluşturma:

```javascript
const myProfile = {
  brand: 'BYD',
  model: 'ATTO3',
  year: 2023,
  type: 'EV',
  ecuHeaders: {
    BMS: '7E4',
    MCU: '7E3',
    OBC: '7E4'
  }
};

master.pidDatabase.setVehicleProfile(myProfile);
```

---

## 🔧 API Referansı

### **OBDUDSMasterController**

#### `initialize(port, csvPath, vehicleProfile)`
Sistemi başlatır.

**Parametreler:**
- `port`: SerialPort instance (Node.js) veya WebSerial port (Browser)
- `csvPath`: CSV dosya yolu (string) veya içeriği (string)
- `vehicleProfile`: Araç profili objesi

**Dönüş:** `{ success: boolean, error?: string }`

---

#### `readPID(pidCode)`
Tek bir PID okur.

**Parametreler:**
- `pidCode`: PID kodu (string) - Örnek: `"0x015C"` veya `"015C"`

**Dönüş:**
```javascript
{
  success: true,
  value: 87.45,
  formatted: "87.45 %",
  unit: "%",
  description: "Battery State of Charge",
  raw: ["57"],
  pidInfo: { ... }
}
```

---

#### `readMultiplePIDs(pidCodes)`
Birden fazla PID'i sırayla okur.

**Parametreler:**
- `pidCodes`: PID kodları array'i - Örnek: `["0x015C", "0x015D"]`

**Dönüş:** Sonuçlar array'i

---

#### `startLiveMonitoring(pidCodes, callback, interval)`
Canlı izleme başlatır.

**Parametreler:**
- `pidCodes`: İzlenecek PID'ler array'i
- `callback`: Her okumada çağrılacak fonksiyon `(results) => {...}`
- `interval`: Okuma aralığı (ms, varsayılan: 1000)

**Dönüş:** `intervalId` (durdurmak için `clearInterval(intervalId)`)

---

#### `readSuggestedPIDs()`
Araç profiline göre önerilen PID'leri okur.

**Dönüş:** Sonuçlar array'i

---

#### `searchPIDs(query)`
Veritabanında arama yapar.

**Parametreler:**
- `query`: Arama terimi (string)

**Dönüş:** Bulunan PID'ler array'i

---

### **PIDDatabaseManager**

#### `getPIDsForVehicle(filters)`
Filtrelere göre PID listesi döndürür.

**Parametreler:**
```javascript
{
  ecu: 'BMS',        // ECU tipi
  category: 'Battery', // Kategori
  brand: 'TESLA',    // Marka
  mode: '22'         // Mode
}
```

---

#### `getPIDByCode(pidCode)`
Tek bir PID bilgisini döndürür.

**Parametreler:**
- `pidCode`: PID kodu (string)

**Dönüş:** PID objesi veya `undefined`

---

### **FormulaCalculator**

#### `calculate(dataBytes, formula, pidInfo)`
Ham byte'ları formüle göre hesaplar.

**Parametreler:**
- `dataBytes`: Hex byte array'i - Örnek: `["8C", "A3"]`
- `formula`: Formül string'i - Örnek: `"((A*256)+B)/100"`
- `pidInfo`: `{ unit, minValue, maxValue }`

**Dönüş:**
```javascript
{
  success: true,
  value: 87.45,
  formatted: "87.45 %",
  unit: "%",
  raw: "8C A3",
  formula: "A"
}
```

---

## 🔌 Donanım Bağlantısı

### **ELM327 Bluetooth**
```javascript
// Bluetooth seri port
const port = new SerialPort('/dev/rfcomm0', { baudRate: 38400 });
```

### **ELM327 USB**
```javascript
// USB seri port (Linux)
const port = new SerialPort('/dev/ttyUSB0', { baudRate: 38400 });

// USB seri port (Windows)
const port = new SerialPort('COM3', { baudRate: 38400 });
```

### **ELM327 WiFi**
```javascript
// TCP socket bağlantısı (net modülü)
const net = require('net');
const socket = net.connect({ host: '192.168.0.10', port: 35000 });
```

---

## ⚠️ Önemli Notlar

### 🔒 **Güvenlik ve İzinler**
- UDS Mode 22 bazı ECU'larda **Security Access (0x27)** gerektirebilir
- Bazı PID'ler **Extended Diagnostic Session (0x10 03)** gerektirir
- Üretici özel PID'ler model/yıla göre değişebilir

### 🚗 **Araç Uyumluluğu**
- Tüm araçlar tüm PID'leri desteklemez
- `7F 22 31` hatası = "Request Out of Range" = PID desteklenmiyor
- Önce `Mode 01, PID 00` ile desteklenen PID'leri sorgulayın

### ⚡ **Performans**
- ECU'ya çok hızlı istek göndermekten kaçının (min 100ms aralık)
- Batch okumada 10-15 PID'den fazla okumayın
- CAN bus yükünü izleyin

### 🛠️ **Hata Ayıklama**
```javascript
// Debug modunu aktifleştir
master.calculator.setDebug(true);
master.udsEngine.timeout = 5000; // Timeout'u artır (ms)
```

---

## 📊 Veritabanı Yapısı

CSV dosyası şu sütunları içerir:

| Sütun | Açıklama | Örnek |
|-------|----------|-------|
| `PID_Code` | PID kodu | `0x015C` |
| `Mode` | OBD-II Mode | `01` veya `22` |
| `ECU_Type` | ECU tipi | `BMS`, `ECM`, `TCM` |
| `Description` | Açıklama | `Battery State of Charge` |
| `Formula` | Hesaplama formülü | `A*100/255` |
| `Byte_Positions` | Byte pozisyonları | `A`, `A-B`, `A-D` |
| `Min_Value` | Minimum değer | `0` |
| `Max_Value` | Maximum değer | `100` |
| `Unit` | Birim | `%`, `V`, `A`, `°C` |
| `Category` | Kategori | `Battery`, `Motor`, `Engine` |
| `Vehicle_Type` | Araç tipi | `EV`, `HEV`, `Gas`, `All` |
| `Technical_Notes` | Teknik notlar | `Tesla Model 3/Y` |

---

## 🎓 Formül Örnekleri

```javascript
// Tek byte
'A'                  // Ham değer
'A-40'               // Sıcaklık (-40°C offset)
'A*100/255'          // Yüzde (0-100%)

// İki byte
'(A*256)+B'          // 16-bit unsigned
'((A*256)+B)/4'      // Motor RPM
'((A*256)+B)/100'    // Voltaj (/100)

// Signed (işaretli)
'signed((A*256)+B)/10'   // İşaretli akım

// Dört byte
'((A*256*256*256)+(B*256*256)+(C*256)+D)'

// Özel
'Bit-encoded'        // Bitmap
'DTC_CODE'           // Hata kodu
'(A-128)*100/128'    // Yakıt ayarı (±100%)
```

---

## 📞 Destek

Sorularınız için:
- 📧 Email: support@obduds.com
- 📚 Dokümantasyon: [GitHub Wiki](#)
- 💬 Discord: [OBD-UDS Community](#)

---

## 📄 Lisans

MIT License - Ticari ve kişisel kullanım için ücretsizdir.

---

## ⭐ Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Commit edin (`git commit -am 'Yeni özellik eklendi'`)
4. Push edin (`git push origin feature/yeni-ozellik`)
5. Pull Request açın

---

**🚀 İyi kullanımlar! TOGG, Tesla ve tüm EV'ler için mutlu okumalar!** 🔋⚡
