import Foundation
import CoreBluetooth
import CoreLocation
import UIKit

/**
 * Bluetooth İzin Yardımcısı - iOS
 * Bu sınıfı projenize ekleyin
 */
class BluetoothPermissionHelper: NSObject, CBCentralManagerDelegate, CLLocationManagerDelegate {
    
    static let shared = BluetoothPermissionHelper()
    
    private var centralManager: CBCentralManager!
    private var locationManager: CLLocationManager!
    
    private var onBluetoothReady: (() -> Void)?
    private var onBluetoothError: ((String) -> Void)?
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Bluetooth'u kontrol et ve hazır olduğunda callback çağır
    func checkAndRequestPermissions(onReady: @escaping () -> Void, onError: @escaping (String) -> Void) {
        self.onBluetoothReady = onReady
        self.onBluetoothError = onError
        
        // Bluetooth durumunu kontrol et
        checkBluetoothState()
    }
    
    /// Konum izni iste (gerekirse)
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationPermissionAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Konum izni mevcut")
        @unknown default:
            break
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        checkBluetoothState()
    }
    
    private func checkBluetoothState() {
        switch centralManager.state {
        case .poweredOn:
            print("✅ Bluetooth açık ve hazır")
            onBluetoothReady?()
            
        case .poweredOff:
            print("❌ Bluetooth kapalı")
            showBluetoothOffAlert()
            onBluetoothError?("Bluetooth kapalı. Lütfen Bluetooth'u açın.")
            
        case .unauthorized:
            print("❌ Bluetooth izni verilmemiş")
            showBluetoothPermissionAlert()
            onBluetoothError?("Bluetooth izni verilmemiş. Lütfen ayarlardan izin verin.")
            
        case .unsupported:
            print("❌ Bu cihaz Bluetooth desteklemiyor")
            onBluetoothError?("Bu cihaz Bluetooth desteklemiyor.")
            
        case .resetting:
            print("⚠️ Bluetooth sıfırlanıyor...")
            
        case .unknown:
            print("⚠️ Bluetooth durumu belirleniyor...")
            
        @unknown default:
            print("⚠️ Bilinmeyen Bluetooth durumu")
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Konum izni verildi")
        case .denied, .restricted:
            print("❌ Konum izni reddedildi")
        default:
            break
        }
    }
    
    // MARK: - Alert Dialogs
    
    private func showBluetoothOffAlert() {
        DispatchQueue.main.async {
            guard let topVC = self.topViewController() else { return }
            
            let alert = UIAlertController(
                title: "Bluetooth Kapalı",
                message: "Cihaza bağlanmak için Bluetooth'u açmanız gerekiyor.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Ayarları Aç", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
            
            topVC.present(alert, animated: true)
        }
    }
    
    private func showBluetoothPermissionAlert() {
        DispatchQueue.main.async {
            guard let topVC = self.topViewController() else { return }
            
            let alert = UIAlertController(
                title: "Bluetooth İzni Gerekli",
                message: "Bu uygulama Bluetooth kullanmak için izninizi gerektiriyor. Lütfen Ayarlar'dan izin verin.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Ayarları Aç", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
            
            topVC.present(alert, animated: true)
        }
    }
    
    private func showLocationPermissionAlert() {
        DispatchQueue.main.async {
            guard let topVC = self.topViewController() else { return }
            
            let alert = UIAlertController(
                title: "Konum İzni Gerekli",
                message: "Bluetooth cihazlarını bulmak için konum izni gereklidir.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Ayarları Aç", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
            
            topVC.present(alert, animated: true)
        }
    }
    
    // MARK: - Helper
    
    private func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        
        var topVC = window.rootViewController
        while let presented = topVC?.presentedViewController {
            topVC = presented
        }
        return topVC
    }
}
