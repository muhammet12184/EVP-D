# Flutter Bluetooth İzinleri ve Çözüm

## 📱 Flutter için Bluetooth Kurulumu

### 1. Gerekli Paketler

pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^11.0.1
  flutter_blue_plus: ^1.14.0
  # VEYA
  flutter_bluetooth_serial: ^0.4.0
```

Yüklemek için:
```bash
flutter pub get
```

### 2. Android Kurulumu

#### android/app/src/main/AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <!-- Bluetooth İzinleri -->
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN"
        android:usesPermissionFlags="neverForLocation"
        tools:targetApi="s" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    
    <uses-permission android:name="android.permission.BLUETOOTH"
        android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"
        android:maxSdkVersion="30" />
    
    <!-- Konum İzinleri -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <uses-feature android:name="android.hardware.bluetooth" android:required="true" />
    <uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />

    <application>
        <!-- ... -->
    </application>
</manifest>
```

#### android/build.gradle

```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
    // ...
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

#### android/app/build.gradle

```gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

### 3. iOS Kurulumu

#### ios/Runner/Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Bluetooth İzinleri -->
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>This app needs Bluetooth to connect to devices</string>
    
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>This app needs Bluetooth to connect to devices</string>
    
    <!-- Konum İzinleri -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location to scan for Bluetooth devices</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs location to scan for Bluetooth devices</string>
    
    <!-- Arka Plan Modları -->
    <key>UIBackgroundModes</key>
    <array>
        <string>bluetooth-central</string>
        <string>bluetooth-peripheral</string>
    </array>
</dict>
</plist>
```

### 4. Flutter Kod - İzin İsteği

```dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class BluetoothPermissionManager {
  
  // Tüm gerekli izinleri kontrol et ve iste
  static Future<bool> requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      return await _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      return await _requestIOSPermissions();
    }
    return false;
  }

  // Android izinleri
  static Future<bool> _requestAndroidPermissions() async {
    // Android sürümünü kontrol et
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    Map<Permission, PermissionStatus> statuses;

    if (sdkInt >= 31) {
      // Android 12+ (API 31+)
      statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.locationWhenInUse,
      ].request();
    } else {
      // Android 11 ve altı
      statuses = await [
        Permission.bluetooth,
        Permission.location,
        Permission.locationWhenInUse,
      ].request();
    }

    // Tüm izinler verildi mi kontrol et
    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      print('Bazı izinler reddedildi');
      return false;
    }

    return true;
  }

  // iOS izinleri
  static Future<bool> _requestIOSPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.locationWhenInUse,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      print('iOS izinleri reddedildi');
      return false;
    }

    return true;
  }

  // İzin durumunu kontrol et
  static Future<bool> checkBluetoothPermissions() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 31) {
        return await Permission.bluetoothScan.isGranted &&
               await Permission.bluetoothConnect.isGranted;
      } else {
        return await Permission.bluetooth.isGranted &&
               await Permission.location.isGranted;
      }
    } else if (Platform.isIOS) {
      return await Permission.bluetooth.isGranted &&
             await Permission.locationWhenInUse.isGranted;
    }
    return false;
  }

  // Kullanıcıyı ayarlara yönlendir
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
```

### 5. Bluetooth Tarama Widget'ı

```dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScanScreen extends StatefulWidget {
  @override
  _BluetoothScanScreenState createState() => _BluetoothScanScreenState();
}

class _BluetoothScanScreenState extends State<BluetoothScanScreen> {
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndBluetooth();
  }

  Future<void> checkPermissionsAndBluetooth() async {
    // İzinleri kontrol et
    hasPermission = await BluetoothPermissionManager.requestBluetoothPermissions();
    
    if (!hasPermission) {
      _showPermissionDialog();
      return;
    }

    // Bluetooth durumunu kontrol et
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.off) {
        _showBluetoothOffDialog();
      } else if (state == BluetoothAdapterState.on) {
        print('Bluetooth açık');
      } else if (state == BluetoothAdapterState.unauthorized) {
        _showPermissionDialog();
      }
    });

    setState(() {});
  }

  Future<void> startScan() async {
    if (!hasPermission) {
      _showPermissionDialog();
      return;
    }

    setState(() {
      isScanning = true;
      scanResults.clear();
    });

    try {
      // Taramayı başlat
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      // Tarama sonuçlarını dinle
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          scanResults = results;
        });
      });

      // Tarama bittiğinde
      await Future.delayed(Duration(seconds: 10));
      await FlutterBluePlus.stopScan();
      
    } catch (e) {
      print('Tarama hatası: $e');
      
      if (e.toString().contains('unauthorized')) {
        _showPermissionDialog();
      }
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      await device.connect();
      Navigator.pop(context); // Loading dialog'u kapat

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${device.name} cihazına bağlandı')),
      );

      // Servisleri keşfet
      List<BluetoothService> services = await device.discoverServices();
      
      // Burada servislerle işlem yapabilirsiniz
      
    } catch (e) {
      Navigator.pop(context);
      print('Bağlantı hatası: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bağlantı başarısız: $e')),
      );
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('İzin Gerekli'),
        content: Text('Bluetooth kullanmak için izinlere ihtiyacımız var.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Ayarlar'),
          ),
        ],
      ),
    );
  }

  void _showBluetoothOffDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bluetooth Kapalı'),
        content: Text('Lütfen Bluetooth\'u açın.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Cihazları'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isScanning ? null : startScan,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!hasPermission)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.orange,
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bluetooth izinleri gerekli',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      hasPermission = await BluetoothPermissionManager
                          .requestBluetoothPermissions();
                      setState(() {});
                    },
                    child: Text('İzin Ver', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          if (isScanning)
            LinearProgressIndicator(),
          Expanded(
            child: scanResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bluetooth_searching, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          isScanning
                              ? 'Cihazlar aranıyor...'
                              : 'Henüz cihaz bulunamadı',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        if (!isScanning)
                          ElevatedButton.icon(
                            onPressed: startScan,
                            icon: Icon(Icons.search),
                            label: Text('Tara'),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: scanResults.length,
                    itemBuilder: (context, index) {
                      final result = scanResults[index];
                      final device = result.device;
                      
                      return ListTile(
                        leading: Icon(Icons.bluetooth),
                        title: Text(
                          device.name.isEmpty ? 'İsimsiz Cihaz' : device.name,
                        ),
                        subtitle: Text(device.id.toString()),
                        trailing: Text('${result.rssi} dBm'),
                        onTap: () => connectToDevice(device),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : startScan,
        child: Icon(isScanning ? Icons.stop : Icons.search),
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
```

### 6. Ana Uygulama Entegrasyonu

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothScanScreen(),
    );
  }
}
```

### 7. Hata Yönetimi

```dart
class BluetoothErrorHandler {
  static void handleError(dynamic error, BuildContext context) {
    String message = 'Bir hata oluştu';

    if (error.toString().contains('unauthorized')) {
      message = 'Bluetooth izni verilmedi';
    } else if (error.toString().contains('poweredOff')) {
      message = 'Bluetooth kapalı';
    } else if (error.toString().contains('timeout')) {
      message = 'Bağlantı zaman aşımı';
    } else if (error.toString().contains('connection')) {
      message = 'Bağlantı hatası';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Tamam',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
```

### 8. pubspec.yaml Tam Örnek

```yaml
name: bluetooth_app
description: A Flutter Bluetooth application

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  # Bluetooth paketleri
  flutter_blue_plus: ^1.14.0
  
  # İzin yönetimi
  permission_handler: ^11.0.1
  
  # Cihaz bilgisi (Android versiyonu için)
  device_info_plus: ^9.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
```

## ⚠️ ÖNEMLİ NOTLAR

1. **permission_handler paketini mutlaka ekleyin**
2. **AndroidManifest.xml ve Info.plist güncellemelerini yapın**
3. **Android 12+ için yeni izinleri kullanın**
4. **Her işlem öncesi izin kontrolü yapın**
5. **Bluetooth durumunu sürekli kontrol edin**
6. **Try-catch blokları kullanın**
7. **Kullanıcıya açıklayıcı mesajlar gösterin**

## 🐛 Yaygın Hatalar ve Çözümleri

### Hata: PlatformException (Bluetooth, Unauthorized)
**Çözüm:** İzinleri kontrol edin ve AndroidManifest.xml/Info.plist'i güncelleyin

### Hata: App crashes on scan
**Çözüm:** İzin kontrolü yapmadan tarama yapmayın

### Hata: No devices found
**Çözüm:** 
- Konum servislerinin açık olduğundan emin olun
- ACCESS_FINE_LOCATION izninin verildiğinden emin olun
- Bluetooth'un açık olduğundan emin olun

### Hata: iOS Info.plist error
**Çözüm:** NSBluetoothAlwaysUsageDescription ekleyin

## 📱 Test Etme

```bash
# Android'de test
flutter run -d android

# iOS'ta test
flutter run -d ios

# Logları kontrol et
flutter logs
```

## ✅ Checklist

- [ ] pubspec.yaml'a paketler eklendi
- [ ] AndroidManifest.xml güncellendi
- [ ] Info.plist güncellendi
- [ ] İzin kontrolü kodu eklendi
- [ ] Bluetooth durum kontrolü yapılıyor
- [ ] Hata yönetimi eklendi
- [ ] Kullanıcı bildirimleri eklendi
- [ ] Test edildi
