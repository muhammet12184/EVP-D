# 🚀 Yeni Nesil Mobilite ve Yaşam Ekosistemi (Super App)

**Vizyon:** Sadece bir araç uygulaması değil; finans, asistan, ev ve sosyal yaşamı birleştiren dijital bir yol arkadaşı.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

---

## 📋 İçindekiler

- [Proje Hakkında](#-proje-hakkında)
- [Temel Özellikler](#-temel-özellikler)
- [Teknoloji Yığını](#%EF%B8%8F-teknoloji-yığını)
- [Mimari](#-mimari)
- [Kurulum](#-kurulum)
- [Kullanım](#-kullanım)
- [Özellikler Detayı](#-özellikler-detayı)
- [Ekran Görüntüleri](#-ekran-görüntüleri)
- [Katkıda Bulunma](#-katkıda-bulunma)
- [Lisans](#-lisans)

---

## 🎯 Proje Hakkında

Bu proje, elektrikli ve benzinli/dizel araçlar için kapsamlı bir super app çözümüdür. Kullanıcılara:

- **Akıllı Araç Yönetimi** (EV ve ICE desteği)
- **AI Tabanlı Kişisel Asistan** (3 farklı karakter seçimi)
- **Topluluk Yardımlaşması** (İmece Modu)
- **Entegre Dijital Cüzdan** (Super Wallet)
- **Oyunlaştırma Sistemi** (Ligler, başarılar, Eco-Coin)

gibi özellikler sunar.

---

## ✨ Temel Özellikler

### 🎭 1. AI Karakter Seçimi (Persona)

Kullanıcı asistanını kişiliğine göre seçer:

- **🎩 Sadık Kâhya** - Kibar, resmi, profesyonel
- **😎 Eğlenceli Kanka** - Samimi, şakacı, arkadaş canlısı
- **💪 Sert Koç** - Disiplinli, motive edici, hedef odaklı

Her karakter farklı ses tonu, konuşma stili ve tepkilerle gelir.

### 🤝 2. İmece Modu (Topluluk Yardımlaşması)

- Yolda kalan kullanıcılar yardım çağrısı yapar
- Yakındaki diğer kullanıcılar yardıma gider
- Yardım eden kullanıcılar **yüksek Eco-Coin ödülü** kazanır
- Gerçek zamanlı harita üzerinde yardım talepleri gösterilir

### ⚡ 3. Elektrikli Araç (EV) Özellikleri

- **Plug & Charge:** Kablo takıldığı an otomatik ödeme
- **Gerçekçi Menzil:** Hava durumu, eğim ve sürüş stiline göre %99 doğrulukla tahmin
- **Batarya Pasaportu:** Blokzincir üzerinde sertifikalanmış batarya sağlığı
- **V2L/V2H:** Aracın elektriğini kampa veya eve aktarma
- **Akıllı Şarj Planlama:** En ucuz elektrik tarifesine göre otomatik zamanlama

### ⛽ 4. Benzinli/Dizel Araç Özellikleri

- **OBD-II Entegrasyonu:** Tak-çalıştır cihaz ile akıllı dönüşüm
- **Akıllı Yakıt Asistanı:** En ucuz ve kaliteli istasyon bulma
- **Mobil Ödeme:** Araçtan inmeden pompa başında ödeme
- **AI Tamirci:** Arıza kodlarını halk diliyle açıklama
  - *"P0300: Korkmayın! Buji değişimi yeterli, ~800 TL"*
- **EV Simülasyonu:** "Elektrikli olsaydın şu kadar tasarruf ederdin" raporu

### 💰 5. Super Wallet (Dijital Cüzdan)

Tek cüzdanda tüm ödemeler:

- 🛡️ Sigorta ödemeleri
- 💳 MTV ödemeleri
- 🛣️ HGS/OGS geçişleri
- ⚡ Şarj istasyonu ödemeleri
- ⛽ Yakıt ödemeleri
- 🍔 Drive-Thru ödemeler
- 🅿️ Park ödemeleri
- 🚗 P2P Araç Kiralama

### 🏆 6. Oyunlaştırma Sistemi

- **Sürüş Ligleri:** Haftalık puanlama ve ödüller
  - Bronz → Gümüş → Altın → Platin → Elmas → Master
- **Eco-Coin:** Ekonomik sürüş ve yardımlaşma ile kazanılan sanal para
- **Başarılar:** Kilometre, eko-sürüş, topluluk yardımı rozetleri
- **Lider Tablosu:** Haftalık ve aylık sıralamalar

---

## ⚙️ Teknoloji Yığını

### Frontend (Mobile)
```
Flutter 3.0+
├── Dart 3.0+
├── Material Design 3
├── Riverpod (State Management)
├── Hive (Local Storage)
└── Google Fonts
```

### Backend (Önerilen)
```
Go (Golang)
├── Gin Web Framework
├── PostgreSQL
├── Redis
└── AWS IoT Core
```

### AI & ML
```
Python
├── TensorFlow Lite
├── PyTorch Mobile
├── Speech Recognition
└── TTS (Text-to-Speech)
```

### Cloud & IoT
```
AWS
├── IoT Core
├── Lambda
├── DynamoDB
├── S3
└── Cognito
```

### Maps & Navigation
```
Mapbox
├── Navigation SDK
├── Custom Styles
└── Geofencing
```

### Blockchain
```
Hyperledger Fabric
└── Battery Passport Certification
```

---

## 🏗️ Mimari

Proje, **Clean Architecture** ve **Feature-First** yaklaşımıyla organize edilmiştir:

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart
│   │   └── theme_config.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── vehicle_model.dart
│   │   ├── ai_persona_model.dart
│   │   ├── imece_request_model.dart
│   │   ├── wallet_model.dart
│   │   └── gamification_model.dart
│   ├── services/
│   │   ├── ai_service.dart
│   │   └── location_service.dart
│   └── router/
│       └── app_router.dart
│
├── features/
│   ├── auth/
│   │   └── screens/
│   │       └── login_screen.dart
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart
│   ├── vehicle/
│   │   ├── screens/
│   │   │   └── vehicle_dashboard_screen.dart
│   │   └── services/
│   │       ├── vehicle_service.dart
│   │       ├── ev_service.dart
│   │       └── obd_service.dart
│   ├── ai_assistant/
│   │   └── screens/
│   │       └── ai_persona_selection_screen.dart
│   ├── wallet/
│   │   ├── screens/
│   │   │   └── wallet_screen.dart
│   │   └── services/
│   │       └── wallet_service.dart
│   ├── gamification/
│   │   ├── screens/
│   │   │   └── leagues_screen.dart
│   │   └── services/
│   │       └── gamification_service.dart
│   └── imece/
│       ├── screens/
│       │   └── imece_map_screen.dart
│       └── services/
│           └── imece_service.dart
│
└── main.dart
```

### Katmanlar

1. **Presentation Layer** (UI/Screens)
2. **Business Logic Layer** (Services)
3. **Data Layer** (Models)
4. **Core Layer** (Config, Utils, Common Services)

---

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK (3.0 veya üzeri)
- Dart SDK (3.0 veya üzeri)
- Android Studio / Xcode (platform bağımlı)
- VS Code veya Android Studio (önerilen)

### Adımlar

1. **Projeyi klonlayın:**

```bash
git clone <repository-url>
cd mobility_super_app
```

2. **Bağımlılıkları yükleyin:**

```bash
flutter pub get
```

3. **API anahtarlarını yapılandırın:**

`lib/core/config/app_config.dart` dosyasını düzenleyin:

```dart
static const String mapboxAccessToken = 'YOUR_MAPBOX_TOKEN';
static const String awsIotEndpoint = 'YOUR_AWS_IOT_ENDPOINT';
```

4. **Uygulamayı çalıştırın:**

```bash
flutter run
```

### Platform Özellikleri

#### Android

`android/app/src/main/AndroidManifest.xml` dosyasına gerekli izinleri ekleyin:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

#### iOS

`ios/Runner/Info.plist` dosyasına gerekli izinleri ekleyin:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Araç konumunuzu takip etmek için konum erişimi gerekiyor</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>İmece özelliği için sürekli konum erişimi gerekiyor</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>OBD-II cihazına bağlanmak için Bluetooth erişimi gerekiyor</string>
```

---

## 📱 Kullanım

### Hızlı Başlangıç

1. **Giriş Yapın** veya yeni hesap oluşturun
2. **Aracınızı Ekleyin:**
   - Elektrikli araç için: Marka, model, batarya kapasitesi
   - Benzinli/Dizel için: OBD-II cihazını bağlayın
3. **AI Asistanınızı Seçin:** Kahya, Kanka veya Koç
4. **Ödeme Yöntemi Ekleyin:** Super Wallet'a kart ekleyin
5. **Sürmeye Başlayın!** 🚗💨

### Ana Özellikler

#### 🎤 Sesli Komutlar

```
"Üşüdüm" → AI asistanı ısıtmayı açar
"Klimayı aç" → Klima devreye girer
"En yakın şarj istasyonu nerede?" → Harita üzerinde gösterir
"Yakıt seviyem ne kadar?" → Gerçek zamanlı bilgi verir
```

#### 🗺️ İmece (Yardımlaşma)

1. Yardım talebi oluştur
2. Yakındaki kullanıcılar bildirim alır
3. Yardım eden kullanıcı Eco-Coin kazanır
4. Karma puanı artar

#### 💳 Ödemeler

- **Şarj:** Plug & Charge ile otomatik
- **Yakıt:** QR kod ile araçtan inmeden
- **Park:** Konum bazlı otomatik ödeme
- **HGS:** Otomatik yükleme

---

## 🎨 Özellikler Detayı

### AI Asistan Diyalogları

#### Sadık Kâhya (Resmi)
```
Kullanıcı: "Üşüdüm"
Kâhya: "Evet efendim, ısıtmayı açıyorum."
```

#### Eğlenceli Kanka (Samimi)
```
Kullanıcı: "Üşüdüm"
Kanka: "Brrrr üşüttün mü kankam? Hemen ısıtmayı açıyorum!"
```

#### Sert Koç (Disiplinli)
```
Kullanıcı: "Üşüdüm"
Koç: "Isıtmayı devreye alıyorum. Konfor önemli ama hedef daha önemli!"
```

### Eco-Coin Kazanma Yolları

| Aktivite | Kazanç |
|----------|--------|
| Ekonomik Sürüş (100km) | 50 EC |
| İmece Yardımı | 100-250 EC |
| Haftalık Lig Ödülü | 50-200 EC |
| Başarı Rozeti | 50-150 EC |
| P2P Araç Kiralama | Değişken |

### OBD-II Desteklenen PID'ler

- `0C` - Motor RPM
- `0D` - Araç Hızı
- `05` - Motor Soğutma Suyu Sıcaklığı
- `2F` - Yakıt Seviyesi
- `04` - Motor Yükü
- `0F` - Hava Alım Sıcaklığı

### Batarya Sağlığı Puanlaması

```
95-100: Mükemmel 🌟
85-94:  Çok İyi ✨
75-84:  İyi ✓
60-74:  Normal ⚠️
<60:    Dikkat ⚠️⚠️
```

---

## 📸 Ekran Görüntüleri

*Not: Ekran görüntüleri eklenecek*

---

## 🔮 Gelecek Özellikler

- [ ] AR (Artırılmış Gerçeklik) navigasyon
- [ ] Blockchain tabanlı servis geçmişi
- [ ] NFT araç koleksiyonu
- [ ] Metaverse garaj
- [ ] Sosyal medya entegrasyonu
- [ ] Apple CarPlay / Android Auto desteği
- [ ] Smart Home entegrasyonu (HomeKit, Google Home)
- [ ] Araç paylaşım platformu (Car Sharing)
- [ ] Sigorta karşılaştırma motoru

---

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen şu adımları izleyin:

1. Bu repoyu fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

### Kod Standartları

- **Dart:** [Effective Dart](https://dart.dev/guides/language/effective-dart) rehberini takip edin
- **Commit Mesajları:** [Conventional Commits](https://www.conventionalcommits.org/) kullanın
- **Test:** Yeni özellikler için testler ekleyin

---

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

---

## 👥 Ekip

- **Project Lead:** [Your Name]
- **Flutter Developer:** [Your Name]
- **Backend Developer:** [Your Name]
- **AI/ML Engineer:** [Your Name]
- **UI/UX Designer:** [Your Name]

---

## 📞 İletişim

- **Website:** [yourwebsite.com]
- **Email:** info@yourcompany.com
- **Twitter:** [@yourhandle]
- **Discord:** [Discord Server Link]

---

## 🙏 Teşekkürler

- Flutter ekibine harika framework için
- Mapbox'a gelişmiş harita çözümleri için
- Açık kaynak topluluğuna katkıları için

---

## 📊 Proje İstatistikleri

![GitHub stars](https://img.shields.io/github/stars/yourusername/repo?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/repo?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/repo)
![GitHub pull requests](https://img.shields.io/github/issues-pr/yourusername/repo)

---

**Yeni nesil mobilite deneyimini şimdi yaşayın! 🚀**

*Made with ❤️ by [Your Company]*
