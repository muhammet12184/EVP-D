# React Native Bluetooth İzinleri ve Çözüm

## 📱 React Native için Bluetooth Kurulumu

### 1. Gerekli Kütüphaneler

```bash
npm install react-native-permissions
npm install react-native-bluetooth-classic
# VEYA
npm install react-native-ble-plx
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

### 3. iOS Kurulumu

#### ios/YourApp/Info.plist

```xml
<dict>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>This app needs Bluetooth to connect to devices</string>
    
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>This app needs Bluetooth to connect to devices</string>
    
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location to scan for Bluetooth devices</string>
    
    <key>UIBackgroundModes</key>
    <array>
        <string>bluetooth-central</string>
    </array>
</dict>
```

### 4. React Native Kod - İzin İsteği

```typescript
import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  Button,
  Alert,
  Platform,
  PermissionsAndroid,
} from 'react-native';
import { check, request, PERMISSIONS, RESULTS } from 'react-native-permissions';

const BluetoothComponent = () => {
  const [hasPermission, setHasPermission] = useState(false);

  useEffect(() => {
    requestBluetoothPermissions();
  }, []);

  const requestBluetoothPermissions = async () => {
    if (Platform.OS === 'android') {
      await requestAndroidPermissions();
    } else if (Platform.OS === 'ios') {
      await requestIOSPermissions();
    }
  };

  const requestAndroidPermissions = async () => {
    try {
      const androidVersion = Platform.Version;

      if (androidVersion >= 31) {
        // Android 12+
        const permissions = [
          PERMISSIONS.ANDROID.BLUETOOTH_SCAN,
          PERMISSIONS.ANDROID.BLUETOOTH_CONNECT,
          PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION,
        ];

        const results = await Promise.all(
          permissions.map(permission => request(permission))
        );

        const allGranted = results.every(result => result === RESULTS.GRANTED);

        if (allGranted) {
          console.log('Tüm izinler verildi');
          setHasPermission(true);
        } else {
          console.log('Bazı izinler reddedildi');
          Alert.alert(
            'İzin Gerekli',
            'Bluetooth kullanmak için izinlere ihtiyacımız var.',
            [
              { text: 'Tamam' }
            ]
          );
        }
      } else {
        // Android 11 ve altı
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.BLUETOOTH_ADMIN,
          PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        ]);

        if (
          granted['android.permission.BLUETOOTH_ADMIN'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.ACCESS_FINE_LOCATION'] === PermissionsAndroid.RESULTS.GRANTED
        ) {
          console.log('İzinler verildi');
          setHasPermission(true);
        } else {
          console.log('İzinler reddedildi');
        }
      }
    } catch (err) {
      console.error('İzin hatası:', err);
    }
  };

  const requestIOSPermissions = async () => {
    try {
      const bluetoothPermission = await check(PERMISSIONS.IOS.BLUETOOTH_PERIPHERAL);
      const locationPermission = await check(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);

      if (bluetoothPermission === RESULTS.GRANTED && locationPermission === RESULTS.GRANTED) {
        console.log('iOS izinleri verildi');
        setHasPermission(true);
      } else {
        // İzinleri iste
        const locationResult = await request(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
        
        if (locationResult === RESULTS.GRANTED) {
          console.log('iOS konum izni verildi');
          setHasPermission(true);
        } else {
          Alert.alert(
            'İzin Gerekli',
            'Bluetooth cihazlarını taramak için konum iznine ihtiyacımız var.'
          );
        }
      }
    } catch (err) {
      console.error('iOS izin hatası:', err);
    }
  };

  const startScan = () => {
    if (!hasPermission) {
      Alert.alert('Hata', 'İzinler verilmedi');
      return;
    }

    // Bluetooth tarama kodunuz buraya
    console.log('Bluetooth tarama başlıyor...');
  };

  return (
    <View style={{ padding: 20 }}>
      <Text>Bluetooth İzin Durumu: {hasPermission ? 'Verildi' : 'Verilmedi'}</Text>
      <Button
        title="Bluetooth Tara"
        onPress={startScan}
        disabled={!hasPermission}
      />
    </View>
  );
};

export default BluetoothComponent;
```

### 5. BLE (Bluetooth Low Energy) Örneği

```typescript
import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, TouchableOpacity, Alert } from 'react-native';
import { BleManager, Device } from 'react-native-ble-plx';

const BLEComponent = () => {
  const [manager] = useState(new BleManager());
  const [devices, setDevices] = useState<Device[]>([]);
  const [scanning, setScanning] = useState(false);

  useEffect(() => {
    // İzinleri kontrol et
    requestPermissions();

    return () => {
      manager.destroy();
    };
  }, []);

  const requestPermissions = async () => {
    // Önceki örnekteki izin kodu buraya
    // ...
  };

  const startScan = () => {
    setDevices([]);
    setScanning(true);

    manager.startDeviceScan(null, null, (error, device) => {
      if (error) {
        console.error('Tarama hatası:', error);
        setScanning(false);
        
        if (error.reason === 'BluetoothUnauthorized') {
          Alert.alert(
            'Bluetooth İzni Gerekli',
            'Lütfen Bluetooth iznini etkinleştirin.'
          );
        }
        return;
      }

      if (device && device.name) {
        setDevices(prevDevices => {
          const exists = prevDevices.find(d => d.id === device.id);
          if (!exists) {
            return [...prevDevices, device];
          }
          return prevDevices;
        });
      }
    });

    // 10 saniye sonra taramayı durdur
    setTimeout(() => {
      manager.stopDeviceScan();
      setScanning(false);
    }, 10000);
  };

  const connectToDevice = async (device: Device) => {
    try {
      console.log('Bağlanıyor:', device.name);
      
      const connectedDevice = await manager.connectToDevice(device.id);
      await connectedDevice.discoverAllServicesAndCharacteristics();
      
      Alert.alert('Başarılı', `${device.name} cihazına bağlandı`);
      
      // Burada cihazla işlemlerinizi yapabilirsiniz
      
    } catch (error) {
      console.error('Bağlantı hatası:', error);
      Alert.alert('Hata', 'Cihaza bağlanılamadı');
    }
  };

  return (
    <View style={{ flex: 1, padding: 20 }}>
      <TouchableOpacity
        onPress={startScan}
        disabled={scanning}
        style={{
          backgroundColor: scanning ? '#ccc' : '#007AFF',
          padding: 15,
          borderRadius: 10,
          alignItems: 'center',
          marginBottom: 20,
        }}>
        <Text style={{ color: 'white', fontSize: 16 }}>
          {scanning ? 'Taranıyor...' : 'Bluetooth Tara'}
        </Text>
      </TouchableOpacity>

      <FlatList
        data={devices}
        keyExtractor={item => item.id}
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => connectToDevice(item)}
            style={{
              padding: 15,
              borderBottomWidth: 1,
              borderBottomColor: '#eee',
            }}>
            <Text style={{ fontSize: 16, fontWeight: 'bold' }}>
              {item.name || 'İsimsiz Cihaz'}
            </Text>
            <Text style={{ color: '#666', marginTop: 5 }}>
              {item.id}
            </Text>
          </TouchableOpacity>
        )}
        ListEmptyComponent={
          <Text style={{ textAlign: 'center', marginTop: 20, color: '#666' }}>
            {scanning ? 'Cihazlar aranıyor...' : 'Henüz cihaz bulunamadı'}
          </Text>
        }
      />
    </View>
  );
};

export default BLEComponent;
```

### 6. Hata Yönetimi

```typescript
// Bluetooth durumunu kontrol et
const checkBluetoothState = async () => {
  const state = await manager.state();
  
  switch (state) {
    case 'Unknown':
      console.log('Bluetooth durumu bilinmiyor');
      break;
    case 'Resetting':
      console.log('Bluetooth sıfırlanıyor');
      break;
    case 'Unsupported':
      Alert.alert('Hata', 'Bu cihaz Bluetooth\'u desteklemiyor');
      break;
    case 'Unauthorized':
      Alert.alert('İzin Gerekli', 'Bluetooth izni verilmedi');
      break;
    case 'PoweredOff':
      Alert.alert('Bluetooth Kapalı', 'Lütfen Bluetooth\'u açın');
      break;
    case 'PoweredOn':
      console.log('Bluetooth hazır');
      break;
  }
};
```

### 7. package.json Bağımlılıkları

```json
{
  "dependencies": {
    "react-native": "^0.72.0",
    "react-native-permissions": "^3.9.0",
    "react-native-ble-plx": "^3.1.0"
  }
}
```

### 8. iOS Podfile Güncellemesi

```ruby
# ios/Podfile
platform :ios, '13.0'

target 'YourApp' do
  # ...
  
  permissions_path = '../node_modules/react-native-permissions/ios'
  pod 'Permission-BluetoothPeripheral', :path => "#{permissions_path}/BluetoothPeripheral"
  pod 'Permission-LocationWhenInUse', :path => "#{permissions_path}/LocationWhenInUse"
end
```

Sonra çalıştırın:
```bash
cd ios && pod install
```

## ⚠️ ÖNEMLİ NOTLAR

1. **Android 12+ için mutlaka yeni izinleri kullanın**
2. **iOS'ta Info.plist açıklamaları ZORUNLUDUR**
3. **Her platform için ayrı izin kontrolü yapın**
4. **Bluetooth durumunu sürekli kontrol edin**
5. **Kullanıcıya açıklayıcı mesajlar gösterin**
6. **Try-catch blokları kullanın**

## 🐛 Yaygın Hatalar ve Çözümleri

### Hata: "Bluetooth Unauthorized"
**Çözüm:** İzinleri kontrol edin ve kullanıcıdan isteyin

### Hata: "Bluetooth Powered Off"
**Çözüm:** Kullanıcıyı Bluetooth'u açmaya yönlendirin

### Hata: App Crash on Android 12+
**Çözüm:** BLUETOOTH_SCAN ve BLUETOOTH_CONNECT izinlerini ekleyin

### Hata: App Crash on iOS
**Çözüm:** Info.plist'e NSBluetoothAlwaysUsageDescription ekleyin
