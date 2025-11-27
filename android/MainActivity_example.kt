package com.yourapp

import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.yourapp.bluetooth.BluetoothPermissionHelper

/**
 * ÖRNEK MainActivity
 * Bu kodu kendi MainActivity'nize entegre edin
 */
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Bluetooth izinlerini kontrol et ve başlat
        checkBluetoothAndStart()
    }

    private fun checkBluetoothAndStart() {
        BluetoothPermissionHelper.checkAndRequestAll(this) {
            // ✅ Tüm izinler tamam, Bluetooth açık
            // Bluetooth işlemlerinizi burada başlatın
            startBluetoothConnection()
        }
    }

    private fun startBluetoothConnection() {
        Toast.makeText(this, "Bluetooth hazır!", Toast.LENGTH_SHORT).show()
        // TODO: Bluetooth bağlantı kodunuzu buraya ekleyin
    }

    // İzin sonuçlarını işle
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            BluetoothPermissionHelper.REQUEST_BLUETOOTH_PERMISSIONS -> {
                if (grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                    // İzinler verildi, tekrar kontrol et
                    checkBluetoothAndStart()
                } else {
                    // İzinler reddedildi
                    BluetoothPermissionHelper.showPermissionDeniedDialog(this)
                }
            }
        }
    }

    // Activity sonuçlarını işle (Bluetooth açma vs.)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode) {
            BluetoothPermissionHelper.REQUEST_ENABLE_BLUETOOTH,
            BluetoothPermissionHelper.REQUEST_ENABLE_LOCATION -> {
                // Tekrar kontrol et
                checkBluetoothAndStart()
            }
        }
    }
}
