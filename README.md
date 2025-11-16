# OBD Diagnostics - Enhanced Features

## Yeni Eklenen Opsiyonel Özellikler

Bu proje, araç teşhis uygulamasına üç önemli opsiyonel özellik ekler:

### 1. ✅ Gerçek Zamanlı Yakıt Tüketimi (Motor Analizi)

**Dosya:** `MotorAnalyzer.kt`

Artık motor analizinde gerçek anlık yakıt tüketimi PID'leri bağlanmıştır (önceden 0.0 placeholder değeri vardı).

**Özellikler:**
- **Mode 01, PID 5E** - Doğrudan yakıt akış hızı (L/h)
- **MAF Bazlı Hesaplama** - Eğer doğrudan PID yoksa, Mass Air Flow sensöründen hesaplama
- **Anlık Tüketim** - L/100km cinsinden gerçek zamanlı tüketim
- **Ortalama Tüketim** - Zaman periyodu üzerinden ortalama hesaplama

**Kullanılan PID'ler:**
```kotlin
FUEL_RATE("01", "5E", "(A*256+B)*0.05", "Fuel Rate L/h")
MAF("01", "10", "((A*256)+B)/100", "Mass Air Flow g/s")
```

**Örnek Veri:**
```kotlin
MotorData(
    rpm = 2000.0,
    speed = 60.0,
    fuelConsumption = 8.5,      // L/h - GERÇEK DEĞER
    instantFuelRate = 14.2,      // L/100km
    maf = 15.0                   // g/s
)
```

### 2. ✅ Rejeneratif Fren Desteği (EV Analizi)

**Dosya:** `DataAnalyzer.kt`

EV tarafında rejeneratif fren sistemi için ayrı PID'ler yakalanıp DataAnalyzer'a bağlanmıştır.

**Özellikler:**
- **Marka-Spesifik Regen PID'leri** - Her marka için özel PID desteği
- **Gerçek Zamanlı Regen Gücü** - kW cinsinden enerji geri kazanımı
- **Toplam Enerji İzleme** - Yaşam boyu geri kazanılan enerji (kWh)
- **Motor Torku** - Negatif değer regen durumunu gösterir
- **Aktif Durum Tespiti** - Şu an regen yapılıp yapılmadığı

**Desteklenen Markalar:**
```kotlin
NISSAN/RENAULT  -> PID 22 0190
HYUNDAI/KIA     -> PID 22 0175  
BMW/MINI        -> PID 22 2A40
TESLA           -> PID 22 118B
Genel/Diğer     -> PID 22 0180
```

**Örnek Veri:**
```kotlin
EVData(
    soc = 75.0,
    power = -15.0,                    // Negatif = şarj oluyor
    regenPower = 15.0,                // kW geri kazanım
    regenCurrent = 40.0,              // A
    regenEnergyTotal = 125.5,         // kWh toplam
    isRegenerating = true,            // AKTİF
    motorTorque = -50.0               // Nm
)
```

**Regen Verimliliği:**
```kotlin
val stats = dataAnalyzer.calculateRegenEfficiency(60000L) // 1 dakika
// RegenStats(totalRecovered=0.25 kWh, efficiency=18.5%)
```

### 3. ✅ Araç Marka Tespiti UI (Debug Kolaylığı)

**Dosyalar:** `PIDRouter.kt`, `VehicleDebugUI.kt`, `MainActivity.kt`

PIDRouter tarafından bulunan araç markası artık UI'da gösterilmektedir.

**Özellikler:**

#### PIDRouter Geliştirmeleri
- **3 Farklı Tespit Yöntemi:**
  1. **VIN Okuma** (100% güven) - 09 02 PID
  2. **ECU İsmi** (80% güven) - 09 0A PID
  3. **PID Testi** (60% güven) - Marka-spesifik PID yanıtı

- **17 Farklı Marka Desteği:**
  - Nissan, Renault, Hyundai, Kia, BMW, Mini, Tesla
  - Mercedes, Audi, VW, Porsche, Volvo
  - Toyota, Honda, BYD, MG, TOGG, PSA, Ford, GM, Stellantis

#### Debug UI Bileşenleri

**1. Tam Debug Paneli (VehicleDebugPanel)**
- Tespit edilen marka ve model
- Güven seviyesi (% olarak)
- Kullanılan tespit yöntemleri
- Tespit zamanı ve istatistikler
- Genişletilip daraltılabilir
- Kapatılabilir floating overlay

**2. Kompakt Rozet (VehicleDebugBadge)**
- App bar'da minimal gösterim
- Marka adı ve ikonu
- Tıklanınca tam panel açılır

**Görsel Özellikler:**
```kotlin
// Güven seviyesine göre renk
>= 90% -> Yeşil
>= 70% -> Mavi
>= 50% -> Sarı
<  50% -> Kırmızı
```

**Kullanım:**
```kotlin
// MainActivity'de
VehicleDebugBadge(
    pidRouter = pidRouter,
    onClick = { showDebugPanel = !showDebugPanel }
)

VehicleDebugPanel(
    pidRouter = pidRouter,
    onClose = { showDebugPanel = false }
)
```

## Proje Yapısı

```
/workspace/
├── MotorAnalyzer.kt          # Yakıt tüketimi ile motor analizi
├── DataAnalyzer.kt           # Regen desteği ile EV analizi
├── PIDRouter.kt              # Marka tespiti ve PID yönlendirme
├── PIDType.kt                # Genişletilmiş PID tanımları
├── PIDReader.kt              # PID okuma interface + Mock
├── VehicleDebugUI.kt         # Debug UI bileşenleri
├── MainActivity.kt           # Ana uygulama - tüm özellikleri gösterir
└── ev_unified_professional.csv  # EV PID veritabanı
```

## Kurulum ve Kullanım

### 1. Gradle Bağımlılıkları

```gradle
dependencies {
    // Jetpack Compose
    implementation "androidx.compose.ui:ui:1.5.4"
    implementation "androidx.compose.material3:material3:1.1.2"
    implementation "androidx.compose.ui:ui-tooling-preview:1.5.4"
    
    // Coroutines
    implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3"
    
    // Activity Compose
    implementation "androidx.activity:activity-compose:1.8.1"
}
```

### 2. Temel Kullanım

```kotlin
// PID okuyucu oluştur (gerçek implementasyon gerekli)
val pidReader = MockPIDReader() // veya BluetoothPIDReader()

// PIDRouter ile marka tespiti
val pidRouter = PIDRouter(pidReader)
val detection = pidRouter.detectVehicle()
println("Tespit edilen: ${detection.brand.displayName}")

// Motor analizi (yakıt tüketimi ile)
val motorAnalyzer = MotorAnalyzer(pidReader)
motorAnalyzer.monitorMotorData().collect { data ->
    println("Yakıt tüketimi: ${data.fuelConsumption} L/h")
    println("Anlık: ${data.instantFuelRate} L/100km")
}

// EV analizi (regen ile)
val dataAnalyzer = DataAnalyzer(pidReader, detection.brand.displayName)
dataAnalyzer.monitorEVData().collect { data ->
    if (data.isRegenerating) {
        println("REGEN AKTİF: ${data.regenPower} kW")
    }
}
```

### 3. UI Entegrasyonu

```kotlin
@Composable
fun MyScreen() {
    val pidReader = remember { MockPIDReader() }
    val pidRouter = remember { PIDRouter(pidReader) }
    var showDebug by remember { mutableStateOf(true) }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("OBD Diagnostics") },
                actions = {
                    VehicleDebugBadge(
                        pidRouter = pidRouter,
                        onClick = { showDebug = !showDebug }
                    )
                }
            )
        }
    ) { padding ->
        Box(modifier = Modifier.padding(padding)) {
            // Ana içerik...
            
            if (showDebug) {
                VehicleDebugPanel(
                    pidRouter = pidRouter,
                    onClose = { showDebug = false }
                )
            }
        }
    }
}
```

## Teknik Detaylar

### Yakıt Tüketimi Hesaplama

```kotlin
// Method 1: Direkt PID
val fuelRate = pidReader.readPID(PIDType.FUEL_RATE) // L/h

// Method 2: MAF'tan hesaplama
val maf = pidReader.readPID(PIDType.MAF) // g/s
val fuelRate = (maf / 14.7 / 0.74) * 3.6 // L/h
// 14.7 = stoichiometric oran
// 0.74 = yakıt yoğunluğu (benzin)

// Anlık tüketim (L/100km)
val instant = (fuelRate / speed) * 100
```

### Regen Tespit Algoritması

```kotlin
// Regen durumu tespiti
val isRegenerating = when {
    regenPower > 0.1 -> true      // Pozitif regen gücü
    batteryCurrent < -1.0 -> true // Negatif akım (şarj)
    motorTorque < -5.0 -> true    // Negatif tork
    else -> false
}
```

### VIN-Based Marka Tespiti

```kotlin
// VIN WMI (World Manufacturer Identifier) - ilk 3 karakter
val wmi = vin.substring(0, 3)

Examples:
JN*     -> Nissan
VF1     -> Renault
KM*     -> Hyundai
5YJ/7SA -> Tesla
WBA/WBS -> BMW
NMT     -> TOGG
```

## Test ve Debug

### Mock Veri Kullanımı

```kotlin
val mockReader = MockPIDReader()

// Manuel değer ayarlama
mockReader.setMockValue(PIDType.FUEL_RATE, 12.5)
mockReader.setMockValue(PIDType.REGEN_POWER, 20.0)
mockReader.setMockValue(PIDType.BATTERY_SOC, 80.0)

// Testi çalıştır
val analyzer = MotorAnalyzer(mockReader)
analyzer.monitorMotorData().collect { data ->
    assertEquals(12.5, data.fuelConsumption, 0.1)
}
```

### Debug Panel Kullanımı

1. Uygulamayı başlat
2. Sağ üst köşede marka rozetine dokun
3. Debug panelini görmek için rozete tıkla
4. Şunları kontrol et:
   - Tespit edilen marka doğru mu?
   - Güven seviyesi yeterli mi?
   - Hangi yöntemler kullanıldı?
   - VIN/ECU bilgileri doğru mu?

## Performans Notları

- **Update Intervals:**
  - Motor data: 500ms (yeterince responsive)
  - EV data: 200ms (regen için hızlı yanıt)
  - PID test: Marka tespit sırasında tek seferlik

- **Marka-Spesifik Optimizasyonlar:**
  - Tesla: 100ms polling (hızlı CAN bus)
  - BMW: 150ms polling
  - Diğer: 200ms (muhafazakar)

## Gelecek Geliştirmeler

- [ ] Daha fazla marka desteği
- [ ] Yakıt tüketimi geçmişi ve grafik
- [ ] Regen verimliliği istatistikleri
- [ ] Araç profili kaydetme
- [ ] Çoklu ECU desteği
- [ ] Real-time PID keşfi

## Lisans

Bu kod örnek implementasyon amaçlıdır. Gerçek üretim kullanımı için:
- OBD-II protokol uyumluluğunu test edin
- Araç üreticisinin belgelerini kontrol edin
- Güvenlik ve hata kontrollerini ekleyin
- Gerçek donanım ile test yapın

## İletişim

Sorular ve geri bildirimler için issue açabilirsiniz.

---
**Not:** Bu implementasyon 3 opsiyonel özelliği içerir:
1. ✅ Motor analizinde gerçek yakıt PID'i
2. ✅ EV'de regen PID desteği
3. ✅ Araç marka tespiti UI
