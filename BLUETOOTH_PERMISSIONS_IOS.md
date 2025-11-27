# iOS Bluetooth İzinleri - ACİL ÇÖZÜM

## ⚠️ UYGULAMA ÇÖKME ÇÖZÜMÜ

iOS'ta Bluetooth kullanımı için `Info.plist` dosyasına açıklama eklenmesi ZORUNLUDUR. Aksi halde uygulama çöker.

## 1. Info.plist'e Eklenmesi ZORUNLU Anahtarlar

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Bluetooth İzni - İOS 13+ için ZORUNLU -->
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>Bu uygulama Bluetooth cihazlarına bağlanmak için Bluetooth erişimine ihtiyaç duyar.</string>
    
    <!-- Bluetooth İzni - İOS 12 ve altı için -->
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>Bu uygulama Bluetooth cihazlarıyla iletişim kurmak için Bluetooth erişimine ihtiyaç duyar.</string>
    
    <!-- Konum İzinleri - Bluetooth tarama için gerekli -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Bluetooth cihazlarını taramak için konumunuza erişmemiz gerekiyor.</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Bluetooth cihazlarını arka planda taramak için konumunuza her zaman erişmemiz gerekiyor.</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Bluetooth cihazlarını arka planda taramak için konumunuza her zaman erişmemiz gerekiyor.</string>
    
    <!-- Arka Plan Modları (opsiyonel - arka planda çalışma için) -->
    <key>UIBackgroundModes</key>
    <array>
        <string>bluetooth-central</string>
        <string>bluetooth-peripheral</string>
    </array>
</dict>
</plist>
```

## 2. Swift İle Runtime İzin İsteği

### CoreBluetooth Kullanımı:

```swift
import CoreBluetooth
import CoreLocation

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate {
    
    var centralManager: CBCentralManager!
    var locationManager: CLLocationManager!
    var discoveredPeripherals: [CBPeripheral] = []
    
    override init() {
        super.init()
        
        // Location Manager'ı başlat
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Konum iznini iste
        requestLocationPermission()
        
        // Central Manager'ı başlat (Bluetooth izni otomatik istenir)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Konum İzni
    
    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            // İlk kez, izin iste
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            // İzin reddedilmiş, kullanıcıyı ayarlara yönlendir
            showLocationPermissionAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            // İzin verilmiş
            print("Konum izni verildi")
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Konum izni verildi")
            // Bluetooth taramaya başlayabilirsiniz
            
        case .denied, .restricted:
            print("Konum izni reddedildi")
            showLocationPermissionAlert()
            
        case .notDetermined:
            // Kullanıcı henüz karar vermedi
            break
            
        @unknown default:
            break
        }
    }
    
    // MARK: - Bluetooth Central Manager
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Bluetooth durumu bilinmiyor")
            
        case .resetting:
            print("Bluetooth sıfırlanıyor")
            
        case .unsupported:
            print("Bu cihaz Bluetooth'u desteklemiyor")
            showBluetoothNotSupportedAlert()
            
        case .unauthorized:
            print("Bluetooth izni yok")
            showBluetoothPermissionAlert()
            
        case .poweredOff:
            print("Bluetooth kapalı")
            showBluetoothOffAlert()
            
        case .poweredOn:
            print("Bluetooth açık ve hazır")
            // Taramaya başla
            startScanning()
            
        @unknown default:
            break
        }
    }
    
    // MARK: - Bluetooth Tarama
    
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth hazır değil")
            return
        }
        
        // Tüm cihazları tara (nil = tüm servisler)
        // Belirli servisleri taramak için: [CBUUID(string: "YOUR-SERVICE-UUID")]
        centralManager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: false
        ])
        
        print("Bluetooth tarama başladı")
    }
    
    func stopScanning() {
        centralManager.stopScan()
        print("Bluetooth tarama durduruldu")
    }
    
    // MARK: - Cihaz Keşfi
    
    func centralManager(_ central: CBCentralManager, 
                       didDiscover peripheral: CBPeripheral,
                       advertisementData: [String : Any], 
                       rssi RSSI: NSNumber) {
        
        // Keşfedilen cihazı listeye ekle
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            print("Cihaz bulundu: \(peripheral.name ?? "İsimsiz Cihaz")")
        }
    }
    
    // MARK: - Cihaza Bağlanma
    
    func connect(to peripheral: CBPeripheral) {
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
        print("Bağlanıyor: \(peripheral.name ?? "İsimsiz Cihaz")")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Bağlandı: \(peripheral.name ?? "İsimsiz Cihaz")")
        
        // Servisleri keşfet
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, 
                       didFailToConnect peripheral: CBPeripheral, 
                       error: Error?) {
        print("Bağlantı başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
    }
    
    func centralManager(_ central: CBCentralManager, 
                       didDisconnectPeripheral peripheral: CBPeripheral, 
                       error: Error?) {
        print("Bağlantı kesildi: \(peripheral.name ?? "İsimsiz Cihaz")")
    }
    
    // MARK: - Peripheral Delegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Servis keşfi hatası: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("Servis bulundu: \(service.uuid)")
            // Karakteristikleri keşfet
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                   didDiscoverCharacteristicsFor service: CBService, 
                   error: Error?) {
        guard error == nil else {
            print("Karakteristik keşfi hatası: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("Karakteristik bulundu: \(characteristic.uuid)")
            
            // Okuma
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            
            // Bildirim
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                   didUpdateValueFor characteristic: CBCharacteristic, 
                   error: Error?) {
        guard error == nil else {
            print("Değer okuma hatası: \(error!.localizedDescription)")
            return
        }
        
        if let data = characteristic.value {
            print("Veri alındı: \(data)")
            // Veriyi işle
        }
    }
    
    // MARK: - Uyarı Mesajları
    
    func showBluetoothPermissionAlert() {
        let alert = UIAlertController(
            title: "Bluetooth İzni Gerekli",
            message: "Lütfen Ayarlar'dan Bluetooth iznini etkinleştirin.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ayarlar", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        // Alert'i göster (ViewController'dan çağırılmalı)
        // presentingViewController?.present(alert, animated: true)
    }
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Konum İzni Gerekli",
            message: "Bluetooth cihazlarını taramak için konum iznine ihtiyacımız var.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ayarlar", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        // Alert'i göster
    }
    
    func showBluetoothOffAlert() {
        let alert = UIAlertController(
            title: "Bluetooth Kapalı",
            message: "Lütfen Bluetooth'u açın.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        
        // Alert'i göster
    }
    
    func showBluetoothNotSupportedAlert() {
        let alert = UIAlertController(
            title: "Bluetooth Desteklenmiyor",
            message: "Bu cihaz Bluetooth'u desteklemiyor.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        
        // Alert'i göster
    }
}
```

## 3. SwiftUI Kullanımı

```swift
import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        NavigationView {
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Button(action: {
                    bluetoothManager.connect(to: peripheral)
                }) {
                    VStack(alignment: .leading) {
                        Text(peripheral.name ?? "İsimsiz Cihaz")
                            .font(.headline)
                        Text(peripheral.identifier.uuidString)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Bluetooth Cihazları")
            .toolbar {
                Button(action: {
                    bluetoothManager.startScanning()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}
```

## 4. ÖNEMLİ NOTLAR

1. **Info.plist açıklamaları ZORUNLUDUR** - Yoksa uygulama çöker
2. **iOS 13+** için `NSBluetoothAlwaysUsageDescription` mutlaka eklenmelidir
3. **Konum izni** Bluetooth tarama için iOS'ta gereklidir
4. **CBCentralManager** başlatıldığında otomatik olarak Bluetooth izni istenir
5. Her zaman **Bluetooth durumunu kontrol edin** (poweredOn, unauthorized, etc.)
6. **Try-catch** veya **guard** kullanarak hata yönetimi yapın
7. **Background modes** sadece arka planda çalışma gerekiyorsa ekleyin

## 5. Test Checklist

- [ ] Info.plist'te `NSBluetoothAlwaysUsageDescription` var mı?
- [ ] Info.plist'te `NSBluetoothPeripheralUsageDescription` var mı? (iOS 12-)
- [ ] Info.plist'te konum izinleri var mı?
- [ ] Runtime'da CBCentralManager durumu kontrol ediliyor mu?
- [ ] Konum izni runtime'da isteniyor mu?
- [ ] Bluetooth kapalı/açık durumu kontrol ediliyor mu?
- [ ] Kullanıcıya açıklayıcı mesajlar gösteriliyor mu?
- [ ] Ayarlara yönlendirme yapılabiliyor mu?

## 6. Hata Ayıklama

Xcode Console'da şu hataları görürseniz:

```
[CoreBluetooth] This app has crashed because it attempted to access privacy-sensitive data without a usage description.
```

Bu, Info.plist'e izin açıklaması eklemeyi unuttuğunuz anlamına gelir.

```
[CoreBluetooth] XPC connection invalid
```

Bu genellikle Bluetooth izninin reddedildiği anlamına gelir.
