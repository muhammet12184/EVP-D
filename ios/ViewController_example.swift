import UIKit
import CoreBluetooth

/**
 * ÖRNEK ViewController
 * Bu kodu kendi ViewController'ınıza entegre edin
 */
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bluetooth izinlerini kontrol et ve başlat
        checkBluetoothAndStart()
    }
    
    private func checkBluetoothAndStart() {
        BluetoothPermissionHelper.shared.checkAndRequestPermissions(
            onReady: { [weak self] in
                // ✅ Bluetooth hazır
                self?.startBluetoothConnection()
            },
            onError: { [weak self] errorMessage in
                // ❌ Hata oluştu
                self?.showError(errorMessage)
            }
        )
    }
    
    private func startBluetoothConnection() {
        print("✅ Bluetooth bağlantısı başlatılıyor...")
        // TODO: Bluetooth bağlantı kodunuzu buraya ekleyin
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Hata",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
