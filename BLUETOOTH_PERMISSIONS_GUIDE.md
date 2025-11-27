# 🚨 ACİL: Bluetooth İzinleri Rehberi (Android & iOS)

## SORUN: "Uygulama Durdu" Hatası - Bluetooth Bağlantısında Crash

Bu hata genellikle **eksik izinlerden** veya **runtime permission kontrolü yapılmamasından** kaynaklanır.

---

## 📱 ANDROID İZİNLERİ

### AndroidManifest.xml'e Eklenecek İzinler:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- ============ BLUETOOTH İZİNLERİ ============ -->
    
    <!-- Android 12+ (API 31+) için YENİ izinler -->
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" 
        android:usesPermissionFlags="neverForLocation" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    
    <!-- Android 11 ve altı için ESKİ izinler (geriye uyumluluk) -->
    <uses-permission android:name="android.permission.BLUETOOTH" 
        android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" 
        android:maxSdkVersion="30" />
    
    <!-- ============ KONUM İZİNLERİ ============ -->
    <!-- BLE taraması için ZORUNLU (Android 6-11 arası) -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <!-- Arka planda Bluetooth kullanımı için -->
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    
    <!-- ============ BLUETOOTH FEATURE ============ -->
    <uses-feature android:name="android.hardware.bluetooth" android:required="true" />
    <uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />
    <uses-feature android:name="android.hardware.location.gps" android:required="false" />

</manifest>
```

### ⚠️ KRİTİK: Runtime Permission Kontrolü (Kotlin/Java)

```kotlin
// Android 12+ için
private val BLUETOOTH_PERMISSIONS_S = arrayOf(
    Manifest.permission.BLUETOOTH_SCAN,
    Manifest.permission.BLUETOOTH_CONNECT,
    Manifest.permission.BLUETOOTH_ADVERTISE
)

// Android 11 ve altı için
private val BLUETOOTH_PERMISSIONS_LEGACY = arrayOf(
    Manifest.permission.BLUETOOTH,
    Manifest.permission.BLUETOOTH_ADMIN,
    Manifest.permission.ACCESS_FINE_LOCATION,
    Manifest.permission.ACCESS_COARSE_LOCATION
)

fun checkAndRequestPermissions() {
    val permissionsToRequest = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        BLUETOOTH_PERMISSIONS_S
    } else {
        BLUETOOTH_PERMISSIONS_LEGACY
    }
    
    val missingPermissions = permissionsToRequest.filter {
        ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
    }
    
    if (missingPermissions.isNotEmpty()) {
        ActivityCompat.requestPermissions(
            this, 
            missingPermissions.toTypedArray(), 
            REQUEST_BLUETOOTH_PERMISSIONS
        )
    } else {
        // İzinler tamam, Bluetooth'u başlat
        startBluetoothOperations()
    }
}

// İzin sonucu kontrolü
override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    
    if (requestCode == REQUEST_BLUETOOTH_PERMISSIONS) {
        if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
            startBluetoothOperations()
        } else {
            // Kullanıcı izin vermedi - uyarı göster
            showPermissionDeniedDialog()
        }
    }
}
```

### 🔧 Bluetooth Açık mı Kontrolü:

```kotlin
private fun checkBluetoothEnabled(): Boolean {
    val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    val bluetoothAdapter = bluetoothManager.adapter
    
    if (bluetoothAdapter == null) {
        // Cihaz Bluetooth desteklemiyor
        return false
    }
    
    if (!bluetoothAdapter.isEnabled) {
        // Bluetooth kapalı - açmasını iste
        val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
        return false
    }
    
    return true
}
```

---

## 🍎 iOS İZİNLERİ

### Info.plist'e Eklenecek Anahtarlar:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>

    <!-- ============ BLUETOOTH İZİNLERİ ============ -->
    
    <!-- iOS 13+ için ZORUNLU -->
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>Bu uygulama araç teşhis cihazına bağlanmak için Bluetooth kullanır.</string>
    
    <!-- iOS 13 öncesi için (geriye uyumluluk) -->
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>Bu uygulama araç teşhis cihazına bağlanmak için Bluetooth kullanır.</string>
    
    <!-- ============ KONUM İZİNLERİ ============ -->
    <!-- BLE için bazen gerekli -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Bluetooth cihazlarını bulmak için konum izni gereklidir.</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Arka planda Bluetooth bağlantısı için konum izni gereklidir.</string>
    
    <!-- ============ ARKA PLAN MODLARI ============ -->
    <key>UIBackgroundModes</key>
    <array>
        <string>bluetooth-central</string>
        <string>bluetooth-peripheral</string>
    </array>

</dict>
</plist>
```

### ⚠️ KRİTİK: Swift ile İzin Kontrolü:

```swift
import CoreBluetooth
import CoreLocation

class BluetoothManager: NSObject, CBCentralManagerDelegate, CLLocationManagerDelegate {
    
    var centralManager: CBCentralManager!
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        // Bluetooth Manager başlat
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Konum Manager başlat (BLE için gerekebilir)
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // BLUETOOTH DURUMU KONTROLÜ
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("✅ Bluetooth açık - taramaya başlanabilir")
            startScanning()
            
        case .poweredOff:
            print("❌ Bluetooth kapalı - kullanıcıyı uyar")
            showBluetoothOffAlert()
            
        case .unauthorized:
            print("❌ Bluetooth izni verilmemiş")
            showPermissionAlert()
            
        case .unsupported:
            print("❌ Bu cihaz Bluetooth desteklemiyor")
            
        case .resetting:
            print("⚠️ Bluetooth sıfırlanıyor...")
            
        case .unknown:
            print("⚠️ Bluetooth durumu bilinmiyor")
            
        @unknown default:
            print("⚠️ Bilinmeyen Bluetooth durumu")
        }
    }
    
    // KONUM İZNİ KONTROLÜ
    func checkLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            showLocationPermissionAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Konum izni mevcut")
            
        @unknown default:
            break
        }
    }
    
    func startScanning() {
        // Önce izinleri kontrol et
        guard centralManager.state == .poweredOn else {
            print("❌ Bluetooth hazır değil")
            return
        }
        
        // OBD-II cihazları için tipik servis UUID'leri
        let serviceUUIDs: [CBUUID]? = nil // Tüm cihazları tara
        // veya belirli servisler için:
        // let serviceUUIDs = [CBUUID(string: "FFF0"), CBUUID(string: "FFE0")]
        
        centralManager.scanForPeripherals(withServices: serviceUUIDs, options: nil)
    }
}
```

---

## 🔥 CRASH'İ ÖNLEMEK İÇİN KONTROL LİSTESİ

### Android için:
- [ ] `AndroidManifest.xml`'e tüm izinler eklendi mi?
- [ ] Android 12+ için yeni BLUETOOTH_SCAN/CONNECT izinleri var mı?
- [ ] Runtime permission kontrolü yapılıyor mu?
- [ ] Bluetooth açık mı kontrol ediliyor mu?
- [ ] Konum servisleri açık mı kontrol ediliyor mu?
- [ ] Try-catch ile SecurityException yakalanıyor mu?

### iOS için:
- [ ] `Info.plist`'e tüm açıklama metinleri eklendi mi?
- [ ] `NSBluetoothAlwaysUsageDescription` var mı?
- [ ] Arka plan modları eklendi mi (gerekiyorsa)?
- [ ] `CBCentralManagerDelegate` state kontrolü yapılıyor mu?

---

## 🛠️ HATA AYIKLAMA

### Android Logcat Filtreleri:
```bash
adb logcat | grep -E "(BluetoothAdapter|Permission|SecurityException)"
```

### Sık Karşılaşılan Hatalar:

| Hata | Sebep | Çözüm |
|------|-------|-------|
| `SecurityException` | Runtime izin eksik | `checkSelfPermission()` ekle |
| `NullPointerException` | BluetoothAdapter null | Bluetooth desteği kontrol et |
| `IllegalStateException` | BT kapalıyken işlem | Önce BT durumu kontrol et |
| "Uygulama Durdu" | İzin reddedildi/crash | Try-catch ekle |

---

## 📋 FLUTTER / REACT NATIVE İÇİN

### Flutter (flutter_blue_plus paketi):

```yaml
# pubspec.yaml
dependencies:
  flutter_blue_plus: ^1.31.0
  permission_handler: ^11.0.0
```

```dart
// Dart kodu
import 'package:permission_handler/permission_handler.dart';

Future<void> requestBluetoothPermissions() async {
  if (Platform.isAndroid) {
    // Android 12+
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    // Android 11 ve altı için konum da gerekli
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }
  
  if (Platform.isIOS) {
    if (await Permission.bluetooth.isDenied) {
      await Permission.bluetooth.request();
    }
  }
}
```

### React Native (react-native-ble-plx):

```javascript
import { PermissionsAndroid, Platform } from 'react-native';
import { BleManager } from 'react-native-ble-plx';

async function requestBluetoothPermissions() {
  if (Platform.OS === 'android') {
    const apiLevel = Platform.Version;
    
    if (apiLevel >= 31) {
      // Android 12+
      const granted = await PermissionsAndroid.requestMultiple([
        PermissionsAndroid.PERMISSIONS.BLUETOOTH_SCAN,
        PermissionsAndroid.PERMISSIONS.BLUETOOTH_CONNECT,
      ]);
      
      return Object.values(granted).every(
        status => status === PermissionsAndroid.RESULTS.GRANTED
      );
    } else {
      // Android 11 ve altı
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION
      );
      
      return granted === PermissionsAndroid.RESULTS.GRANTED;
    }
  }
  
  return true; // iOS için Info.plist yeterli
}
```

---

## ✅ ÖZET: HEMEN YAPIN

1. **Android**: `AndroidManifest.xml`'e yukarıdaki TÜM izinleri ekleyin
2. **Android**: Runtime permission kontrolü MUTLAKA ekleyin
3. **iOS**: `Info.plist`'e `NSBluetoothAlwaysUsageDescription` ekleyin
4. **Her ikisi**: Bluetooth açık mı kontrolü ekleyin
5. **Her ikisi**: Try-catch ile hataları yakalayın

---

*Oluşturulma: 2024 - Bluetooth Crash Düzeltme Rehberi*
