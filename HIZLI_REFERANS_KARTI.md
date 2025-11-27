# 📇 BLUETOOTH İZİNLERİ - HIZLI REFERANS KARTI

## 🔴 ACİL: Uygulama Çöküyor? Bu İzinleri HEMEN Ekleyin!

---

## 📱 ANDROID

### AndroidManifest.xml'e Ekle:

```xml
<!-- Android 12+ -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

<!-- Android 11 ve altı -->
<uses-permission android:name="android.permission.BLUETOOTH" 
    android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" 
    android:maxSdkVersion="30" />

<!-- Konum (ZORUNLU) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

### Kod Şablonu (Kotlin):

```kotlin
// İzin kontrolü
if (Build.VERSION.SDK_INT >= 31) {
    if (checkSelfPermission(BLUETOOTH_SCAN) == PERMISSION_GRANTED) {
        // Bluetooth işlemi
    } else {
        requestPermissions(arrayOf(BLUETOOTH_SCAN, BLUETOOTH_CONNECT), 1)
    }
} else {
    if (checkSelfPermission(ACCESS_FINE_LOCATION) == PERMISSION_GRANTED) {
        // Bluetooth işlemi
    } else {
        requestPermissions(arrayOf(ACCESS_FINE_LOCATION), 1)
    }
}
```

---

## 🍎 iOS

### Info.plist'e Ekle:

```xml
<!-- Bluetooth İzni - BU OLMADAN ÇÖKER -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth cihazlarına bağlanmak için gerekli.</string>

<!-- Konum İzni - ZORUNLU -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Bluetooth cihazlarını taramak için gerekli.</string>
```

### Kod Şablonu (Swift):

```swift
// Durum kontrolü
func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOn:
        // Bluetooth tarama başlat
        centralManager.scanForPeripherals(withServices: nil)
    case .unauthorized:
        // İzin hatası
        print("Bluetooth izni yok")
    case .poweredOff:
        // Bluetooth kapalı
        print("Bluetooth kapalı")
    default:
        break
    }
}
```

---

## ⚛️ REACT NATIVE

### Kurulum:

```bash
npm install react-native-permissions react-native-ble-plx
cd ios && pod install
```

### Kod Şablonu:

```javascript
import { request, PERMISSIONS } from 'react-native-permissions';

// Android
if (Platform.OS === 'android') {
  const result = await request(
    Platform.Version >= 31 
      ? PERMISSIONS.ANDROID.BLUETOOTH_SCAN 
      : PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION
  );
}

// iOS
if (Platform.OS === 'ios') {
  const result = await request(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
}
```

---

## 🐦 FLUTTER

### pubspec.yaml:

```yaml
dependencies:
  permission_handler: ^11.0.1
  flutter_blue_plus: ^1.14.0
```

### Kod Şablonu:

```dart
import 'package:permission_handler/permission_handler.dart';

// İzin iste
Future<void> requestPermissions() async {
  if (Platform.isAndroid) {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  } else {
    await [
      Permission.bluetooth,
      Permission.locationWhenInUse,
    ].request();
  }
}
```

---

## ⚠️ ÖNEMLİ HATIRLATMALAR

| ❌ YANLIŞ | ✅ DOĞRU |
|-----------|----------|
| İzin kontrolü yapmadan Bluetooth kullanma | Her işlem öncesi izin kontrolü |
| iOS Info.plist'te açıklama yok | Tüm açıklamalar ekli |
| Sadece manifest'e ekleme | Manifest + Runtime izin |
| Tek Android versiyonu için kod | Versiyon kontrolü ile kod |

---

## 🚨 EN ÇOK YAPILAN 5 HATA

1. **Info.plist açıklaması eksik (iOS)** → ÇÖKME
2. **Runtime izin kontrolü yok (Android)** → ÇÖKME
3. **Android 12+ için yeni izinler yok** → ÇALIŞMAZ
4. **Konum izni eksik** → ÇALIŞMAZ
5. **Bluetooth durum kontrolü yok** → ÇÖKME

---

## ✅ HIZLI TEST

1. [ ] İzinler manifest/plist'e eklendi
2. [ ] Runtime izin kodu eklendi
3. [ ] Bluetooth durum kontrolü var
4. [ ] Try-catch kullanılıyor
5. [ ] Uygulama test edildi

---

## 📞 HATA MESAJLARI

| Hata | Çözüm |
|------|-------|
| SecurityException | İzinleri manifest'e ekle |
| Permission denied | Runtime izin iste |
| Bluetooth unauthorized | Info.plist'e açıklama ekle |
| App crashed | İzin kontrolü ekle |

---

## 🎯 KRITIK NOKTALAR

### Android:
- ✅ Android 12+ → BLUETOOTH_SCAN + BLUETOOTH_CONNECT
- ✅ Android 11- → BLUETOOTH + ACCESS_FINE_LOCATION
- ✅ Her zaman runtime izin kontrolü

### iOS:
- ✅ NSBluetoothAlwaysUsageDescription ZORUNLU
- ✅ NSLocationWhenInUseUsageDescription ZORUNLU
- ✅ CBCentralManager durum kontrolü

---

## 💾 YEDEK ÇÖZÜM

Hala çalışmıyorsa:

```bash
# 1. Temizle
./gradlew clean (Android)
rm -rf ios/Pods (iOS)

# 2. Uygulamayı sil
# Cihazdan tamamen kaldır

# 3. Yeniden kur
# Derle ve yükle

# 4. İzinleri yeniden ver
```

---

## 📚 DETAYLI DÖKÜMANTASYON

- `HIZLI_COZUM_TR.md` → Adım adım çözüm
- `KONTROL_LISTESI.md` → Test listesi
- `BLUETOOTH_PERMISSIONS_ANDROID.md` → Android detay
- `BLUETOOTH_PERMISSIONS_IOS.md` → iOS detay

---

## 🎉 BAŞARILI KURULUM

✅ Uygulama açılıyor
✅ İzin istiyor
✅ Bluetooth tarama çalışıyor
✅ Cihazlar bulunuyor
✅ Bağlantı kuruluyor
✅ **ÇÖKME YOK!**

---

**Bu kartı yazdırın veya kaydedin!** 📝

*Son Güncelleme: 27 Kasım 2025*
