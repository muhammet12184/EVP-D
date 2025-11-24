# 🚗 Super Mobility - Yeni Nesil Mobilite ve Yaşam Ekosistemi

**Vizyon:** Sadece bir araç uygulaması değil; finans, asistan, ev ve sosyal yaşamı birleştiren dijital bir yol arkadaşı.

## 🌟 Öne Çıkan Özellikler

### 🎭 Seçilebilir AI Karakteri (Persona)
- **Sadık Kâhya**: Kibar ve resmi asistan
- **Eğlenceli Kanka**: Samimi ve şakacı arkadaş
- **Sert Koç**: Disiplinli motivasyonel koç

### 🤝 İmece Modu (Topluluk Yardımlaşması)
Yolda kalan kullanıcılar yardım çağrısı yapar, yakındaki üyeler yardıma giderse ödül kazanır.

### ⚡ Elektrikli Araç (EV) Özellikleri
- **Plug & Charge**: Kablo takıldığı an otomatik ödeme
- **Gerçekçi Menzil**: %99 doğrulukla menzil tahmini
- **Batarya Pasaportu**: Blokzincir üzerinde sertifikalanmış batarya sağlığı
- **V2L/V2H**: Aracın elektriğini kampa veya eve aktarma

### 🔧 Benzinli/Dizel Araç Özellikleri
- **OBD-II Entegrasyonu**: Tak-çalıştır cihaz ile akıllı dönüşüm
- **Akıllı Yakıt Asistanı**: En ucuz ve kaliteli yakıt istasyonu bulma
- **Mobil Ödeme**: Araçtan inmeden pompa başında ödeme
- **Yapay Zeka Tamirci**: Motor arıza ışığını halk diliyle yorumlama

### 💰 Finans ve Yaşam (Super Wallet)
- Tek cüzdan: Sigorta, MTV, HGS, Şarj, Yakıt ve Drive-Thru ödemeleri
- P2P Araç Kiralama: Aracı kullanmadığın saatlerde kiraya verip gelir elde etme
- Akıllı Ev Entegrasyonu: Araç konumuna göre evdeki garaj, ışık ve ısıtma kontrolü

### 🎮 Oyunlaştırma
- Sürüş Ligleri: Ekonomik sürenlere haftalık ödüller
- Eco-Coin: Sürüş verimliliğine göre coin kazanma
- Şehir Kaşifi: Rota üzerindeki yerlerin sesli rehber ile anlatımı

## 🏗️ Teknik Altyapı

### Mobil Uygulama (Frontend)
- **Framework**: Flutter
- **Platform**: iOS & Android
- **Özellikler**: 60+ FPS animasyonlar, 3D görselleştirme

### Backend (Sunucu)
- **Dil**: Go (Golang)
- **Framework**: Gin
- **Veritabanı**: MongoDB
- **Cache**: Redis
- **Özellikler**: Milyonlarca anlık veri işleme, ultra yüksek hız

### Yapay Zeka Servisleri
- **Dil**: Python
- **Framework**: FastAPI
- **Kütüphaneler**: TensorFlow, PyTorch
- **Özellikler**: Duygu analizi, bağlamsal zeka, karakter modelleri

### Bulut ve IoT
- **Platform**: AWS (Amazon Web Services)
- **IoT**: AWS IoT Core
- **Özellikler**: Araç ve telefon arası milisaniyelik güvenli iletişim

### Harita
- **Platform**: Mapbox
- **Özellikler**: Tamamen özelleştirilebilir, koyu mod uyumlu harita katmanları

## 🚀 Kurulum

### Gereksinimler
- Docker & Docker Compose
- Go 1.21+
- Python 3.11+
- Flutter SDK 3.0+

### Backend Kurulumu

```bash
cd backend
go mod download
go run cmd/api/main.go
```

### AI Servisleri Kurulumu

```bash
cd ai-services
pip install -r requirements.txt
uvicorn src.main:app --host 0.0.0.0 --port 8000
```

### Docker ile Tüm Servisleri Başlatma

```bash
cd infrastructure
docker-compose up -d
```

### Flutter Uygulaması Kurulumu

```bash
cd mobile-app
flutter pub get
flutter run
```

## 📁 Proje Yapısı

```
.
├── mobile-app/          # Flutter mobil uygulama
│   ├── lib/
│   │   ├── core/       # Temel servisler ve utilities
│   │   ├── features/   # Özellik modülleri
│   │   └── shared/     # Paylaşılan widget'lar ve modeller
│   └── assets/         # Görseller, animasyonlar
│
├── backend/            # Go backend servisleri
│   ├── cmd/           # Uygulama entry point'leri
│   ├── internal/     # İç servisler ve API
│   └── pkg/          # Paylaşılan paketler
│
├── ai-services/       # Python AI servisleri
│   ├── src/          # AI modelleri ve servisler
│   └── models/       # Eğitilmiş ML modelleri
│
└── infrastructure/    # Docker, AWS konfigürasyonları
```

## 🔐 Ortam Değişkenleri

`.env.example` dosyasını kopyalayıp `.env` olarak kaydedin ve değerleri doldurun:

```bash
cp .env.example .env
```

## 📝 API Dokümantasyonu

Backend API çalıştıktan sonra:
- Swagger UI: `http://localhost:8080/swagger/index.html`
- Health Check: `http://localhost:8080/health`

AI Servisleri çalıştıktan sonra:
- API Docs: `http://localhost:8000/docs`
- Health Check: `http://localhost:8000/health`

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje özel bir lisans altındadır.

## 👥 Ekip

- **Backend**: Go geliştiricileri
- **Frontend**: Flutter geliştiricileri
- **AI/ML**: Python geliştiricileri
- **DevOps**: AWS ve Docker uzmanları

## 🗺️ Yol Haritası

- [x] Temel proje yapısı
- [x] Flutter mobil uygulama iskeleti
- [x] Go backend API
- [x] Python AI servisleri
- [ ] AWS IoT Core entegrasyonu
- [ ] Mapbox harita entegrasyonu
- [ ] OBD-II cihaz entegrasyonu
- [ ] Blockchain batarya pasaportu
- [ ] Stripe ödeme entegrasyonu
- [ ] Tam test coverage

---

**Not**: Bu proje aktif geliştirme aşamasındadır. Production kullanımı için ek güvenlik ve test gereklidir.
