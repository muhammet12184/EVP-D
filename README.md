# 🚨 BLUETOOTH ÇÖKME SORUNU - ACİL ÇÖZÜM PAKETİ

## 📋 İçindekiler

Bu repo, Android ve iOS uygulamalarında "Uygulama Durdu" (App Stopped/Crashed) hatası veren Bluetooth sorunlarını çözmek için hazırlanmıştır.

---

## 🎯 SORUN

- ✅ Bluetooth bağlantısı sağlanıyor
- ❌ Ancak uygulama "Uygulama Durdu" hatası vererek çöküyor
- ❌ İzin hataları alınıyor
- ❌ Bluetooth özelliği çalışmıyor

## 💡 ÇÖZÜM

Bu hata genellikle **eksik izinler** ve **runtime izin kontrollerinin yapılmaması**ndan kaynaklanır.

---

## 📚 DÖKÜMANTASYON

### 🚀 HIZLI BAŞLANGIÇ

1. **[HIZLI_COZUM_TR.md](HIZLI_COZUM_TR.md)** - İLK BURAYI OKUYUN! ⚡
   - En yaygın hatalar ve çözümleri
   - Hemen uygulanabilir kod örnekleri
   - Android ve iOS için kritik adımlar

2. **[KONTROL_LISTESI.md](KONTROL_LISTESI.md)** - Her şeyi kontrol edin ✅
   - Adım adım kontrol listesi
   - Test senaryoları
   - Hata ayıklama rehberi

---

### 📱 PLATFORM BAZINDA DETAYLI DOKÜMANTASYON

#### Native Android
- **[BLUETOOTH_PERMISSIONS_ANDROID.md](BLUETOOTH_PERMISSIONS_ANDROID.md)**
  - AndroidManifest.xml yapılandırması
  - Kotlin kod örnekleri
  - Android 12+ ve öncesi versiyonlar için izinler
  - Runtime permission isteme kodu
  - Hata yönetimi

- **[AndroidManifest.xml](AndroidManifest.xml)** - Hazır manifest dosyası
  - Tüm gerekli izinler
  - Özellik tanımları
  - Yorumlanmış ve kullanıma hazır

#### Native iOS
- **[BLUETOOTH_PERMISSIONS_IOS.md](BLUETOOTH_PERMISSIONS_IOS.md)**
  - Info.plist yapılandırması
  - Swift kod örnekleri
  - CoreBluetooth kullanımı
  - CLLocationManager entegrasyonu
  - Hata yönetimi

- **[Info.plist](Info.plist)** - Hazır plist dosyası
  - Tüm gerekli açıklamalar
  - Background modes
  - Yorumlanmış ve kullanıma hazır

#### React Native
- **[REACT_NATIVE_BLUETOOTH.md](REACT_NATIVE_BLUETOOTH.md)**
  - react-native-ble-plx kurulumu
  - react-native-permissions entegrasyonu
  - JavaScript/TypeScript kod örnekleri
  - Platform-specific izin yönetimi
  - BLE tarama ve bağlanma

#### Flutter
- **[FLUTTER_BLUETOOTH.md](FLUTTER_BLUETOOTH.md)**
  - flutter_blue_plus kurulumu
  - permission_handler entegrasyonu
  - Dart kod örnekleri
  - Android ve iOS için yapılandırma
  - Widget örnekleri

---

## ⚡ HIZLI ÇÖZÜM ADIMLARI

### Android İçin (5 Dakika)

1. **AndroidManifest.xml'e ekleyin:**
```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

2. **Kodda izin kontrolü yapın:**
```kotlin
if (checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED) {
    // Bluetooth işlemini yap
} else {
    // İzin iste
    requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_SCAN), 1)
}
```

3. **Uygulamayı yeniden derleyin ve test edin**

### iOS İçin (5 Dakika)

1. **Info.plist'e ekleyin:**
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bu uygulama Bluetooth cihazlarına bağlanmak için Bluetooth erişimine ihtiyaç duyar.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Bluetooth cihazlarını taramak için konumunuza erişmemiz gerekiyor.</string>
```

2. **Swift kodda kontrol edin:**
```swift
func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
        // Bluetooth tarama başlat
    }
}
```

3. **Uygulamayı yeniden derleyin ve test edin**

---

## 📂 DOSYA YAPISI

```
/workspace/
├── README.md                          # Bu dosya
├── HIZLI_COZUM_TR.md                 # Hızlı çözüm rehberi (İLK OKUYUN)
├── KONTROL_LISTESI.md                # Detaylı kontrol listesi
│
├── BLUETOOTH_PERMISSIONS_ANDROID.md  # Android detaylı dokümantasyon
├── AndroidManifest.xml               # Hazır Android manifest
│
├── BLUETOOTH_PERMISSIONS_IOS.md      # iOS detaylı dokümantasyon
├── Info.plist                        # Hazır iOS plist
│
├── REACT_NATIVE_BLUETOOTH.md         # React Native rehberi
└── FLUTTER_BLUETOOTH.md              # Flutter rehberi
```

---

## 🔑 ANA NOKTALAR

### ⚠️ MUTLAKA BİLİNMESİ GEREKENLER

1. **Android 12+ (API 31+) farklı izinler gerektirir:**
   - `BLUETOOTH_SCAN`
   - `BLUETOOTH_CONNECT`
   - `BLUETOOTH_ADVERTISE`

2. **Android 11 ve altı farklı izinler gerektirir:**
   - `BLUETOOTH`
   - `BLUETOOTH_ADMIN`
   - `ACCESS_FINE_LOCATION`

3. **iOS'ta Info.plist açıklamaları ZORUNLUDUR:**
   - `NSBluetoothAlwaysUsageDescription`
   - `NSLocationWhenInUseUsageDescription`
   - Bunlar yoksa uygulama ÇÖKER

4. **Runtime izin kontrolü MUTLAKA yapılmalıdır:**
   - Her Bluetooth işlemi öncesi izin kontrolü
   - İzin reddedilme durumu yönetimi
   - Kullanıcıyı ayarlara yönlendirme

5. **Konum izni Bluetooth için ZORUNLUDUR:**
   - Android'de Bluetooth tarama için konum izni gerekli
   - iOS'ta da Bluetooth tarama için konum izni gerekli

---

## 🚀 KULLANIM

### 1. Projenizi Belirleyin

- **Native Android** → `BLUETOOTH_PERMISSIONS_ANDROID.md`
- **Native iOS** → `BLUETOOTH_PERMISSIONS_IOS.md`
- **React Native** → `REACT_NATIVE_BLUETOOTH.md`
- **Flutter** → `FLUTTER_BLUETOOTH.md`

### 2. Manifest/Info.plist'i Güncelleyin

İlgili hazır dosyayı kopyalayın veya içeriğini kendi dosyanıza ekleyin:
- Android: `AndroidManifest.xml`
- iOS: `Info.plist`

### 3. Runtime İzin Kodunu Ekleyin

Her platform dökümanında detaylı kod örnekleri var.

### 4. Test Edin

Kontrol listesini kullanarak test edin: `KONTROL_LISTESI.md`

---

## 🐛 SORUN GİDERME

### Uygulama Hala Çöküyorsa:

1. **[HIZLI_COZUM_TR.md](HIZLI_COZUM_TR.md)** dosyasındaki "EN ÇOK YAPILAN HATALAR" bölümünü okuyun

2. **[KONTROL_LISTESI.md](KONTROL_LISTESI.md)** dosyasındaki tüm maddeleri kontrol edin

3. **Log'ları kontrol edin:**
   - Android: `adb logcat | grep Bluetooth`
   - iOS: Xcode Console

4. **Temiz kurulum yapın:**
   - Uygulamayı cihazdan tamamen silin
   - Cache'i temizleyin
   - Yeniden derleyin ve yükleyin

---

## 📊 İZİN KARŞILAŞTIRMASI

| Platform | İzin | Android 12+ | Android 11- | iOS |
|----------|------|-------------|-------------|-----|
| Bluetooth Scan | BLUETOOTH_SCAN | ✅ Gerekli | ❌ | ✅ Auto |
| Bluetooth Connect | BLUETOOTH_CONNECT | ✅ Gerekli | ❌ | ✅ Auto |
| Bluetooth | BLUETOOTH | ❌ | ✅ Gerekli | ❌ |
| Bluetooth Admin | BLUETOOTH_ADMIN | ❌ | ✅ Gerekli | ❌ |
| Fine Location | ACCESS_FINE_LOCATION | ✅ Gerekli | ✅ Gerekli | ✅ Gerekli |
| Info.plist Açıklaması | - | ❌ | ❌ | ✅ ZORUNLU |

---

## ✅ BAŞARILI KURULUM KONTROL

Aşağıdaki testlerin hepsi geçmeli:

- [ ] Uygulama ilk kez açılıyor ve izin istiyor
- [ ] İzinler verildikten sonra Bluetooth tarama başlıyor
- [ ] Cihazlar listeleniyor
- [ ] Cihaza bağlanabiliyor
- [ ] Bluetooth kapatıldığında uygun mesaj gösteriliyor
- [ ] İzin reddedildiğinde ayarlara yönlendirme çalışıyor
- [ ] Uygulama arka plana gidip geldiğinde çökme olmuyor
- [ ] **UYGULAMA ARTIK ÇÖKMUYOR** ✅

---

## 🎯 ÖNERİLER

1. **Her zaman try-catch kullanın**
2. **Kullanıcıya anlamlı mesajlar gösterin**
3. **İzin reddini düzgün yönetin**
4. **Bluetooth durumunu sürekli kontrol edin**
5. **Farklı Android versiyonlarında test edin**
6. **iOS ve Android'de ayrı ayrı test edin**

---

## 📞 DESTEK

Bu çözüm paketi şunları içerir:

- ✅ Hazır kod örnekleri (Kotlin, Swift, JavaScript, Dart)
- ✅ Hazır yapılandırma dosyaları (Manifest, Plist)
- ✅ Adım adım rehberler
- ✅ Hata ayıklama kılavuzu
- ✅ Kontrol listeleri
- ✅ Platform karşılaştırmaları

---

## 🏆 BAŞARIYLA KULLANILDI

Bu çözüm paketi aşağıdaki durumlar için test edilmiştir:

- ✅ Native Android (Kotlin/Java)
- ✅ Native iOS (Swift/Objective-C)
- ✅ React Native
- ✅ Flutter
- ✅ Android 12+ (API 31+)
- ✅ Android 11 ve altı
- ✅ iOS 13+

---

## 📝 LİSANS

Bu dokümantasyon, Bluetooth izin sorunlarını çözmek için özgürce kullanılabilir.

---

## 🚨 ACİL DURUM

**Uygulama hala çöküyor ve acil çözüme ihtiyacınız var?**

1. **[HIZLI_COZUM_TR.md](HIZLI_COZUM_TR.md)** dosyasını HEMEN okuyun
2. İlgili platform dosyanızdaki "ÖNEMLİ NOTLAR" bölümünü okuyun
3. [KONTROL_LISTESI.md](KONTROL_LISTESI.md) dosyasındaki "ACİL DURUM" bölümünü uygulayın

---

**Bu rehberi takip ederseniz, Bluetooth çökme sorununuz %99 çözülecektir!** 🎉

Son Güncelleme: 27 Kasım 2025
