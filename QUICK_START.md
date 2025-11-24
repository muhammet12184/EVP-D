# 🚀 Hızlı Başlangıç Kılavuzu

Bu kılavuz, projeyi 5 dakikada çalışır hale getirmenizi sağlar.

## ⚡ Hızlı Kurulum (3 Adım)

### 1️⃣ Bağımlılıkları Yükle

```bash
flutter pub get
```

### 2️⃣ Uygulamayı Çalıştır

```bash
flutter run
```

### 3️⃣ Tebrikler! 🎉

Uygulama artık çalışıyor. Giriş ekranından "Giriş Yap" butonuna tıklayarak ana ekrana geçebilirsiniz.

---

## 📱 Temel Navigasyon

### Ana Ekran Sekmeleri

1. **Ana Sayfa** 🏠
   - Hızlı işlemler
   - Araç durumu özeti
   - İmece bildirimleri
   - AI asistan durumu

2. **Araç** 🚗
   - Araç detayları
   - Batarya/Yakıt durumu
   - Menzil tahmini
   - OBD-II bağlantısı

3. **Cüzdan** 💰
   - Bakiye görüntüleme
   - Hızlı ödemeler
   - İşlem geçmişi

4. **Ligler** 🏆
   - Sıralama tablosu
   - Başarılar
   - Eco-Coin bakiyesi

5. **Profil** 👤
   - Kullanıcı bilgileri
   - Ayarlar

---

## 🎯 İlk Yapılacaklar

### 1. AI Asistanını Seç

Ana ekranda **AI Asistanın** kartına tıklayın ve karakterinizi seçin:

- 🎩 **Sadık Kâhya** - Profesyonel ve resmi
- 😎 **Eğlenceli Kanka** - Samimi ve eğlenceli
- 💪 **Sert Koç** - Disiplinli ve motive edici

### 2. Araç Ekle

**Araç** sekmesine gidin ve:

- Elektrikli araç için bilgilerinizi girin
- Benzinli araç için OBD-II cihazını bağlayın

### 3. Ödeme Yöntemi Ekle

**Cüzdan** sekmesinden:

- Kart bilgilerinizi ekleyin
- İlk bakiyenizi yükleyin

---

## 🧪 Test Özellikleri

Aşağıdaki özellikler şu an **mock data** ile çalışmaktadır:

### Çalışan Özellikler ✅

- ✅ Tüm UI ekranları
- ✅ Navigasyon sistemi
- ✅ AI Persona seçimi
- ✅ Mock araç verileri
- ✅ Mock wallet işlemleri
- ✅ Mock ligler ve başarılar
- ✅ Mock İmece talepleri

### Entegrasyon Gereken Özellikler 🔧

- 🔧 Firebase Authentication
- 🔧 AWS IoT Core bağlantısı
- 🔧 Mapbox harita entegrasyonu
- 🔧 Stripe/İyzico ödeme entegrasyonu
- 🔧 OBD-II Bluetooth bağlantısı
- 🔧 TTS (Text-to-Speech) ve STT (Speech-to-Text)
- 🔧 Push notification servisi

---

## 🔑 API Anahtarları Yapılandırması

### Gerekli API Anahtarları

1. **Mapbox Access Token**
   - [Mapbox'dan alın](https://account.mapbox.com/)
   - `lib/core/config/app_config.dart` içinde güncelleyin

2. **AWS IoT Endpoint**
   - AWS Console'dan IoT Core endpoint'inizi alın
   - `lib/core/config/app_config.dart` içinde güncelleyin

3. **Firebase Configuration**
   - Firebase Console'dan `google-services.json` (Android) indirin
   - Firebase Console'dan `GoogleService-Info.plist` (iOS) indirin

### Konfigürasyon Dosyası

`lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Mapbox
  static const String mapboxAccessToken = 'YOUR_TOKEN_HERE';
  
  // AWS IoT
  static const String awsIotEndpoint = 'YOUR_ENDPOINT_HERE';
  static const String awsIotRegion = 'eu-central-1';
  
  // Feature Flags
  static const bool enableAIPersonas = true;
  static const bool enableImeceMode = true;
  // ...
}
```

---

## 🎨 UI Temaları

Uygulama otomatik olarak sistem temasını takip eder:

- **Light Mode** ☀️ - Gündüz için optimize edilmiş
- **Dark Mode** 🌙 - Gece sürüşleri için optimize edilmiş

Tema renkleri `lib/core/config/theme_config.dart` dosyasında özelleştirilebilir.

---

## 🐛 Yaygın Sorunlar ve Çözümler

### Problem: "Package not found" hatası

```bash
flutter pub get
flutter clean
flutter pub get
```

### Problem: iOS simülatörde çalışmıyor

```bash
cd ios
pod install
cd ..
flutter run
```

### Problem: Android build hatası

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

### Problem: Bluetooth izinleri çalışmıyor

**Android:**
- `android/app/src/main/AndroidManifest.xml` dosyasını kontrol edin
- Gerekli tüm izinlerin eklendiğinden emin olun

**iOS:**
- `ios/Runner/Info.plist` dosyasını kontrol edin
- Bluetooth kullanım açıklamalarının eklendiğinden emin olun

---

## 📚 Daha Fazla Bilgi

- 📖 [Tam Dokümantasyon](README.md)
- 🏗️ [Mimari Kılavuzu](ARCHITECTURE.md) *(oluşturulacak)*
- 🎨 [UI/UX Kılavuzu](UI_GUIDE.md) *(oluşturulacak)*
- 🔌 [API Dokümantasyonu](API_DOCS.md) *(oluşturulacak)*

---

## 💡 İpuçları

1. **Hot Reload:** Kod değişikliklerini hızlıca görmek için `r` tuşuna basın
2. **Hot Restart:** Tam yeniden başlatma için `R` tuşuna basın
3. **Debug Paint:** Sınırları görmek için `p` tuşuna basın
4. **Performance Overlay:** FPS görmek için `P` tuşuna basın

---

## 🤝 Destek

Sorun mu yaşıyorsunuz?

- 🐛 [Issue açın](https://github.com/yourrepo/issues)
- 💬 [Discord'a katılın](#)
- 📧 Email: support@yourcompany.com

---

**İyi kodlamalar! 🚀**
