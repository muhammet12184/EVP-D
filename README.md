# OBD-II Pro

Profesyonel EV + ICE destekli OBD-II mobil uygulaması

## Kurulum

### Gereksinimler
- Flutter SDK 3.0.0 veya üzeri
- Android Studio / Xcode
- Bluetooth destekli cihaz

### Adımlar

1. Bağımlılıkları yükle:
```bash
flutter pub get
```

2. Android için çalıştır:
```bash
flutter run
```

3. iOS için çalıştır:
```bash
cd ios
pod install
cd ..
flutter run
```

## İzinler

### Android İzinleri
- Bluetooth
- Bluetooth Admin
- Bluetooth Scan
- Bluetooth Connect
- Konum (Fine & Coarse)
- İnternet
- Wake Lock
- Foreground Service

### iOS İzinleri
- Bluetooth Always Usage
- Bluetooth Peripheral Usage
- Konum (When In Use & Always)
- Arka plan modları (bluetooth-central, bluetooth-peripheral, location)

## Özellikler

- BLE üzerinden OBD-II cihazına bağlanma
- Otomatik yeniden bağlanma
- ELM327 desteği
- EV ve ICE araç desteği
- Gerçek zamanlı veri gösterimi
- DTC okuma ve temizleme
- Profesyonel dashboard

## Kullanım

1. Bluetooth'u aç
2. Uygulamayı başlat
3. Sağ üst köşedeki Bluetooth ikonuna tıkla
4. OBD-II cihazını seç ve bağlan
5. Veriler otomatik olarak görüntülenecek
