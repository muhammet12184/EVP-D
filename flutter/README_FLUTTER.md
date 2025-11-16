# 🎯 OBD Diagnostics - Flutter/Dart Versiyonu

## ✅ YAPILAN 3 ÖZELLİK

### 1️⃣ Gerçek Yakıt Tüketimi (motor_analyzer.dart)
```dart
class MotorData {
  final double fuelConsumption;    // ✅ L/h - Gerçek PID
  final double instantFuelRate;    // ✅ L/100km
  final double maf;                // ✅ g/s
}
```

### 2️⃣ Rejeneratif Fren (data_analyzer.dart)
```dart
class EVData {
  final double regenPower;         // ✅ kW
  final double regenCurrent;       // ✅ A
  final double regenEnergyTotal;   // ✅ kWh
  final bool isRegenerating;       // ✅ Aktif mi?
  final double motorTorque;        // ✅ Nm
}
```

### 3️⃣ Marka Tespiti + UI (pid_router.dart + vehicle_debug_ui.dart)
```dart
enum VehicleBrand {
  nissan, renault, hyundai, kia, bmw, tesla,
  mercedes, audi, volkswagen, toyota, honda,
  byd, mg, togg, // 🇹🇷 TOGG dahil!
  // ... 17+ marka
}

// UI Widgets
VehicleDebugPanel()  // Detaylı panel
VehicleDebugBadge()  // Kompakt rozet
```

---

## 📦 DOSYALAR (Flutter/Dart)

```
flutter/
├── motor_analyzer.dart          ⭐ Yakıt tüketimi
├── data_analyzer.dart           ⭐ Regen desteği
├── pid_router.dart              ⭐ Marka tespiti
├── pid_type.dart                📡 40+ PID tanımı
├── pid_reader.dart              🔌 Interface + Mock
├── vehicle_debug_ui.dart        📱 UI widgets
├── main.dart                    🚀 Demo app
├── pubspec.yaml                 📋 Dependencies
└── README_FLUTTER.md            📖 Bu dosya
```

---

## 🚀 KURULUM

### 1. Dosyaları Kopyalayın

```bash
# Flutter projenizin lib/ klasörüne kopyalayın
cp flutter/*.dart your_flutter_project/lib/

# pubspec.yaml'ı güncelleyin
cp flutter/pubspec.yaml your_flutter_project/
```

### 2. Dependencies Yükleyin

```bash
cd your_flutter_project
flutter pub get
```

### 3. Import Edin

```dart
import 'motor_analyzer.dart';
import 'data_analyzer.dart';
import 'pid_router.dart';
import 'pid_reader.dart';
import 'vehicle_debug_ui.dart';
```

---

## 💻 KULLANIM

### Basit Kullanım

```dart
// 1. PID Reader oluştur
final pidReader = MockPIDReader(); // veya gerçek implementation

// 2. Analyzer'ları başlat
final motorAnalyzer = MotorAnalyzer(pidReader);
final pidRouter = PIDRouter(pidReader);

// 3. Marka tespit et
final detection = await pidRouter.detectVehicle();
print('Marka: ${detection.brand.displayName}');

// 4. Yakıt tüketimi izle
motorAnalyzer.monitorMotorData().listen((data) {
  print('Yakıt: ${data.fuelConsumption} L/h');
});
```

### UI ile Kullanım

```dart
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PIDReader pidReader;
  late final PIDRouter pidRouter;
  bool _showDebug = true;

  @override
  void initState() {
    super.initState();
    pidReader = MockPIDReader();
    pidRouter = PIDRouter(pidReader);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD Diagnostics'),
        actions: [
          // Kompakt rozet
          VehicleDebugBadge(
            pidRouter: pidRouter,
            onClick: () {
              setState(() {
                _showDebug = !_showDebug;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mevcut içeriğiniz...
          YourMainContent(),

          // Debug paneli (floating)
          if (_showDebug)
            Positioned(
              bottom: 16,
              right: 16,
              child: VehicleDebugPanel(
                pidRouter: pidRouter,
                onClose: () {
                  setState(() {
                    _showDebug = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
```

---

## 📱 STREAM KULLANIMI

### Yakıt Tüketimi Stream

```dart
StreamBuilder<MotorData>(
  stream: motorAnalyzer.monitorMotorData(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }

    final data = snapshot.data!;
    return Column(
      children: [
        Text('Fuel: ${data.fuelConsumption.toStringAsFixed(2)} L/h'),
        Text('Instant: ${data.instantFuelRate.toStringAsFixed(2)} L/100km'),
        Text('MAF: ${data.maf.toStringAsFixed(1)} g/s'),
      ],
    );
  },
)
```

### Regen İzleme Stream

```dart
StreamBuilder<EVData>(
  stream: dataAnalyzer.monitorEVData(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }

    final data = snapshot.data!;
    return Card(
      color: data.isRegenerating ? Colors.purple : Colors.grey,
      child: Column(
        children: [
          Text('REGEN ${data.isRegenerating ? "ACTIVE" : "IDLE"}'),
          Text('${data.regenPower.toStringAsFixed(1)} kW'),
          Text('Total: ${data.regenEnergyTotal.toStringAsFixed(2)} kWh'),
        ],
      ),
    );
  },
)
```

---

## 🧪 TEST

### Mock Test

```dart
void main() {
  test('Fuel consumption test', () async {
    final mockReader = MockPIDReader();
    mockReader.setMockValue(PIDType.fuelRate, 8.5);
    
    final analyzer = MotorAnalyzer(mockReader);
    final data = await analyzer.monitorMotorData().first;
    
    expect(data.fuelConsumption, 8.5);
  });

  test('Regen detection test', () async {
    final mockReader = MockPIDReader();
    mockReader.setMockValue(PIDType.regenPower, 20.0);
    
    final analyzer = DataAnalyzer(mockReader, vehicleBrand: 'Nissan');
    final data = await analyzer.monitorEVData().first;
    
    expect(data.isRegenerating, true);
    expect(data.regenPower, 20.0);
  });

  test('Vehicle detection test', () async {
    final mockReader = MockPIDReader();
    final router = PIDRouter(mockReader);
    
    final result = await router.detectVehicle();
    
    expect(result.brand, isNotNull);
  });
}
```

---

## 📋 DEPENDENCIES

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.18.0  # Date formatting için

# Opsiyonel - State management
# provider: ^6.0.0
# riverpod: ^2.0.0
# bloc: ^8.0.0
```

---

## 🔧 GERÇEK OBD ENTEGRASYONU

Mock yerine gerçek OBD adaptörü için:

```dart
class BluetoothPIDReader implements PIDReader {
  // Bluetooth bağlantısı
  // flutter_bluetooth_serial paketi kullanın
  
  @override
  Future<double> readPID(PIDType pidType) async {
    // AT komutu gönder
    // Yanıtı parse et
    // Değeri hesapla ve döndür
  }
  
  @override
  Future<String> sendRawCommand(String command, String header) async {
    // ELM327 komutları gönder
  }
}
```

**Önerilen Paketler:**
- `flutter_bluetooth_serial` - Bluetooth bağlantısı
- `flutter_blue_plus` - BLE bağlantısı
- `usb_serial` - USB OBD adaptörleri

---

## 🎨 UI ÖZELLEŞTİRME

### Renkleri Değiştir

```dart
// vehicle_debug_ui.dart içinde
Color _getColorForConfidence(int confidence) {
  if (confidence >= 90) return Colors.green;     // Yeşil
  if (confidence >= 70) return Colors.blue;      // Mavi
  if (confidence >= 50) return Colors.amber;     // Sarı
  return Colors.red;                             // Kırmızı
}
```

### Panel Boyutu

```dart
VehicleDebugPanel(
  pidRouter: pidRouter,
  onClose: () {},
)

// vehicle_debug_ui.dart içinde maxWidth değiştir:
constraints: const BoxConstraints(maxWidth: 400), // Varsayılan
```

---

## 📊 ÖZELLİK KARŞILAŞTIRMASI

| Özellik | Kotlin | Flutter/Dart |
|---------|--------|--------------|
| **Syntax** | Java-like | Modern, clean |
| **Async** | Coroutines | async/await + Streams |
| **UI** | Jetpack Compose | Flutter Widgets |
| **Hot Reload** | ❌ Yok | ✅ Var (çok hızlı!) |
| **Cross-platform** | ❌ Android only | ✅ iOS + Android + Web |
| **Performance** | ✅ Native | ✅ Near-native |

---

## 🚀 DEMO ÇALIŞTIRMA

```bash
# Flutter projesine git
cd flutter

# Dependencies yükle
flutter pub get

# Android emulator başlat
flutter emulators --launch <emulator_id>

# veya fiziksel cihaz bağla

# Uygulamayı çalıştır
flutter run

# Hot reload için: r tuşu
# Hot restart için: R tuşu
```

---

## 📱 PLATFORM DESTEĞİ

### Android
```yaml
android/app/build.gradle:
minSdkVersion 21
targetSdkVersion 33
```

### iOS
```yaml
ios/Podfile:
platform :ios, '12.0'
```

### Bluetooth İzinleri

**Android (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
```

**iOS (Info.plist):**
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>OBD adapter bağlantısı için Bluetooth gerekli</string>
```

---

## 💡 İPUÇLARI

### 1. State Management
```dart
// Provider kullanımı (opsiyonel)
class OBDProvider extends ChangeNotifier {
  final MotorAnalyzer motorAnalyzer;
  MotorData? currentData;
  
  OBDProvider(this.motorAnalyzer) {
    motorAnalyzer.monitorMotorData().listen((data) {
      currentData = data;
      notifyListeners();
    });
  }
}
```

### 2. Error Handling
```dart
StreamBuilder<MotorData>(
  stream: motorAnalyzer.monitorMotorData(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Hata: ${snapshot.error}');
    }
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    return YourWidget(snapshot.data!);
  },
)
```

### 3. Performance
```dart
// Stream'i kontrol et
StreamSubscription? _subscription;

@override
void dispose() {
  _subscription?.cancel(); // Memory leak önle
  super.dispose();
}
```

---

## 🎯 SONUÇ

✅ **Flutter/Dart versiyonu hazır!**

**Avantajlar:**
- 🚀 Hot reload (çok hızlı geliştirme)
- 📱 Cross-platform (iOS + Android + Web)
- 🎨 Güzel UI (Material Design)
- 💨 Performanslı
- 📦 Kolay paket yönetimi

**Kullanım:**
1. Dosyaları `lib/` klasörüne kopyala
2. `flutter pub get`
3. `flutter run`
4. **Kullanmaya başla!** 🎉

---

**📞 Sorular için README dosyalarına bakın!**
