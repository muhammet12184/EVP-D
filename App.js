import React, { useState, useEffect } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  FlatList,
  Alert,
  Platform,
  PermissionsAndroid,
  ActivityIndicator,
} from 'react-native';
import { BleManager } from 'react-native-ble-plx';

const App = () => {
  const [bleManager] = useState(new BleManager());
  const [devices, setDevices] = useState([]);
  const [scanning, setScanning] = useState(false);
  const [connectedDevice, setConnectedDevice] = useState(null);

  useEffect(() => {
    // Check Bluetooth state on mount
    const subscription = bleManager.onStateChange((state) => {
      if (state === 'PoweredOn') {
        console.log('Bluetooth is powered on');
      } else {
        console.log('Bluetooth state:', state);
      }
    }, true);

    return () => {
      subscription.remove();
      bleManager.destroy();
    };
  }, []);

  const requestPermissions = async () => {
    if (Platform.OS === 'android') {
      if (Platform.Version >= 31) {
        // Android 12+ (API 31+)
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.BLUETOOTH_SCAN,
          PermissionsAndroid.PERMISSIONS.BLUETOOTH_CONNECT,
          PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        ]);
        
        return (
          granted['android.permission.BLUETOOTH_SCAN'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.BLUETOOTH_CONNECT'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.ACCESS_FINE_LOCATION'] === PermissionsAndroid.RESULTS.GRANTED
        );
      } else {
        // Android 11 and below
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
          PermissionsAndroid.PERMISSIONS.BLUETOOTH,
          PermissionsAndroid.PERMISSIONS.BLUETOOTH_ADMIN,
        ]);
        
        return (
          granted['android.permission.ACCESS_FINE_LOCATION'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.BLUETOOTH'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.BLUETOOTH_ADMIN'] === PermissionsAndroid.RESULTS.GRANTED
        );
      }
    }
    return true; // iOS handles permissions via Info.plist
  };

  const scanForDevices = async () => {
    const hasPermissions = await requestPermissions();
    
    if (!hasPermissions) {
      Alert.alert(
        'İzinler Gerekli',
        'Bluetooth taraması için gerekli izinler verilmedi. Lütfen ayarlardan izinleri aktifleştirin.',
        [{ text: 'Tamam' }]
      );
      return;
    }

    // Check if Bluetooth is powered on
    const state = await bleManager.state();
    if (state !== 'PoweredOn') {
      Alert.alert(
        'Bluetooth Kapalı',
        'Lütfen Bluetooth\'u açın ve tekrar deneyin.',
        [{ text: 'Tamam' }]
      );
      return;
    }

    setScanning(true);
    setDevices([]);
    
    console.log('Bluetooth taraması başlatılıyor...');

    bleManager.startDeviceScan(null, null, (error, device) => {
      if (error) {
        console.error('Tarama hatası:', error);
        setScanning(false);
        Alert.alert('Hata', 'Bluetooth taraması sırasında bir hata oluştu: ' + error.message);
        return;
      }

      if (device) {
        console.log('Cihaz bulundu:', device.name || device.id);
        setDevices(prevDevices => {
          // Avoid duplicates
          if (prevDevices.find(d => d.id === device.id)) {
            return prevDevices;
          }
          return [...prevDevices, {
            id: device.id,
            name: device.name || 'İsimsiz Cihaz',
            rssi: device.rssi,
          }];
        });
      }
    });

    // Stop scanning after 10 seconds
    setTimeout(() => {
      bleManager.stopDeviceScan();
      setScanning(false);
      console.log('Tarama tamamlandı');
    }, 10000);
  };

  const connectToDevice = async (deviceId) => {
    try {
      console.log('Cihaza bağlanılıyor:', deviceId);
      
      const device = await bleManager.connectToDevice(deviceId);
      setConnectedDevice(device);
      
      await device.discoverAllServicesAndCharacteristics();
      
      Alert.alert(
        'Başarılı',
        `${device.name || 'Cihaz'} ile bağlantı kuruldu!`,
        [{ text: 'Tamam' }]
      );
      
      console.log('Cihaz bağlandı:', device.name);
    } catch (error) {
      console.error('Bağlantı hatası:', error);
      Alert.alert(
        'Bağlantı Hatası',
        'Cihaza bağlanırken bir hata oluştu: ' + error.message,
        [{ text: 'Tamam' }]
      );
    }
  };

  const disconnectDevice = async () => {
    if (connectedDevice) {
      try {
        await bleManager.cancelDeviceConnection(connectedDevice.id);
        setConnectedDevice(null);
        Alert.alert('Bağlantı Kesildi', 'Cihazla bağlantı kesildi.', [{ text: 'Tamam' }]);
      } catch (error) {
        console.error('Bağlantı kesme hatası:', error);
      }
    }
  };

  const renderDevice = ({ item }) => (
    <TouchableOpacity
      style={styles.deviceItem}
      onPress={() => connectToDevice(item.id)}>
      <View style={styles.deviceInfo}>
        <Text style={styles.deviceName}>{item.name}</Text>
        <Text style={styles.deviceId}>ID: {item.id}</Text>
        <Text style={styles.deviceRssi}>Sinyal Gücü: {item.rssi} dBm</Text>
      </View>
      <View style={styles.connectButton}>
        <Text style={styles.connectButtonText}>BAĞLAN</Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Bluetooth Cihaz Tarayıcı</Text>
      </View>

      {connectedDevice && (
        <View style={styles.connectedBanner}>
          <Text style={styles.connectedText}>
            Bağlı: {connectedDevice.name || 'Cihaz'}
          </Text>
          <TouchableOpacity onPress={disconnectDevice}>
            <Text style={styles.disconnectButton}>BAĞLANTIYI KES</Text>
          </TouchableOpacity>
        </View>
      )}

      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[styles.scanButton, scanning && styles.scanButtonDisabled]}
          onPress={scanForDevices}
          disabled={scanning}>
          {scanning ? (
            <View style={styles.scanningContainer}>
              <ActivityIndicator size="small" color="#fff" />
              <Text style={styles.scanButtonText}>  TARANIYOR...</Text>
            </View>
          ) : (
            <Text style={styles.scanButtonText}>🔵 TARA</Text>
          )}
        </TouchableOpacity>
      </View>

      <View style={styles.deviceListContainer}>
        <Text style={styles.deviceListTitle}>
          Bulunan Cihazlar ({devices.length})
        </Text>
        {devices.length === 0 && !scanning && (
          <View style={styles.emptyState}>
            <Text style={styles.emptyStateText}>
              Cihaz taraması için "TARA" butonuna basın
            </Text>
          </View>
        )}
        <FlatList
          data={devices}
          renderItem={renderDevice}
          keyExtractor={item => item.id}
          contentContainerStyle={styles.deviceList}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    backgroundColor: '#2196F3',
    padding: 20,
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
  },
  connectedBanner: {
    backgroundColor: '#4CAF50',
    padding: 15,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  connectedText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  disconnectButton: {
    color: '#fff',
    fontSize: 14,
    fontWeight: 'bold',
    textDecorationLine: 'underline',
  },
  buttonContainer: {
    padding: 20,
  },
  scanButton: {
    backgroundColor: '#2196F3',
    padding: 18,
    borderRadius: 10,
    alignItems: 'center',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  scanButtonDisabled: {
    backgroundColor: '#90CAF9',
  },
  scanButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  scanningContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  deviceListContainer: {
    flex: 1,
    padding: 20,
    paddingTop: 0,
  },
  deviceListTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
    color: '#333',
  },
  deviceList: {
    paddingBottom: 20,
  },
  deviceItem: {
    backgroundColor: '#fff',
    padding: 15,
    borderRadius: 10,
    marginBottom: 10,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.22,
    shadowRadius: 2.22,
  },
  deviceInfo: {
    flex: 1,
  },
  deviceName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 4,
  },
  deviceId: {
    fontSize: 12,
    color: '#666',
    marginBottom: 2,
  },
  deviceRssi: {
    fontSize: 12,
    color: '#999',
  },
  connectButton: {
    backgroundColor: '#4CAF50',
    paddingHorizontal: 15,
    paddingVertical: 8,
    borderRadius: 5,
  },
  connectButtonText: {
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 12,
  },
  emptyState: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 40,
  },
  emptyStateText: {
    fontSize: 16,
    color: '#999',
    textAlign: 'center',
  },
});

export default App;
