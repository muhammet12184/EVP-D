import UIKit

/**
 * ❌ SORUN: Butonlar çalışmıyor / tıklanamıyor (iOS)
 *
 * OLASI SEBEPLER VE ÇÖZÜMLER:
 */

// ============================================================
// SEBEP 1: Target/Action bağlı değil
// ============================================================

// ❌ YANLIŞ - Action bağlı değil
class WrongViewController1: UIViewController {
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Action bağlı değil!
    }
}

// ✅ DOĞRU - Action bağla
class CorrectViewController1: UIViewController {
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Programatik olarak action bağla
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)
    }
    
    @objc func connectTapped() {
        print("Butona tıklandı!")
    }
}

// ============================================================
// SEBEP 2: Storyboard'da IBAction bağlı değil
// ============================================================

/*
 Storyboard kullanıyorsanız:
 1. Storyboard'u açın
 2. Butona sağ tıklayın
 3. "Touch Up Inside" eventini ViewController'daki 
    @IBAction fonksiyonuna sürükleyin
*/

// ✅ DOĞRU - IBAction tanımla
class CorrectViewController2: UIViewController {
    
    @IBAction func connectButtonTapped(_ sender: UIButton) {
        print("Butona tıklandı!")
        connectBluetooth()
    }
    
    func connectBluetooth() {
        // Bağlantı kodu
    }
}

// ============================================================
// SEBEP 3: isUserInteractionEnabled = false
// ============================================================

// ❌ YANLIŞ
class WrongViewController3: UIViewController {
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectButton.isUserInteractionEnabled = false // SORUN!
        connectButton.isEnabled = false // SORUN!
    }
}

// ✅ DOĞRU
class CorrectViewController3: UIViewController {
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectButton.isUserInteractionEnabled = true
        connectButton.isEnabled = true
    }
}

// ============================================================
// SEBEP 4: Üstte görünmez view var
// ============================================================

// ❌ YANLIŞ - Üstteki view tıklamayı engelliyor
class WrongViewController4: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = true // SORUN!
        view.addSubview(overlayView)
    }
}

// ✅ DOĞRU - Overlay'i kaldır veya interaction'ı kapat
class CorrectViewController4: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false // Tıklamayı geçir
        view.addSubview(overlayView)
    }
}

// ============================================================
// SEBEP 5: Main thread bloklanıyor
// ============================================================

// ❌ YANLIŞ - Ana thread bloklanıyor
class WrongViewController5: UIViewController {
    @objc func connectTapped() {
        // Bu ana thread'i bloklar
        Thread.sleep(forTimeInterval: 5)
        let result = heavyOperation()
    }
}

// ✅ DOĞRU - Arka planda çalıştır
class CorrectViewController5: UIViewController {
    @objc func connectTapped() {
        DispatchQueue.global(qos: .background).async {
            let result = self.heavyOperation()
            
            DispatchQueue.main.async {
                // UI güncelle
                self.updateUI(result)
            }
        }
    }
}

// ============================================================
// SEBEP 6: Auto Layout constraint sorunu
// ============================================================

/*
 Storyboard'da kontrol edin:
 1. Butonun constraint'leri doğru mu?
 2. Butonun frame'i 0x0 mı? (görünmez olabilir)
 3. Buton view hiyerarşisinin dışında mı?
 
 Debug için:
 - Debug View Hierarchy kullanın (Xcode'da)
 - Butonun frame'ini yazdırın
*/

class DebugViewController: UIViewController {
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Buton bilgilerini yazdır
        print("Button frame: \(connectButton.frame)")
        print("Button isEnabled: \(connectButton.isEnabled)")
        print("Button isUserInteractionEnabled: \(connectButton.isUserInteractionEnabled)")
        print("Button isHidden: \(connectButton.isHidden)")
        print("Button alpha: \(connectButton.alpha)")
    }
}

// ============================================================
// ÇÖZÜM: TAM ÇALIŞAN ÖRNEK
// ============================================================

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    private let statusLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    private let connectButton = UIButton(type: .system)
    private let disconnectButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Status Label
        statusLabel.text = "Bağlantı bekleniyor..."
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 18)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // Scan Button
        scanButton.setTitle("🔍 Cihaz Tara", for: .normal)
        scanButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        scanButton.backgroundColor = .systemBlue
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = 12
        scanButton.isEnabled = true
        scanButton.isUserInteractionEnabled = true
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanButton)
        
        // Connect Button
        connectButton.setTitle("🔗 Bağlan", for: .normal)
        connectButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        connectButton.backgroundColor = .systemGreen
        connectButton.setTitleColor(.white, for: .normal)
        connectButton.layer.cornerRadius = 12
        connectButton.isEnabled = true
        connectButton.isUserInteractionEnabled = true
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)
        
        // Disconnect Button
        disconnectButton.setTitle("❌ Bağlantıyı Kes", for: .normal)
        disconnectButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        disconnectButton.backgroundColor = .systemRed
        disconnectButton.setTitleColor(.white, for: .normal)
        disconnectButton.layer.cornerRadius = 12
        disconnectButton.isEnabled = true
        disconnectButton.isUserInteractionEnabled = true
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(disconnectButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            scanButton.widthAnchor.constraint(equalToConstant: 280),
            scanButton.heightAnchor.constraint(equalToConstant: 56),
            
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 16),
            connectButton.widthAnchor.constraint(equalToConstant: 280),
            connectButton.heightAnchor.constraint(equalToConstant: 56),
            
            disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            disconnectButton.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 16),
            disconnectButton.widthAnchor.constraint(equalToConstant: 280),
            disconnectButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    // MARK: - Actions Setup
    private func setupActions() {
        // ⚠️ ÖNEMLİ: addTarget ile action'ları bağla
        scanButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)
        disconnectButton.addTarget(self, action: #selector(disconnectTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc private func scanTapped() {
        print("✅ Scan butonuna tıklandı!")
        statusLabel.text = "Taranıyor..."
        
        // Simüle edilmiş tarama
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.statusLabel.text = "3 cihaz bulundu"
        }
    }
    
    @objc private func connectTapped() {
        print("✅ Connect butonuna tıklandı!")
        statusLabel.text = "Bağlanıyor..."
        
        // Arka planda bağlantı işlemi
        DispatchQueue.global(qos: .background).async {
            // Bluetooth bağlantı işlemi burada
            Thread.sleep(forTimeInterval: 2) // Simülasyon
            
            DispatchQueue.main.async {
                self.statusLabel.text = "✅ Bağlandı!"
            }
        }
    }
    
    @objc private func disconnectTapped() {
        print("✅ Disconnect butonuna tıklandı!")
        statusLabel.text = "Bağlantı kesildi"
    }
}
