# Bluetooth Bağlantı Çözümü - Kurulum Rehberi

## Hızlı Başlangıç

### 1. Bağımlılıkları Yükleyin

```bash
npm install
# veya
yarn install
```

### 2. iOS için Pod Kurulumu

```bash
cd ios
pod install
cd ..
```

### 3. Android Yapılandırması

`android/app/src/main/AndroidManifest.xml` dosyası zaten yapılandırılmış durumda. Gerekli Bluetooth izinleri eklenmiştir.

**Önemli:** Android 12+ (API 31+) için yeni Bluetooth izinleri kullanılmaktadır:
- `BLUETOOTH_SCAN`
- `BLUETOOTH_CONNECT`

Android 11 ve öncesi için:
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`

### 4. iOS Yapılandırması

`ios/Info.plist` dosyası zaten yapılandırılmış durumda. Aşağıdaki izin açıklamaları eklenmiştir:
- `NSBluetoothAlwaysUsageDescription`
- `NSBluetoothPeripheralUsageDescription`
- `NSLocationWhenInUseUsageDescription`

## Kullanım

### BluetoothScreen Komponenti

Ana ekranınızda `BluetoothScreen` komponentini kullanabilirsiniz:

```tsx
import BluetoothScreen from './components/BluetoothScreen';

function App() {
  return <BluetoothScreen />;
}
```

### useBluetooth Hook'u

Daha özelleştirilmiş bir kullanım için `useBluetooth` hook'unu kullanabilirsiniz:

```tsx
import { useBluetooth } from './hooks/useBluetooth';

function MyBluetoothComponent() {
  const {
    devices,           // Bulunan cihazlar listesi
    isScanning,        // Tarama durumu
    isConnected,       // Bağlantı durumu
    connectedDevice,   // Bağlı cihaz
    error,             // Hata mesajı
    startScan,         // Taramayı başlat
    stopScan,          // Taramayı durdur
    connectToDevice,   // Cihaza bağlan
    disconnectDevice,  // Bağlantıyı kes
  } = useBluetooth();

  return (
    <View>
      <Button title="Tara" onPress={startScan} />
      {devices.map(device => (
        <TouchableOpacity 
          key={device.id}
          onPress={() => connectToDevice(device.id)}
        >
          <Text>{device.name || device.id}</Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}
```

## Özellikler

✅ **iOS ve Android Desteği**: Her iki platformda da çalışır
✅ **Otomatik İzin Yönetimi**: Gerekli izinler otomatik olarak istenir
✅ **Bluetooth Durumu Kontrolü**: Bluetooth'un açık olup olmadığını kontrol eder
✅ **Cihaz Tarama**: Yakındaki Bluetooth cihazlarını tarar
✅ **Cihaz Bağlantısı**: Seçilen cihaza bağlanır
✅ **Hata Yönetimi**: Hataları kullanıcıya gösterir
✅ **Bağlı Cihaz Takibi**: Bağlı cihazı takip eder

## Sorun Giderme

### Cihazlar Görünmüyor

1. **Bluetooth'un açık olduğundan emin olun**
   - Ayarlar > Bluetooth > Açık

2. **İzinlerin verildiğini kontrol edin**
   - Android: Ayarlar > Uygulamalar > [Uygulama Adı] > İzinler
   - iOS: Ayarlar > [Uygulama Adı] > Bluetooth

3. **Cihazın görünür (discoverable) modda olduğundan emin olun**
   - Cihazın Bluetooth ayarlarından görünür yapın

4. **Uygulamayı yeniden başlatın**
   - Uygulamayı tamamen kapatıp tekrar açın

5. **Cihazı yeniden başlatın**
   - Bluetooth cihazını kapatıp açın

### Bağlantı Hatası

1. **Cihazın başka bir cihaza bağlı olmadığından emin olun**
   - Önceki bağlantıyı kesin

2. **Cihazı yeniden başlatmayı deneyin**
   - Bluetooth cihazını kapatıp açın

3. **Uygulamayı yeniden başlatın**
   - Uygulamayı tamamen kapatıp tekrar açın

4. **Bluetooth'u kapatıp açın**
   - Sistem ayarlarından Bluetooth'u kapatıp tekrar açın

### Android Özel Sorunlar

- **Android 12+**: Yeni Bluetooth izinleri gereklidir (zaten eklenmiş)
- **Konum İzni**: Android 11 ve öncesi için konum izni gereklidir
- **Bluetooth Açık**: Bluetooth'un açık olması gerekir

### iOS Özel Sorunlar

- **Info.plist**: Bluetooth kullanım açıklamaları eklenmiş olmalı (zaten eklenmiş)
- **İzin İsteği**: İlk kullanımda kullanıcıdan izin istenir
- **Bluetooth Açık**: Bluetooth'un açık olması gerekir

## Test Etme

1. Uygulamayı çalıştırın
2. "Tara" butonuna basın
3. Bluetooth cihazlarını görmelisiniz
4. Bir cihaza tıklayarak bağlanmayı deneyin

## Desteklenen Özellikler

- ✅ Bluetooth Low Energy (BLE) cihazları
- ✅ Klasik Bluetooth cihazları (sınırlı)
- ✅ Cihaz tarama
- ✅ Cihaz bağlantısı
- ✅ Bağlantı kesme
- ✅ Cihaz bilgileri (isim, ID, RSSI)

## Notlar

- iOS'ta cihazların görünmesi için cihazın isimli olması gerekebilir
- Android'de bazı cihazlar isimsiz görünebilir, ID ile tanımlanabilir
- Tarama süresi varsayılan olarak 10 saniyedir (kodda değiştirilebilir)
