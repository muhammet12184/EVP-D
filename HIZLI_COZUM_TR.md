# 🚨 ACİL BLUETOOTH ÇÖKME SORUNU ÇÖZÜMÜ

## SORUN: "Uygulama Durdu" Hatası

Bu hata genellikle **eksik izinler** ve **runtime izin kontrolü yapılmaması**ndan kaynaklanır.

---

## ⚡ HIZLI ÇÖZÜM - HEMEN YAPIN

### 📱 ANDROID İÇİN

#### 1. AndroidManifest.xml dosyanızı açın ve şunları ekleyin:

```xml
<!-- Android 12+ için -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />

<!-- Android 11 ve altı için -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />

<!-- KONUM İZİNLERİ (BLUETOOTH İÇİN ZORUNLU) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### 2. Runtime İzin Kontrolü MUTLAKA YAPIN

**ÇÖKMEYE SEBEP OLAN KOD (YANLIŞ):**
```kotlin
// ❌ YANLIŞ - İzin kontrolü yok
bluetoothAdapter.startDiscovery()
```

**DOĞRU KOD:**
```kotlin
// ✅ DOĞRU - İzin kontrolü ile
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
    if (checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED) {
        bluetoothAdapter.startDiscovery()
    } else {
        // İzin iste
        requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_SCAN), 1)
    }
} else {
    if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
        bluetoothAdapter.startDiscovery()
    } else {
        // İzin iste
        requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 1)
    }
}
```

---

### 🍎 iOS İÇİN

#### 1. Info.plist dosyanızı açın ve MUTLAKA şunları ekleyin:

```xml
<!-- BLUETOOTH İZNİ - BU OLMADAN UYGULAMA ÇÖKER -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bu uygulama Bluetooth cihazlarına bağlanmak için Bluetooth erişimine ihtiyaç duyar.</string>

<key>NSBluetoothPeripheralUsageDescription</key>
<string>Bu uygulama Bluetooth cihazlarıyla iletişim kurmak için Bluetooth erişimine ihtiyaç duyar.</string>

<!-- KONUM İZNİ - BLUETOOTH İÇİN GEREKLİ -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Bluetooth cihazlarını taramak için konumunuza erişmemiz gerekiyor.</string>
```

#### 2. Swift'te Bluetooth Durumunu Kontrol Edin

**ÇÖKMEYE SEBEP OLAN KOD (YANLIŞ):**
```swift
// ❌ YANLIŞ - Durum kontrolü yok
centralManager.scanForPeripherals(withServices: nil)
```

**DOĞRU KOD:**
```swift
// ✅ DOĞRU - Durum kontrolü ile
func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
        centralManager.scanForPeripherals(withServices: nil)
    } else {
        print("Bluetooth hazır değil: \(central.state)")
    }
}
```

---

## 📋 KONTROL LİSTESİ - HEMEN KONTROL EDİN

### Android:
- [ ] AndroidManifest.xml'de BLUETOOTH_SCAN, BLUETOOTH_CONNECT izinleri var mı?
- [ ] AndroidManifest.xml'de ACCESS_FINE_LOCATION izni var mı?
- [ ] Her Bluetooth işlemi öncesi runtime izin kontrolü yapılıyor mu?
- [ ] Android 12+ ve altı versiyonlar için farklı izinler kontrol ediliyor mu?

### iOS:
- [ ] Info.plist'te NSBluetoothAlwaysUsageDescription var mı?
- [ ] Info.plist'te NSLocationWhenInUseUsageDescription var mı?
- [ ] CBCentralManager durumu kontrol ediliyor mu?
- [ ] .poweredOn durumunda mı işlem yapılıyor?

---

## 🔧 TEST ETMEK İÇİN

### Android'de Test:

1. Uygulamayı kaldırın
2. Yeniden yükleyin
3. Bluetooth özelliğini açtığınızda izin isteyecek
4. İzin verin
5. Artık çökmeden çalışmalı

### iOS'ta Test:

1. Uygulamayı kaldırın
2. Yeniden derleyin ve yükleyin
3. İlk Bluetooth işleminde izin isteyecek
4. İzin verin
5. Artık çökmeden çalışmalı

---

## ⚠️ ÖNEMLİ UYARILAR

1. **Info.plist (iOS) veya AndroidManifest.xml'de eksik izin = UYGULAMA ÇÖKER**
2. **Runtime izin kontrolü YAPMADAN Bluetooth işlemi YAPMAYIN**
3. **Android 12+ farklı izinler gerektiriyor - versiyona göre kontrol yapın**
4. **iOS'ta konum izni olmadan Bluetooth taraması YAPAMAZ**
5. **Her Bluetooth API çağrısı öncesi DURUM KONTROL EDİN**

---

## 📞 DAHA FAZLA DETAY İÇİN

- **Android detaylı dokümantasyon:** `BLUETOOTH_PERMISSIONS_ANDROID.md`
- **iOS detaylı dokümantasyon:** `BLUETOOTH_PERMISSIONS_IOS.md`
- **Örnek AndroidManifest.xml:** `AndroidManifest.xml`
- **Örnek Info.plist:** `Info.plist`

---

## 🎯 EN ÇOK YAPILAN HATALAR

### Hata 1: İzin kontrolü yapmadan Bluetooth işlemi
```kotlin
// ❌ YANLIŞ
bluetoothAdapter.startDiscovery()

// ✅ DOĞRU
if (hasPermission()) {
    bluetoothAdapter.startDiscovery()
}
```

### Hata 2: iOS Info.plist'e açıklama eklememek
```xml
<!-- ❌ YANLIŞ - Eksik, uygulama çöker -->

<!-- ✅ DOĞRU -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Açıklama...</string>
```

### Hata 3: Android 12+ için yeni izinleri eklememek
```xml
<!-- ❌ YANLIŞ - Sadece eski izinler -->
<uses-permission android:name="android.permission.BLUETOOTH" />

<!-- ✅ DOĞRU - Yeni izinler de eklenmeli -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

---

## 💡 HIZLI İPUÇLARI

1. **Her zaman try-catch kullanın**
2. **Bluetooth'un açık olduğunu kontrol edin**
3. **Kullanıcıya açıklayıcı mesajlar gösterin**
4. **İzin reddedilirse ayarlara yönlendirin**
5. **Logları kontrol edin - hatayı gösterecektir**

---

## 🚀 İYİLEŞTİRME ÖNERİLERİ

1. İzin durumunu bir state'te tutun
2. İzin isteme akışını kullanıcı dostu yapın
3. Bluetooth kapalıysa kullanıcıyı bilgilendirin
4. Background modunda çalışma gerekiyorsa ek izinler ekleyin
5. Cihaz Bluetooth'u desteklemiyorsa uygun mesaj gösterin

---

**Bu adımları uyguladıktan sonra uygulama artık çökmeyecektir!** ✅
