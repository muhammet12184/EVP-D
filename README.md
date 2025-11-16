# BMW i8 Dashboard - Flutter Gösterge Paneli

BMW i8 tarzında profesyonel bir gösterge paneli uygulaması. Motor ve elektrik bölümlerini içerir.

## Özellikler

### Motor Bölümü
- **Devir (RPM)**: Motor devir sayısı göstergesi (0-8000 RPM)
- **Hız**: Araç hızı göstergesi (0-250 km/h)
- **Hararet**: Motor sıcaklığı (°C)
- **Boost**: Turbo boost basıncı (bar)
- **Gaz Kelebeği**: Gaz pedalı pozisyonu (%)
- **Motor Yükü**: Motor yük yüzdesi (%)
- **Yakıt**: Yakıt seviyesi (%)
- **Hava**: Hava alımı (%)
- **Şanzıman Sıcaklığı**: Şanzıman sıcaklık göstergesi (°C)

### Elektrik Bölümü (BMW i8)
- **Batarya SOC**: Batarya şarj durumu (%)
- **Hız**: Elektrik motoru hızı (km/h)
- **Batarya Sıcaklığı**: Batarya paketi sıcaklığı (°C)
- **Motor Sıcaklığı**: Elektrik motoru sıcaklığı (°C)
- **Batarya Sağlığı**: Batarya sağlık durumu (%)
- **Güç**: Anlık güç çıkışı (kW)
- **Rejenerasyon**: Rejeneratif fren gücü (kW)

## Kurulum

### Gereksinimler
- Flutter SDK (3.0.0 veya üzeri)
- Dart SDK

### Adımlar

1. Flutter SDK'nın yüklü olduğundan emin olun:
```bash
flutter --version
```

2. Projeyi klonlayın veya indirin

3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## Kullanılan Paketler

- **syncfusion_flutter_gauges**: Dairesel gauge göstergeleri için
- **google_fonts**: Modern tipografi için (Rajdhani font)
- **flutter**: Flutter framework

## Tasarım Özellikleri

- Koyu tema (Dark Mode)
- BMW mavi renk teması (#0066B1)
- Yatay (landscape) ekran yönelimi
- Gradyan arka planlar
- Animasyonlu göstergeler
- Gerçek zamanlı veri simülasyonu
- Renk kodlu uyarılar (yeşil, sarı, turuncu, kırmızı)

## Ekran Görünümü

Gösterge paneli iki ana bölüme ayrılmıştır:
- **Sol taraf**: Motor bölümü (turuncu tema)
- **Sağ taraf**: Elektrik bölümü (mavi tema)

Her bölüm kendi göstergelerini ve metriklerini içerir. Dairesel göstergeler ana metrikleri (devir, hız, SOC) gösterirken, kart ve çubuk göstergeleri diğer detayları sunar.

## Geliştirme

Uygulamayı geliştirmek için:

1. `lib/dashboard_screen.dart` - Ana gösterge paneli ekranı
2. `lib/widgets/circular_gauge.dart` - Dairesel gösterge widget'ı
3. `lib/widgets/metric_card.dart` - Metrik kart widget'ı
4. `lib/widgets/linear_gauge.dart` - Çizgisel gösterge widget'ı

## Lisans

MIT License

## Notlar

- Uygulama şu anda simülasyon modunda çalışmaktadır
- Gerçek OBD-II veya CAN bus verisi için ilgili paketleri entegre edebilirsiniz
- Göstergeler gerçek zamanlı veri simülasyonu ile güncellenmektedir
