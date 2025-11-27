# Android Bluetooth İzinleri - ACİL ÇÖZÜM

## ⚠️ UYGULAMA DURDU HATASI ÇÖZÜMÜ

"Uygulama Durdu" hatası genellikle eksik izinler ve runtime permission kontrollerinden kaynaklanır.

## 1. AndroidManifest.xml'e Eklenmesi ZORUNLU İzinler

```xml
<!-- Bluetooth İzinleri -->
<!-- Android 12 (API 31) ve üzeri için -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"
    android:usesPermissionFlags="neverForLocation"
    tools:targetApi="s" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />

<!-- Android 11 (API 30) ve altı için -->
<uses-permission android:name="android.permission.BLUETOOTH" 
    android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" 
    android:maxSdkVersion="30" />

<!-- Konum İzinleri (Bluetooth tarama için ZORUNLU) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- Android 10+ için arka plan konumu (opsiyonel) -->
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

<!-- Bluetooth özelliği gereksinimini belirt -->
<uses-feature android:name="android.hardware.bluetooth" android:required="true" />
<uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />
```

## 2. Runtime İzin İsteği - ÇÖKMEYI ÖNLEMEK İÇİN GEREKLİ

### Kotlin Örneği:

```kotlin
import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class BluetoothActivity : AppCompatActivity() {
    
    private val bluetoothManager: BluetoothManager by lazy {
        getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    }
    
    private val bluetoothAdapter: BluetoothAdapter? by lazy {
        bluetoothManager.adapter
    }
    
    // İzin isteme launcher'ı
    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val allGranted = permissions.entries.all { it.value }
        if (allGranted) {
            // İzinler verildi, Bluetooth işlemlerine başla
            startBluetoothOperations()
        } else {
            // İzinler reddedildi
            showPermissionDeniedDialog()
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // İzinleri kontrol et ve iste
        checkAndRequestBluetoothPermissions()
    }
    
    private fun checkAndRequestBluetoothPermissions() {
        val permissions = mutableListOf<String>()
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+
            permissions.add(Manifest.permission.BLUETOOTH_SCAN)
            permissions.add(Manifest.permission.BLUETOOTH_CONNECT)
            permissions.add(Manifest.permission.BLUETOOTH_ADVERTISE)
        } else {
            // Android 11 ve altı
            permissions.add(Manifest.permission.BLUETOOTH)
            permissions.add(Manifest.permission.BLUETOOTH_ADMIN)
        }
        
        // Konum izinleri (tüm versiyonlar için)
        permissions.add(Manifest.permission.ACCESS_FINE_LOCATION)
        permissions.add(Manifest.permission.ACCESS_COARSE_LOCATION)
        
        // İzinleri kontrol et
        val permissionsToRequest = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }
        
        if (permissionsToRequest.isNotEmpty()) {
            // İzinleri iste
            requestPermissionLauncher.launch(permissionsToRequest.toTypedArray())
        } else {
            // İzinler zaten verilmiş
            startBluetoothOperations()
        }
    }
    
    private fun startBluetoothOperations() {
        // Bluetooth'u etkinleştir
        if (bluetoothAdapter == null) {
            // Cihaz Bluetooth'u desteklemiyor
            showBluetoothNotSupportedDialog()
            return
        }
        
        if (!bluetoothAdapter!!.isEnabled) {
            // Bluetooth kapalı, kullanıcıdan açmasını iste
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.BLUETOOTH_CONNECT
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    return
                }
            }
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
        } else {
            // Bluetooth açık, tarama başlat
            scanForDevices()
        }
    }
    
    private fun scanForDevices() {
        // İzin kontrolü ile Bluetooth tarama
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH_SCAN
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return
            }
        }
        
        // Bluetooth tarama kodunuz buraya
        // ...
    }
    
    private fun showPermissionDeniedDialog() {
        // İzin reddedildiğinde kullanıcıya bilgi ver
        AlertDialog.Builder(this)
            .setTitle("İzinler Gerekli")
            .setMessage("Bluetooth özelliklerini kullanmak için izinlere ihtiyacımız var.")
            .setPositiveButton("Ayarlara Git") { _, _ ->
                // Uygulama ayarlarına yönlendir
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                val uri = Uri.fromParts("package", packageName, null)
                intent.data = uri
                startActivity(intent)
            }
            .setNegativeButton("İptal", null)
            .show()
    }
    
    private fun showBluetoothNotSupportedDialog() {
        AlertDialog.Builder(this)
            .setTitle("Bluetooth Desteklenmiyor")
            .setMessage("Bu cihaz Bluetooth'u desteklemiyor.")
            .setPositiveButton("Tamam", null)
            .show()
    }
    
    companion object {
        private const val REQUEST_ENABLE_BT = 1
    }
}
```

## 3. ProGuard Kuralları (build.gradle'a ekle)

```
-keep class android.bluetooth.** { *; }
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
```

## 4. Hata Kontrolü Wrapper Fonksiyonu

```kotlin
// Her Bluetooth işlemi öncesi bu kontrolü yap
fun isBluetoothPermissionGranted(): Boolean {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.BLUETOOTH_CONNECT
        ) == PackageManager.PERMISSION_GRANTED &&
        ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.BLUETOOTH_SCAN
        ) == PackageManager.PERMISSION_GRANTED
    } else {
        ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.BLUETOOTH
        ) == PackageManager.PERMISSION_GRANTED &&
        ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }
}
```

## 5. ÖNEMLİ NOTLAR

1. **Android 12+** için `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `BLUETOOTH_ADVERTISE` ZORUNLU
2. **Android 11 ve altı** için `ACCESS_FINE_LOCATION` ZORUNLU
3. **Runtime permission** kontrolü YAPMADAN Bluetooth işlemi YAPMAYIN
4. Her Bluetooth API çağrısı öncesi izin kontrolü yapın
5. `try-catch` blokları kullanarak hata yönetimi yapın

## 6. Test Checklist

- [ ] AndroidManifest.xml'de tüm izinler var mı?
- [ ] Runtime permission isteme kodu eklendi mi?
- [ ] Android 12+ ve altı versiyonlar için farklı izinler kontrol ediliyor mu?
- [ ] Bluetooth açık/kapalı durumu kontrol ediliyor mu?
- [ ] Her Bluetooth işlemi try-catch içinde mi?
- [ ] Kullanıcıya açıklayıcı mesajlar gösteriliyor mu?
