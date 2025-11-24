# 🚗 Yeni Nesil Mobilite ve Yaşam Ekosistemi (Super App)

**Vizyon:** Sadece bir araç uygulaması değil; finans, asistan, ev ve sosyal yaşamı birleştiren dijital bir yol arkadaşı.

[![Flutter](https://img.shields.io/badge/Flutter-3.38.3-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey)]()

---

## 📋 İçindekiler

- [Özellikler](#-özellikler)
- [Teknoloji Yığını](#-teknoloji-yığını)
- [Kurulum](#-kurulum)
- [Proje Yapısı](#-proje-yapısı)
- [Kullanım](#-kullanım)
- [Modüller](#-modüller)
- [Geliştirici Notları](#-geliştirici-notları)

---

## 🌟 Özellikler

### 🎭 AI Asistan - Seçilebilir Karakterler
- **Sadık Kâhya**: Kibar, resmi ve klasik asistan
- **Eğlenceli Kanka**: Samimi, şakacı ve dostane
- **Sert Koç**: Disiplinli, motive edici ve direkt

### ⚡ Elektrikli Araçlar (EV)
- ✅ Plug & Charge - Kartısız otomatik ödeme
- ✅ Gerçekçi menzil hesaplama (hava durumu, eğim, sürüş stili)
- ✅ Batarya sağlığı analizi ve blockchain pasaportu
- ✅ V2L/V2H - Araca ve eve elektrik aktarımı
- ✅ En yakın şarj istasyonu bulma

### 🚙 Benzinli/Dizel Araçlar (ICE)
- ✅ OBD-II cihazı ile akıllı entegrasyon
- ✅ Akıllı yakıt asistanı (en ucuz istasyon)
- ✅ Mobil ödeme (araçtan inmeden)
- ✅ Yapay zeka tamirci (arıza kodu yorumlama)
- ✅ EV simülasyonu ve tasarruf hesaplama

### 💰 Super Wallet - Tek Cüzdan
- ✅ Sigorta, MTV, HGS ödemeleri
- ✅ Şarj ve yakıt ödemeleri
- ✅ Drive-Thru ödeme
- ✅ P2P araç kiralama
- ✅ Gelir-gider analizi

### 🎮 Oyunlaştırma (Gamification)
- ✅ Sürüş ligleri ve haftalık ödüller
- ✅ Eco-Coin kazanma sistemi
- ✅ Rozet ve başarım sistemi
- ✅ Şehir kaşifi (sesli rehber)

### 🤝 İmece Modu - Topluluk Yardımlaşması
- ✅ Yolda kalan kullanıcılara yardım
- ✅ Yakındaki üyelere bildirim
- ✅ Yüksek Eco-Coin ödülleri
- ✅ Yardımlaşma puanlama sistemi

### 🏠 Akıllı Ev Entegrasyonu
- ✅ Araç konumuna göre garaj kontrolü
- ✅ Otomatik ışık ve ısıtma ayarı
- ✅ V2H ile eve elektrik aktarımı

---

## 🛠 Teknoloji Yığını

### Frontend (Mobil)
```yaml
Framework: Flutter 3.38.3
Language: Dart ^3.10.1
State Management: flutter_bloc ^8.1.3
Navigation: go_router ^14.0.2
```

### Backend (Planlanan)
```
Server: Go (Golang)
AI Engine: Python (TensorFlow, PyTorch)
Database: PostgreSQL + Redis
Cloud: AWS (IoT Core, Lambda, S3)
```

### Harita & IoT
```
Maps: Mapbox GL ^1.2.0
Location: geolocator ^11.0.0
Bluetooth: flutter_blue_plus ^1.31.0
```

### Ödeme & Finans
```
Payment: Stripe SDK ^9.5.0
Storage: Hive ^2.2.3
Auth: Firebase Auth ^4.16.0
```

---

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK 3.38.3 veya üzeri
- Dart SDK 3.10.1 veya üzeri
- Android Studio / Xcode
- Git

### Adımlar

1. **Repoyu Klonlayın**
```bash
git clone <repo-url>
cd mobility_ecosystem
```

2. **Bağımlılıkları Yükleyin**
```bash
flutter pub get
```

3. **Hive TypeAdapter'larını Oluşturun**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Firebase Yapılandırması**
```bash
# Firebase projenizi oluşturun
# google-services.json (Android) ve GoogleService-Info.plist (iOS) dosyalarını ekleyin
```

5. **Mapbox Access Token**
```bash
# .env dosyası oluşturun
echo "MAPBOX_ACCESS_TOKEN=your_token_here" > .env
```

6. **Uygulamayı Çalıştırın**
```bash
flutter run
```

---

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── theme/              # Tema ve stil dosyaları
│   ├── routes/             # Navigasyon rotaları
│   └── constants/          # Sabit değerler
├── features/
│   ├── ai/                 # AI asistan modülü
│   │   ├── ai_service.dart
│   │   └── ai_persona_selector.dart
│   ├── ev/                 # Elektrikli araç modülü
│   │   ├── ev_service.dart
│   │   ├── charging_screen.dart
│   │   └── battery_health_screen.dart
│   ├── ice/                # Benzinli/Dizel araç modülü
│   │   ├── ice_service.dart
│   │   ├── obd_connection_screen.dart
│   │   └── fuel_station_finder.dart
│   ├── finance/            # Finans ve cüzdan modülü
│   │   ├── wallet_service.dart
│   │   ├── wallet_screen.dart
│   │   └── p2p_rental_screen.dart
│   ├── gamification/       # Oyunlaştırma modülü
│   │   ├── gamification_service.dart
│   │   ├── leaderboard_screen.dart
│   │   └── badges_screen.dart
│   └── social/             # Sosyal ve İmece modülü
│       ├── imece_service.dart
│       ├── help_request_screen.dart
│       └── help_map_screen.dart
├── shared/
│   ├── models/             # Veri modelleri
│   │   ├── vehicle.dart
│   │   ├── ev_vehicle.dart
│   │   ├── ice_vehicle.dart
│   │   ├── ai_persona.dart
│   │   └── user.dart
│   ├── widgets/            # Paylaşılan widget'lar
│   ├── utils/              # Yardımcı fonksiyonlar
│   └── constants/          # Paylaşılan sabitler
└── main.dart               # Ana giriş noktası
```

---

## 💡 Kullanım

### AI Karakteri Seçme
```dart
import 'package:mobility_ecosystem/features/ai/ai_service.dart';

final aiService = AIService();
aiService.selectPersona(PersonaType.friendly);

// Yanıt al
String response = aiService.getResponse('low_battery', context: {
  'batteryLevel': 15,
});
print(response); // "Kankam, şarj bitmek üzere 😅 %15 kaldı..."
```

### Şarj İstasyonu Bulma
```dart
import 'package:mobility_ecosystem/features/ev/ev_service.dart';

final evService = EVService();
List<Map<String, dynamic>> stations = await evService.findNearestChargingStations(
  latitude: 41.0082,
  longitude: 28.9784,
  radiusKm: 10,
);
```

### OBD-II Bağlantısı
```dart
import 'package:mobility_ecosystem/features/ice/ice_service.dart';

final iceService = ICEService();
bool connected = await iceService.connectOBD(deviceId: 'OBD_12345');

if (connected) {
  OBDData data = await iceService.readOBDData();
  print('Motor devri: ${data.rpm}');
}
```

### İmece Yardım Çağrısı
```dart
import 'package:mobility_ecosystem/features/social/imece_service.dart';

final imeceService = ImeceService();
String requestId = await imeceService.createHelpRequest(
  userId: 'user123',
  latitude: 41.0082,
  longitude: 28.9784,
  problemType: 'flat_tire',
  description: 'Sol ön lastik patladı',
);
```

---

## 🧩 Modüller

### 1. AI Asistan Modülü
- Duygu analizi
- Bağlamsal komut yorumlama
- Proaktif öneriler
- Karakter bazlı yanıtlar

### 2. EV Modülü
- Plug & Charge entegrasyonu
- Gerçekçi menzil hesaplama
- Batarya sağlığı izleme
- Şarj istasyonu yönlendirme

### 3. ICE Modülü
- OBD-II bluetooth bağlantısı
- Arıza kodu okuma ve yorumlama
- Yakıt istasyonu bulma
- EV tasarruf simülasyonu

### 4. Finans Modülü
- Tek cüzdan sistemi
- Otomatik ödemeler
- P2P araç kiralama
- Harcama analizi

### 5. Oyunlaştırma Modülü
- Sürüş skoru hesaplama
- Eco-Coin sistemi
- Haftalık ligier
- Rozet sistemi

### 6. Sosyal Modülü
- İmece (yardımlaşma) sistemi
- Gerçek zamanlı bildirimler
- Yardım geçmişi
- İtibar puanlama

---

## 👨‍💻 Geliştirici Notları

### Hive TypeAdapter Oluşturma
Model sınıflarında değişiklik yaptığınızda:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Yeni Feature Ekleme
1. `lib/features/` altında yeni klasör oluşturun
2. Servis ve UI dosyalarını ekleyin
3. `lib/core/routes/` altında rotayı tanımlayın
4. Ana navigasyona ekleyin

### Test Çalıştırma
```bash
flutter test
```

### Build Alma
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Kod Standartları
- Bloc pattern kullanın (State Management)
- Dependency Injection için GetIt kullanın
- Dart conventions'ı takip edin
- Her feature için unit testler yazın

---

## 🔮 Gelecek Özellikler

- [ ] Sesli komut (Hey Mercedes tarzı)
- [ ] AR navigasyon
- [ ] Blockchain tabanlı batarya pasaportu
- [ ] Sosyal sürüş yarışmaları
- [ ] Karbondioksit ofset sistemi
- [ ] Akıllı sigorta (kullanım bazlı fiyatlandırma)
- [ ] Fleet management (filo yönetimi)
- [ ] B2B entegrasyonları

---

## 📄 Lisans

Bu proje özel mülkiyettir. Tüm hakları saklıdır.

---

## 📞 İletişim

Sorularınız için: [info@mobilityecosystem.com](mailto:info@mobilityecosystem.com)

---

**Not:** Bu proje aktif geliştirme aşamasındadır. Bazı özellikler henüz tam olarak implemente edilmemiş olabilir.
