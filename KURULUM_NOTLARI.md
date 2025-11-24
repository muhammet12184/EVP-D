# 🚀 KURULUM NOTLARI

## ⚠️ ÖNEMLİ: İlk Kurulum Adımları

Bu proje başarıyla oluşturuldu ancak tam çalışır hale gelmesi için aşağıdaki adımları tamamlamanız gerekir.

---

## 1. Flutter SDK Kurulumu

Flutter SDK workspace'den temizlendi (alan tasarrufu için). Yeniden kurmalısınız:

### macOS / Linux:
```bash
# Flutter SDK'yı indirin
git clone https://github.com/flutter/flutter.git -b stable

# PATH'e ekleyin
export PATH="$PATH:`pwd`/flutter/bin"

# Sistem kontrolü
flutter doctor
```

### Windows:
1. https://docs.flutter.dev/get-started/install/windows adresinden Flutter SDK'yı indirin
2. PATH'e ekleyin
3. `flutter doctor` çalıştırın

---

## 2. Proje Bağımlılıklarını Yükleyin

```bash
cd /workspace
flutter pub get
```

---

## 3. Hive TypeAdapter'larını Oluşturun

Model sınıfları Hive kullanıyor. TypeAdapter'ları generate etmelisiniz:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Bu komut şu dosyaları oluşturacak:
- `vehicle.g.dart`
- `ev_vehicle.g.dart`
- `ice_vehicle.g.dart`
- `ai_persona.g.dart`
- `user.g.dart`

---

## 4. Firebase Yapılandırması

Firebase servisleri kullanılıyor. Yapılandırma dosyalarını ekleyin:

### a) Firebase Projesi Oluşturun
1. https://console.firebase.google.com adresine gidin
2. Yeni proje oluşturun
3. iOS ve Android uygulamaları ekleyin

### b) Yapılandırma Dosyalarını İndirin

**Android:**
- `google-services.json` dosyasını indirin
- `android/app/` klasörüne kopyalayın

**iOS:**
- `GoogleService-Info.plist` dosyasını indirin
- `ios/Runner/` klasörüne kopyalayın

### c) Firebase Özelliklerini Aktive Edin
Firebase Console'da şunları aktive edin:
- Authentication (Email/Password)
- Cloud Firestore
- Cloud Messaging (Push Notifications)
- Storage (Profil resimleri için)

---

## 5. Mapbox Token Ayarları

Harita özellikleri için Mapbox kullanılıyor.

### a) Mapbox Hesabı Oluşturun
1. https://account.mapbox.com/auth/signup/ adresine gidin
2. Access token alın

### b) Token'ı Projeye Ekleyin

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<manifest>
    <application>
        <meta-data
            android:name="MAPBOX_ACCESS_TOKEN"
            android:value="YOUR_MAPBOX_TOKEN_HERE" />
    </application>
</manifest>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<dict>
    <key>MBXAccessToken</key>
    <string>YOUR_MAPBOX_TOKEN_HERE</string>
</dict>
```

**Dart** (`.env` dosyası):
```bash
echo "MAPBOX_ACCESS_TOKEN=your_token_here" > .env
```

---

## 6. Stripe (Ödeme) Yapılandırması

Ödeme özellikleri için Stripe kullanılıyor.

### a) Stripe Hesabı
1. https://stripe.com adresinden hesap oluşturun
2. Test API anahtarlarını alın

### b) Anahtarları Ekleyin
```dart
// lib/core/constants/stripe_config.dart
class StripeConfig {
  static const publishableKey = 'pk_test_YOUR_KEY';
  static const secretKey = 'sk_test_YOUR_KEY'; // BACKEND'DE SAKLANMALI!
}
```

**⚠️ UYARI:** Secret key'i asla mobil uygulamada saklamayın! Backend'de tutulmalı.

---

## 7. İzinleri Ayarlayın

### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
```

### iOS (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Şarj istasyonları ve yakıt istasyonları bulmak için konum iznine ihtiyacımız var</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>OBD-II cihazı ile bağlantı için Bluetooth iznine ihtiyacımız var</string>
<key>NSCameraUsageDescription</key>
<string>Profil fotoğrafı için kamera iznine ihtiyacımız var</string>
```

---

## 8. Test Çalıştırma

### a) Bağımlılıkları Kontrol Edin
```bash
flutter doctor -v
```

### b) Analiz Çalıştırın
```bash
flutter analyze
```

### c) Uygulamayı Başlatın
```bash
# Android
flutter run

# iOS (macOS gerekli)
flutter run -d ios

# Web
flutter run -d chrome
```

---

## 9. Bilinen Sorunlar ve Çözümler

### Sorun 1: "MissingPluginException"
**Çözüm:**
```bash
flutter clean
flutter pub get
flutter run
```

### Sorun 2: "Firebase not initialized"
**Çözüm:** `google-services.json` ve `GoogleService-Info.plist` dosyalarının doğru yerde olduğundan emin olun.

### Sorun 3: "Mapbox map not loading"
**Çözüm:** Mapbox token'ın doğru ayarlandığından ve internet bağlantısının olduğundan emin olun.

### Sorun 4: OBD-II bağlanamıyor
**Çözüm:** 
- Bluetooth izinlerinin verildiğinden emin olun
- OBD-II cihazının açık ve eşleşmiş olduğundan emin olun
- Android 12+ için BLUETOOTH_SCAN ve BLUETOOTH_CONNECT izinleri gerekli

---

## 10. Geliştirme Ortamı Önerileri

### VS Code Extensions:
- Flutter
- Dart
- Flutter Widget Snippets
- Bloc (State Management)
- Firebase Explorer

### Android Studio Plugins:
- Flutter Plugin
- Dart Plugin

### Faydalı Komutlar:
```bash
# Hot reload (kod değişikliklerini anında görmek için)
r (uygulamayı çalıştırırken)

# Hot restart
R (uygulamayı çalıştırırken)

# Widget inspector
i (uygulamayı çalıştırırken)

# Performance overlay
p (uygulamayı çalıştırırken)
```

---

## 11. Backend Geliştirme (Opsiyonel)

Proje mock data ile çalışıyor. Gerçek backend için:

### a) Go Backend Oluşturun
```bash
mkdir backend
cd backend
go mod init mobility-ecosystem
```

### b) Gerekli Modüller
- Gin (Web Framework)
- GORM (ORM)
- JWT (Authentication)
- WebSocket (Real-time)

### c) AWS Entegrasyonu
- AWS IoT Core (Araç-Bulut iletişimi)
- AWS Lambda (Serverless functions)
- Amazon RDS (PostgreSQL)
- Amazon ElastiCache (Redis)
- Amazon S3 (Dosya depolama)

---

## 12. Test Verileri

Uygulamayı test etmek için örnek veriler:

### Test Kullanıcısı:
```dart
User(
  id: 'test_user_1',
  email: 'test@mobilityeco.com',
  name: 'Test Kullanıcı',
  selectedPersona: PersonaType.friendly,
  ecoCoins: 1000,
  isPremium: true,
)
```

### Test EV Aracı:
```dart
EVVehicle(
  baseVehicle: Vehicle(...),
  batteryCapacity: 75.0,
  currentBatteryLevel: 65.0,
  estimatedRange: 350.0,
  maxChargingPower: 150.0,
  batteryHealthPercentage: 95,
)
```

---

## 📞 Destek

Sorun yaşıyorsanız:
1. `PROJE_OZETI.md` dosyasını okuyun
2. `README.md` dosyasındaki örneklere bakın
3. GitHub Issues açın
4. info@mobilityecosystem.com adresine yazın

---

**Son Güncelleme:** 2025-11-24  
**Versiyon:** 1.0.0-beta

Başarılar! 🚀
