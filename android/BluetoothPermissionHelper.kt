package com.yourapp.bluetooth

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

/**
 * Bluetooth İzin Yardımcısı
 * Bu sınıfı projenize ekleyin ve MainActivity'den çağırın
 */
object BluetoothPermissionHelper {

    const val REQUEST_BLUETOOTH_PERMISSIONS = 1001
    const val REQUEST_ENABLE_BLUETOOTH = 1002
    const val REQUEST_ENABLE_LOCATION = 1003

    /**
     * Gerekli tüm izinleri döndürür (Android versiyonuna göre)
     */
    fun getRequiredPermissions(): Array<String> {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+ (API 31+)
            arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_ADVERTISE,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
        } else {
            // Android 11 ve altı
            arrayOf(
                Manifest.permission.BLUETOOTH,
                Manifest.permission.BLUETOOTH_ADMIN,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
        }
    }

    /**
     * Tüm izinler verilmiş mi kontrol eder
     */
    fun hasAllPermissions(context: Context): Boolean {
        return getRequiredPermissions().all { permission ->
            ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED
        }
    }

    /**
     * Eksik izinleri döndürür
     */
    fun getMissingPermissions(context: Context): List<String> {
        return getRequiredPermissions().filter { permission ->
            ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED
        }
    }

    /**
     * İzinleri iste
     */
    fun requestPermissions(activity: Activity) {
        val missingPermissions = getMissingPermissions(activity)
        if (missingPermissions.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                activity,
                missingPermissions.toTypedArray(),
                REQUEST_BLUETOOTH_PERMISSIONS
            )
        }
    }

    /**
     * Bluetooth açık mı kontrol eder
     */
    fun isBluetoothEnabled(context: Context): Boolean {
        val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
        return bluetoothManager?.adapter?.isEnabled == true
    }

    /**
     * Bluetooth'u açmasını iste
     */
    fun requestEnableBluetooth(activity: Activity) {
        try {
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            activity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BLUETOOTH)
        } catch (e: SecurityException) {
            // İzin yoksa ayarlara yönlendir
            showBluetoothSettingsDialog(activity)
        }
    }

    /**
     * Konum servisleri açık mı kontrol eder
     */
    fun isLocationEnabled(context: Context): Boolean {
        val locationMode = try {
            Settings.Secure.getInt(context.contentResolver, Settings.Secure.LOCATION_MODE)
        } catch (e: Settings.SettingNotFoundException) {
            Settings.Secure.LOCATION_MODE_OFF
        }
        return locationMode != Settings.Secure.LOCATION_MODE_OFF
    }

    /**
     * Konum servislerini açmasını iste
     */
    fun requestEnableLocation(activity: Activity) {
        AlertDialog.Builder(activity)
            .setTitle("Konum Gerekli")
            .setMessage("Bluetooth cihazlarını bulmak için konum servislerini açmanız gerekiyor.")
            .setPositiveButton("Ayarları Aç") { _, _ ->
                activity.startActivityForResult(
                    Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS),
                    REQUEST_ENABLE_LOCATION
                )
            }
            .setNegativeButton("İptal", null)
            .show()
    }

    /**
     * Bluetooth ayarlarına yönlendir
     */
    private fun showBluetoothSettingsDialog(activity: Activity) {
        AlertDialog.Builder(activity)
            .setTitle("Bluetooth Gerekli")
            .setMessage("Lütfen Bluetooth'u ayarlardan açın.")
            .setPositiveButton("Ayarları Aç") { _, _ ->
                activity.startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
            }
            .setNegativeButton("İptal", null)
            .show()
    }

    /**
     * İzin reddedildi dialogu
     */
    fun showPermissionDeniedDialog(activity: Activity) {
        AlertDialog.Builder(activity)
            .setTitle("İzin Gerekli")
            .setMessage("Bluetooth bağlantısı için gerekli izinleri vermeniz gerekiyor. Lütfen uygulama ayarlarından izinleri açın.")
            .setPositiveButton("Ayarları Aç") { _, _ ->
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                intent.data = android.net.Uri.parse("package:" + activity.packageName)
                activity.startActivity(intent)
            }
            .setNegativeButton("İptal", null)
            .show()
    }

    /**
     * Tam kontrol ve başlatma
     * MainActivity'de onCreate'de çağırın
     */
    fun checkAndRequestAll(activity: Activity, onReady: () -> Unit) {
        // 1. İzinleri kontrol et
        if (!hasAllPermissions(activity)) {
            requestPermissions(activity)
            return
        }

        // 2. Bluetooth açık mı kontrol et
        if (!isBluetoothEnabled(activity)) {
            requestEnableBluetooth(activity)
            return
        }

        // 3. Konum açık mı kontrol et (Android 11 ve altı için)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S && !isLocationEnabled(activity)) {
            requestEnableLocation(activity)
            return
        }

        // Her şey tamam
        onReady()
    }
}
