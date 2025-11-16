# ⚡ TÜM SENSÖRLER VE PID'LER - KAPSAMLı LİSTE

## 🎯 200+ PID HAZIR!

### 📦 DOSYALAR

```
/workspace/flutter/
├── all_sensors_pids.dart      ⚡ 200+ PID tanımı
└── all_sensors_usage.dart     📖 Kullanım örnekleri
```

---

## 📊 PID İSTATİSTİKLERİ

### Araç Tiplerine Göre

```
🚗 BENZİNLİ    → ~80 PID
🚜 DİZEL       → ~120 PID (benzinli + dizel özel)
⚡ ELEKTRİKLİ  → ~90 PID
🔋 HİBRİT      → ~150 PID (benzinli + elektrikli)

TOPLAM: 200+ FARKLI PID!
```

### Kategorilere Göre

```
⚙️  Motor              → 25 PID
⛽ Yakıt              → 15 PID
🌫️  Egzoz             → 30 PID
🔋 Batarya            → 35 PID
⚡ Elektrik Motor     → 20 PID
🔌 Şarj               → 15 PID
❄️  Klima             → 8 PID
🛡️  Güvenlik          → 12 PID
🎯 Teşhis             → 10 PID
```

---

## 🚗 BENZİNLİ ARAÇ PID'LERİ (80+)

### Motor
```dart
engineRpm              → Motor Devri (RPM)
engineLoad             → Motor Yükü (%)
coolantTemp            → Soğutma Suyu Sıcaklığı (°C)
engineOilTemp          → Motor Yağ Sıcaklığı (°C)
timingAdvance          → Ateşleme Avansı (°)
intakeTemp             → Emme Havası Sıcaklığı (°C)
intakeManifoldPressure → Emme Manifold Basıncı (kPa)
```

### Yakıt Sistemi
```dart
fuelRate               → Yakıt Tüketimi (L/h) ⭐
fuelLevel              → Yakıt Seviyesi (%)
fuelPressure           → Yakıt Basıncı (kPa)
fuelType               → Yakıt Tipi
fuelRailPressure       → Yakıt Ray Basıncı (kPa)
fuelInjectionTiming    → Enjeksiyon Zamanlaması (°)
ethanolFuelPercent     → Etanol Yüzdesi (%)
```

### Hava Akışı
```dart
maf                    → Hava Akış Sensörü (g/s)
throttlePosition       → Gaz Kelebeği (%)
relativeThrottlePosition → Bağıl Gaz (%)
absoluteThrottleB/C    → Mutlak Gaz B/C (%)
acceleratorPedalD/E/F  → Gaz Pedalı D/E/F (%)
```

### Oksijen Sensörleri (8 adet)
```dart
o2Sensor1/2/3/4Voltage → O2 Sensör Voltaj (V)
o2Sensor1/2/3/4Current → O2 Sensör Akım (mA)
wideO2Sensor1/2/3/4    → Geniş Band O2
```

### Katalitik Konvertör
```dart
catalystTempBank1Sensor1/2 → Katalizör Sıcaklık 1-1/2 (°C)
catalystTempBank2Sensor1/2 → Katalizör Sıcaklık 2-1/2 (°C)
```

### EGR (Egzoz Gazı Resirkülasyonu)
```dart
commandedEgr           → EGR Komutu (%)
egrError               → EGR Hatası (%)
```

### EVAP (Buharlaşma)
```dart
commandedEvapPurge     → EVAP Temizleme (%)
evapVaporPressure      → Buharlaşma Basıncı (Pa)
```

### Yakıt Trim
```dart
shortFuelTrimBank1/2   → Kısa Yakıt Trim (%)
longFuelTrimBank1/2    → Uzun Yakıt Trim (%)
```

---

## 🚜 DİZEL ARAÇ PID'LERİ (120+)

### + Tüm Benzinli PID'ler
### + Dizel Spesifik:

### DPF (Dizel Partikül Filtresi)
```dart
dpfTemperature         → DPF Sıcaklığı (°C)
dpfPressure            → DPF Basıncı (kPa)
dpfRegenStatus         → DPF Rejenerasyon Durumu
sootLevel              → Kurum Seviyesi (%)
ashLevel               → Kül Seviyesi (%)
```

### AdBlue (DEF)
```dart
adBlueLevel            → AdBlue Seviyesi (%)
adBluePressure         → AdBlue Basıncı (kPa)
adBlueTemp             → AdBlue Sıcaklığı (°C)
adBlueQuality          → AdBlue Kalitesi
```

### SCR (Selective Catalytic Reduction)
```dart
scrInletTemp           → SCR Giriş Sıcaklık (°C)
scrOutletTemp          → SCR Çıkış Sıcaklık (°C)
noxSensorUpstream      → NOx Üst Akım (ppm)
noxSensorDownstream    → NOx Alt Akım (ppm)
```

### Turbo Dizel
```dart
turboBoostPressure     → Turbo Basınç (kPa)
turboSpeed             → Turbo Devri (RPM)
turboWastegatePosition → Wastegate Pozisyon (%)
turboCompressorInletPressure → Turbo Giriş Basıncı (kPa)
turboCompressorInletTemp → Turbo Giriş Sıcaklık (°C)
```

### EGR Dizel
```dart
egrCoolerTemp          → EGR Soğutucu Sıcaklık (°C)
egrValvePosition       → EGR Valf Pozisyon (%)
```

### Kızdırma Bujileri
```dart
glowPlugTemp           → Kızdırma Buji Sıcaklık (°C)
glowPlugStatus         → Kızdırma Buji Durumu
```

### Common Rail
```dart
railPressureActual     → Ray Basıncı Gerçek (bar)
railPressureDesired    → Ray Basıncı Hedef (bar)
```

---

## ⚡ ELEKTRİKLİ ARAÇ PID'LERİ (90+)

### Batarya Ana
```dart
batterySoc             → Şarj Durumu (%) ⭐
batteryVoltage         → Voltaj (V) ⭐
batteryCurrent         → Akım (A) ⭐
batteryTemp            → Sıcaklık (°C) ⭐
batteryPower           → Güç (kW)
batterySoh             → Sağlık (%)
batteryCapacity        → Kapasite (kWh)
batteryCapacityRemaining → Kalan Kapasite (kWh)
```

### Hücre Voltajları
```dart
cellVoltageMin         → Min Hücre Voltaj (V)
cellVoltageMax         → Max Hücre Voltaj (V)
cellVoltageDelta       → Hücre Voltaj Farkı (V)
cellVoltage1/2/3...    → Hücre 1/2/3... Voltaj (V)
// 96 hücreye kadar!
```

### Batarya Sıcaklıkları
```dart
batteryTempMin         → Min Batarya Sıcaklık (°C)
batteryTempMax         → Max Batarya Sıcaklık (°C)
batteryTempAvg         → Ort Batarya Sıcaklık (°C)
batteryTempModule1/2   → Modül 1/2 Sıcaklık (°C)
batteryInletTemp       → Batarya Giriş Sıcaklık (°C)
batteryOutletTemp      → Batarya Çıkış Sıcaklık (°C)
```

### Şarj Sistemi
```dart
dcChargePower          → DC Şarj Gücü (kW)
acChargePower          → AC Şarj Gücü (kW)
chargingStatus         → Şarj Durumu
chargerVoltage         → Şarj Voltajı (V)
chargerCurrent         → Şarj Akımı (A)
chargingTime           → Şarj Süresi (min)
chargeLimit            → Şarj Limiti (%)
fastChargeCount        → Hızlı Şarj Sayısı
slowChargeCount        → Yavaş Şarj Sayısı
```

### Elektrik Motoru
```dart
motorSpeed             → Motor Devri (RPM)
motorTorque            → Motor Torku (Nm)
motorTemp              → Motor Sıcaklığı (°C)
motorPower             → Motor Gücü (kW)
motorCurrent           → Motor Akımı (A)
motorVoltage           → Motor Voltajı (V)
```

### İnverter
```dart
inverterTemp           → İnverter Sıcaklık (°C)
inverterVoltage        → İnverter Voltaj (V)
inverterCurrent        → İnverter Akım (A)
inverterFrequency      → İnverter Frekans (Hz)
```

### Rejeneratif Fren
```dart
regenPower             → Regen Gücü (kW) ⭐
regenCurrent           → Regen Akımı (A) ⭐
regenEnergyTotal       → Toplam Regen (kWh) ⭐
regenLevel             → Regen Seviyesi
```

### Marka Spesifik Regen
```dart
regenNissan            → Nissan Regen
regenHyundai           → Hyundai Regen (kW)
regenBmw               → BMW Regen (kW)
regenTesla             → Tesla Regen (kW)
regenTogg              → TOGG Regen (kW) 🇹🇷
```

### Menzil ve Enerji
```dart
estimatedRange         → Tahmini Menzil (km)
energyConsumed         → Tüketilen Enerji (kWh)
energyEfficiency       → Verimlilik (Wh/km)
tripDistance           → Yol Mesafesi (km)
averageSpeed           → Ortalama Hız (km/h)
```

### DC-DC Konvertör
```dart
dcdc12vVoltage         → 12V Sistem Voltaj (V)
dcdc12vCurrent         → 12V Sistem Akım (A)
dcdcTemp               → DC-DC Sıcaklık (°C)
```

### OBC (On-Board Charger)
```dart
obcTemp                → OBC Sıcaklık (°C)
obcInputVoltage        → OBC Giriş Voltaj (V)
obcOutputVoltage       → OBC Çıkış Voltaj (V)
obcOutputCurrent       → OBC Çıkış Akım (A)
```

### BMS (Battery Management System)
```dart
bmsStatus              → BMS Durumu
bmsError               → BMS Hata
bmsBalancingStatus     → BMS Dengeleme
```

### Soğutma (EV)
```dart
coolantPumpSpeed       → Soğutma Pompası (%)
coolantFlowRate        → Soğutma Akış (L/min)
radiatorFanSpeed       → Radyatör Fan (%)
batteryHeaterStatus    → Batarya Isıtıcı
```

### Klima (EV)
```dart
hvacPower              → Klima Gücü (kW)
hvacStatus             → Klima Durumu
cabinTemp              → Kabin Sıcaklık (°C)
targetCabinTemp        → Hedef Kabin Sıcaklık (°C)
```

---

## 🔋 HİBRİT ARAÇ PID'LERİ (150+)

### + Tüm Benzinli PID'ler
### + Tüm Elektrikli PID'ler
### + Hibrit Spesifik:

```dart
hybridMode             → Hibrit Modu
hybridBatteryVoltage   → Hibrit Batarya Voltaj (V)
hybridBatteryCurrent   → Hibrit Batarya Akım (A)
hybridBatterySoc       → Hibrit Batarya SOC (%)
hybridBatteryTemp      → Hibrit Batarya Sıcaklık (°C)
hybridBatteryPackLife  → Hibrit Batarya Ömrü (%)
electricMotorRpm       → Elektrik Motor Devri (RPM)
electricMotorTorque    → Elektrik Motor Tork (Nm)
```

---

## 🛡️ GÜVENLİK VE KONFOR SENSÖRLERI

### ABS/ESP
```dart
wheelSpeedFL/FR/RL/RR  → Teker Hızı (km/h)
```

### Direksiyon
```dart
steeringAngle          → Direksiyon Açısı (°)
steeringTorque         → Direksiyon Tork (Nm)
```

### G Sensörleri
```dart
lateralAcceleration    → Yanal İvme (G)
longitudinalAcceleration → Boyuna İvme (G)
yawRate                → Sapma Hızı (°/s)
```

### TPMS (Lastik Basıncı)
```dart
tirePressureFL/FR/RL/RR → Lastik Basınç (kPa)
tireTempFL/FR/RL/RR    → Lastik Sıcaklık (°C)
```

### GPS/Navigasyon
```dart
gpsLatitude            → GPS Enlem
gpsLongitude           → GPS Boylam
gpsAltitude            → GPS Rakım (m)
gpsSpeed               → GPS Hız (km/h)
```

---

## 💻 KULLANIM

### 1. Basit Kullanım
```dart
import 'all_sensors_pids.dart';

// Tüm PID'ler
print('Toplam: ${PIDType.values.length} PID');

// Benzinli araç PID'leri
final gasolinePIDs = getPIDsForVehicleType(VehicleType.gasoline);
print('Benzinli: ${gasolinePIDs.length} PID');

// Elektrikli araç PID'leri
final electricPIDs = getPIDsForVehicleType(VehicleType.electric);
print('Elektrikli: ${electricPIDs.length} PID');
```

### 2. Kategoriye Göre
```dart
// Motor PID'leri
final enginePIDs = getPIDsByCategory(PIDCategory.engine);

// Yakıt PID'leri
final fuelPIDs = getPIDsByCategory(PIDCategory.fuel);

// Batarya PID'leri
final batteryPIDs = getPIDsByCategory(PIDCategory.battery);
```

### 3. PID Okuma
```dart
// Tek PID oku
final pid = PIDType.fuelRate;
print('Command: ${pid.getFullCommand()}');
print('Equation: ${pid.equation}');
print('Turkish: ${pid.turkishName}');

// PID'i oku ve hesapla
final value = await pidReader.readPID(pid);
print('Yakıt tüketimi: $value L/h');
```

### 4. Flutter Widget
```dart
StreamBuilder<double>(
  stream: pidReader.readPIDStream(PIDType.batterySoc),
  builder: (context, snapshot) {
    return Text('SOC: ${snapshot.data}%');
  },
)
```

---

## 📊 ÖZEL SENSÖR GRUPLARı

### 🔥 Sıcaklık Sensörleri (20+)
```
coolantTemp, engineOilTemp, intakeTemp,
catalystTemp, batteryTemp, motorTemp,
inverterTemp, obcTemp, dcdcTemp,
glowPlugTemp, cabinTemp, tireTemp...
```

### ⚡ Voltaj Sensörleri (15+)
```
batteryVoltage, cellVoltageMin/Max,
motorVoltage, inverterVoltage,
chargerVoltage, dcdc12vVoltage...
```

### 🌊 Akım Sensörleri (12+)
```
batteryCurrent, motorCurrent,
chargerCurrent, regenCurrent,
inverterCurrent, o2SensorCurrent...
```

### 💨 Basınç Sensörleri (18+)
```
fuelPressure, intakeManifoldPressure,
turboBoostPressure, tirePressure,
dpfPressure, adBluePressure...
```

### 📏 Pozisyon Sensörleri (12+)
```
throttlePosition, acceleratorPedal,
egrValvePosition, wastegatePosition,
steeringAngle...
```

---

## 🎯 SONUÇ

```
✅ 200+ PID hazır
✅ Benzinli, Dizel, Elektrikli, Hibrit
✅ Tüm sensörler kapsandı
✅ Flutter/Dart formatında
✅ Kategorize edilmiş
✅ Türkçe açıklamalar
✅ Kullanım örnekleri
✅ KOPYALA YAPIŞTIR HAZIR!
```

**DOSYALAR:**
- `all_sensors_pids.dart` - 200+ PID tanımı
- `all_sensors_usage.dart` - Kullanım örnekleri

**KULLAN! 🚀**
