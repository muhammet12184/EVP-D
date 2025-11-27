# ✅ BLUETOOTH İZİNLERİ KONTROL LİSTESİ

## 🎯 "Uygulama Durdu" Hatasını Çözmek İçin Kontrol Edin

---

## 📱 ANDROID KONTROL LİSTESİ

### 1. AndroidManifest.xml Kontrolleri

#### Android 12+ (API 31+) için:
- [ ] `<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />` eklendi mi?
- [ ] `<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />` eklendi mi?
- [ ] `<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />` eklendi mi?

#### Android 11 ve altı için:
- [ ] `<uses-permission android:name="android.permission.BLUETOOTH" />` eklendi mi?
- [ ] `<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />` eklendi mi?

#### Konum İzinleri (TÜM VERSİYONLAR için ZORUNLU):
- [ ] `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />` eklendi mi?
- [ ] `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />` eklendi mi?

#### Bluetooth Özellikleri:
- [ ] `<uses-feature android:name="android.hardware.bluetooth" />` eklendi mi?
- [ ] `<uses-feature android:name="android.hardware.bluetooth_le" />` eklendi mi?

### 2. Kod Kontrolleri

#### Runtime İzin Kontrolü:
- [ ] Her Bluetooth işlemi öncesi izin kontrolü yapılıyor mu?
- [ ] Android versiyonuna göre farklı izinler kontrol ediliyor mu?
- [ ] İzin reddedildiğinde kullanıcıya bilgi veriliyor mu?
- [ ] İzin isteme kodu ActivityResultContracts ile yapılmış mı?

#### Bluetooth Durum Kontrolü:
- [ ] Bluetooth açık/kapalı kontrolü yapılıyor mu?
- [ ] BluetoothAdapter null kontrolü yapılıyor mu?
- [ ] Bluetooth desteği olmayan cihazlar için kontrol var mı?

#### Hata Yönetimi:
- [ ] Try-catch blokları kullanılıyor mu?
- [ ] SecurityException yakalanıyor mu?
- [ ] Kullanıcıya anlamlı hata mesajları gösteriliyor mu?

### 3. build.gradle Kontrolleri

- [ ] `compileSdkVersion 33` veya üzeri mi?
- [ ] `targetSdkVersion 33` veya üzeri mi?
- [ ] `minSdkVersion 21` veya üzeri mi?

---

## 🍎 iOS KONTROL LİSTESİ

### 1. Info.plist Kontrolleri

#### Bluetooth İzinleri (ZORUNLU - Yoksa uygulama ÇÖKER):
- [ ] `NSBluetoothAlwaysUsageDescription` anahtarı ve açıklaması eklendi mi?
- [ ] `NSBluetoothPeripheralUsageDescription` anahtarı ve açıklaması eklendi mi?

#### Konum İzinleri (ZORUNLU):
- [ ] `NSLocationWhenInUseUsageDescription` anahtarı ve açıklaması eklendi mi?
- [ ] `NSLocationAlwaysAndWhenInUseUsageDescription` anahtarı eklendi mi? (opsiyonel)

#### Arka Plan Modları (Opsiyonel):
- [ ] Arka plan çalışması gerekiyorsa `UIBackgroundModes` eklendi mi?
- [ ] `bluetooth-central` değeri eklendi mi?

### 2. Kod Kontrolleri

#### CBCentralManager Kontrolleri:
- [ ] CBCentralManager delegate ayarlandı mı?
- [ ] `centralManagerDidUpdateState` metodu implement edildi mi?
- [ ] Bluetooth durumu kontrol ediliyor mu (.poweredOn, .unauthorized, vb.)?
- [ ] Her durum için uygun işlem yapılıyor mu?

#### Konum İzni Kontrolleri:
- [ ] CLLocationManager oluşturuldu mu?
- [ ] Konum izni runtime'da isteniyor mu?
- [ ] İzin durumu değişiklikleri dinleniyor mu?

#### Hata Yönetimi:
- [ ] Her durum için guard veya if-let kontrolü yapılıyor mu?
- [ ] Kullanıcıya açıklayıcı alert'ler gösteriliyor mu?
- [ ] İzin reddedildiğinde ayarlara yönlendirme var mı?

### 3. Xcode Proje Ayarları

- [ ] Deployment Target iOS 13.0 veya üzeri mi?
- [ ] Bluetooth capability eklendi mi?
- [ ] Background Modes (opsiyonel) aktif mi?

---

## 🔄 CROSS-PLATFORM KONTROL LİSTESİ

### React Native

#### Paketler:
- [ ] `react-native-permissions` yüklendi mi?
- [ ] `react-native-ble-plx` veya `react-native-bluetooth-classic` yüklendi mi?
- [ ] iOS için pod install yapıldı mı?

#### İzin Kontrolü:
- [ ] Platform.OS kontrolü yapılıyor mu?
- [ ] Her platform için ayrı izin isteme kodu var mı?
- [ ] PERMISSIONS sabitleri doğru kullanılıyor mu?

#### Android Manifest:
- [ ] Tüm Bluetooth izinleri eklendi mi?
- [ ] tools namespace eklendi mi?

#### iOS Info.plist:
- [ ] Tüm açıklamalar eklendi mi?
- [ ] Podfile'da izin path'leri doğru mu?

### Flutter

#### Paketler:
- [ ] `permission_handler` eklendi mi?
- [ ] `flutter_blue_plus` veya `flutter_bluetooth_serial` eklendi mi?
- [ ] `device_info_plus` eklendi mi?
- [ ] `flutter pub get` çalıştırıldı mı?

#### İzin Kontrolü:
- [ ] Platform.isAndroid / Platform.isIOS kontrolü yapılıyor mu?
- [ ] Android SDK versiyonu kontrol ediliyor mu?
- [ ] Her platform için ayrı izin isteme var mı?

#### Android Manifest:
- [ ] Tüm Bluetooth izinleri eklendi mi?
- [ ] minSdkVersion 21 veya üzeri mi?

#### iOS Info.plist:
- [ ] Tüm açıklamalar eklendi mi?
- [ ] Runner klasöründe mi?

---

## 🧪 TEST KONTROL LİSTESİ

### Android Testleri:

#### İzin Testleri:
- [ ] İlk açılışta izin istiyor mu?
- [ ] İzin verildiğinde çalışıyor mu?
- [ ] İzin reddedildiğinde uygun mesaj gösteriliyor mu?
- [ ] Ayarlara yönlendirme çalışıyor mu?

#### Bluetooth Testleri:
- [ ] Bluetooth kapalıyken uyarı veriyor mu?
- [ ] Bluetooth açıldığında tarama başlıyor mu?
- [ ] Cihazlar listeleniyor mu?
- [ ] Cihaza bağlanabiliyor mu?

#### Versiyon Testleri:
- [ ] Android 12+ cihazda test edildi mi?
- [ ] Android 11 ve altı cihazda test edildi mi?
- [ ] Farklı cihaz modellerinde test edildi mi?

### iOS Testleri:

#### İzin Testleri:
- [ ] İlk açılışta izin istiyor mu?
- [ ] İzin dialog'unda doğru açıklama görünüyor mu?
- [ ] İzin verildiğinde çalışıyor mu?
- [ ] İzin reddedildiğinde uygun mesaj gösteriliyor mu?

#### Bluetooth Testleri:
- [ ] Bluetooth kapalıyken uyarı veriyor mu?
- [ ] Bluetooth açıldığında tarama başlıyor mu?
- [ ] Cihazlar listeleniyor mu?
- [ ] Cihaza bağlanabiliyor mu?

#### Arka Plan Testleri:
- [ ] Arka planda Bluetooth çalışıyor mu? (gerekiyorsa)
- [ ] Bildirimler geliyor mu?

---

## 🐛 HATA AYIKLAMA KONTROL LİSTESİ

### Uygulama Çöküyor:

#### Android:
- [ ] Logcat'te "SecurityException" var mı?
- [ ] Logcat'te "Permission denied" var mı?
- [ ] AndroidManifest.xml'de tüm izinler var mı?
- [ ] Runtime izin kontrolü yapılıyor mu?

#### iOS:
- [ ] Xcode Console'da "usage description" hatası var mı?
- [ ] Info.plist'te açıklamalar var mı?
- [ ] Info.plist'te yazım hatası var mı?

### İzin İstenmiyor:

#### Android:
- [ ] requestPermissions çağrılıyor mu?
- [ ] ActivityResultLauncher kullanılıyor mu?
- [ ] Manifest'te izin var mı?

#### iOS:
- [ ] CLLocationManager requestWhenInUseAuthorization çağrılıyor mu?
- [ ] Info.plist'te açıklama var mı?

### Bluetooth Çalışmıyor:

#### Her İki Platform:
- [ ] Bluetooth açık mı?
- [ ] İzinler verildi mi?
- [ ] Konum servisleri açık mı? (Android)
- [ ] Durum kontrolü yapılıyor mu?
- [ ] Hata mesajları loglarda ne diyor?

---

## 📊 SON KONTROL

### Kod Kalitesi:
- [ ] Tüm Bluetooth çağrıları try-catch içinde mi?
- [ ] Null safety kontrolü yapılıyor mu?
- [ ] Memory leak yok mu?
- [ ] Resource'lar (BluetoothAdapter, Manager) düzgün dispose ediliyor mu?

### Kullanıcı Deneyimi:
- [ ] Loading göstergeleri var mı?
- [ ] Hata mesajları anlaşılır mı?
- [ ] Başarılı işlemler bildiriliyor mu?
- [ ] Ayarlara yönlendirme kolay mı?

### Dokümantasyon:
- [ ] İzinler neden gerekli açıklanıyor mu?
- [ ] README dosyası var mı?
- [ ] Kod yorumlanmış mı?

---

## ✅ BAŞARILI KURULUM KONTROL

Aşağıdaki test senaryolarının hepsi BAŞARILI olmalı:

1. ✅ Uygulama ilk kez açılıyor → İzin istiyor
2. ✅ İzinler veriliyor → Bluetooth tarama başlıyor
3. ✅ Cihazlar buluniyor → Listelenebiliyor
4. ✅ Cihaza bağlanılıyor → Bağlantı başarılı
5. ✅ Bluetooth kapatılıyor → Uyarı gösteriliyor
6. ✅ İzin reddediliyor → Ayarlara yönlendirme çalışıyor
7. ✅ Uygulama arka plana gidiyor → Çökme yok
8. ✅ Uygulama yeniden açılıyor → İzinler hatırlanıyor

---

## 🚨 ACİL DURUM - HALA ÇÖKÜYOR MU?

### 1. Temiz Kurulum:
```bash
# Android
cd android
./gradlew clean
cd ..

# iOS
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# React Native / Flutter
# Cache'i temizle
```

### 2. Uygulamayı Tamamen Kaldır:
- Cihazdan uygulamayı sil
- Yeniden derle ve yükle
- İzinleri baştan ver

### 3. Log Kontrol:
- Android: `adb logcat | grep Bluetooth`
- iOS: Xcode Console
- Hata mesajını not et

### 4. Dökümantasyonu Tekrar Kontrol Et:
- `HIZLI_COZUM_TR.md` - Hızlı çözüm
- `BLUETOOTH_PERMISSIONS_ANDROID.md` - Android detay
- `BLUETOOTH_PERMISSIONS_IOS.md` - iOS detay
- `REACT_NATIVE_BLUETOOTH.md` - React Native
- `FLUTTER_BLUETOOTH.md` - Flutter

---

## 📞 YARDİM

Sorun devam ediyorsa:
1. Hata mesajını tam olarak not edin
2. Android/iOS versiyonunu kontrol edin
3. Kullandığınız framework'ü belirtin (Native/RN/Flutter)
4. Manifest/Info.plist dosyalarınızı kontrol edin

**HER ŞEY TAMAM OLDUĞUNDA BU LİSTEDEKİ TÜM MADDELER İŞARETLİ OLMALIDIR!** ✅
