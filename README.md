# EV Unified Professional - Bluetooth Bağlantı Çözümü

Bu proje iOS ve Android için tam uyumlu Bluetooth tarama ve bağlantı özelliklerini içerir.

## Kurulum

### 1. Bağımlılıkları Yükleyin

```bash
npm install
# veya
yarn install
```

### 2. iOS Kurulumu

```bash
cd ios
pod install
cd ..
```

### 3. Android Yapılandırması

`android/app/src/main/AndroidManifest.xml` dosyası zaten yapılandırılmış durumda. Gerekli izinler eklenmiştir.

### 4. iOS Yapılandırması

`ios/Info.plist` dosyası zaten yapılandırılmış durumda. Gerekli izin açıklamaları eklenmiştir.

## Kullanım

### BluetoothScreen Komponenti

```tsx
import BluetoothScreen from './components/BluetoothScreen';

// Uygulamanızda kullanın
<BluetoothScreen />
```

### useBluetooth Hook'u

```tsx
import { useBluetooth } from './hooks/useBluetooth';

function MyComponent() {
  const {
    devices,
    isScanning,
    isConnected,
    connectedDevice,
    error,
    startScan,
    stopScan,
    connectToDevice,
    disconnectDevice,
  } = useBluetooth();

  // Kullanım örneği
  return (
    <View>
      <Button title="Tara" onPress={startScan} />
      {devices.map(device => (
        <TouchableOpacity onPress={() => connectToDevice(device.id)}>
          <Text>{device.name}</Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}
```

## Özellikler

- ✅ iOS ve Android desteği
- ✅ Otomatik izin yönetimi
- ✅ Bluetooth durumu kontrolü
- ✅ Cihaz tarama
- ✅ Cihaz bağlantısı
- ✅ Hata yönetimi
- ✅ Bağlı cihaz takibi

## Önemli Notlar

### Android
- Android 12+ (API 31+) için yeni Bluetooth izinleri kullanılır
- Android 11 ve öncesi için konum izni gereklidir
- Bluetooth açık olmalıdır

### iOS
- Info.plist'te Bluetooth kullanım açıklamaları bulunmalıdır
- Kullanıcıdan Bluetooth izni istenir
- Bluetooth açık olmalıdır

## Sorun Giderme

### Cihazlar Görünmüyor
1. Bluetooth'un açık olduğundan emin olun
2. İzinlerin verildiğini kontrol edin
3. Cihazın görünür (discoverable) modda olduğundan emin olun
4. Uygulamayı yeniden başlatın

### Bağlantı Hatası
1. Cihazın başka bir cihaza bağlı olmadığından emin olun
2. Cihazı yeniden başlatmayı deneyin
3. Uygulamayı yeniden başlatın

## Lisans

Bu proje özel kullanım içindir.
