# Bluetooth Cihaz Tarayıcı

iOS ve Android için Bluetooth Low Energy (BLE) cihaz tarama ve bağlantı uygulaması.

## Özellikler

- ✅ Bluetooth cihazlarını tarama
- ✅ Cihaz ismi, ID ve sinyal gücü gösterimi
- ✅ Cihazlara bağlanma
- ✅ iOS ve Android desteği
- ✅ Modern ve kullanıcı dostu arayüz
- ✅ Türkçe dil desteği

## Kurulum

### Gereksinimler

- Node.js (v16 veya üzeri)
- React Native CLI
- Android Studio (Android için)
- Xcode (iOS için)

### Adımlar

1. **Bağımlılıkları yükleyin:**
```bash
npm install
# veya
yarn install
```

2. **iOS için CocoaPods yükleyin:**
```bash
cd ios
pod install
cd ..
```

3. **Android için:**
```bash
npm run android
# veya
yarn android
```

4. **iOS için:**
```bash
npm run ios
# veya
yarn ios
```

## İzinler

### Android

Uygulama aşağıdaki izinleri otomatik olarak ister:

- **Android 12+ (API 31+):**
  - BLUETOOTH_SCAN
  - BLUETOOTH_CONNECT
  - ACCESS_FINE_LOCATION

- **Android 11 ve altı:**
  - BLUETOOTH
  - BLUETOOTH_ADMIN
  - ACCESS_FINE_LOCATION

### iOS

Aşağıdaki izinler Info.plist'e eklenmiştir:

- NSLocationWhenInUseUsageDescription
- NSBluetoothAlwaysUsageDescription
- NSBluetoothPeripheralUsageDescription

## Kullanım

1. Uygulamayı açın
2. Cihazınızın Bluetooth'unun açık olduğundan emin olun
3. **"🔵 TARA"** butonuna basın
4. Bulunan cihazlar listede görünecektir
5. Bir cihaza bağlanmak için üzerine tıklayın veya **"BAĞLAN"** butonuna basın

## Önemli Notlar

### Android

- Android 12+ cihazlarda `BLUETOOTH_SCAN` izni gereklidir
- Konum servisleri açık olmalıdır
- Uygulamayı ilk çalıştırdığınızda izinleri kabul etmelisiniz

### iOS

- iOS 13+ desteklenir
- Bluetooth izinleri ilk taramada otomatik olarak sorulur
- Simülatörde Bluetooth çalışmaz, gerçek cihaz kullanın

## Sorun Giderme

### Cihazlar Görünmüyor

1. **Bluetooth açık mı?** Cihazınızın Bluetooth ayarlarını kontrol edin
2. **İzinler verildi mi?** Uygulama ayarlarından tüm izinleri kontrol edin
3. **Konum açık mı? (Android)** Android'de BLE tarama için konum servisleri gereklidir
4. **Cihaz BLE destekliyor mu?** Sadece Bluetooth Low Energy cihazları taranır

### Bağlantı Hatası

1. Cihazın başka bir uygulamaya/cihaza bağlı olmadığından emin olun
2. Cihazı yeniden başlatın
3. Uygulamayı kapatıp tekrar açın

## Teknik Detaylar

- **Framework:** React Native 0.72.6
- **Bluetooth Library:** react-native-ble-plx 3.1.2
- **Platform Support:** iOS 13+, Android 5.0+ (API 21+)

## Lisans

MIT License

## Destek

Sorularınız için lütfen bir issue açın.
