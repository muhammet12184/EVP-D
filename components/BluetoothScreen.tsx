import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  FlatList,
  StyleSheet,
  ActivityIndicator,
  Alert,
  Platform,
} from 'react-native';
import { Device } from 'react-native-ble-plx';
import { useBluetooth } from '../hooks/useBluetooth';

const BluetoothScreen: React.FC = () => {
  const {
    devices,
    isScanning,
    isConnected,
    connectedDevice,
    error,
    startScan,
    stopScan,
    connectToDevice,
    disconnectDevice,
    clearDevices,
  } = useBluetooth();

  const handleScanPress = async () => {
    if (isScanning) {
      await stopScan();
    } else {
      clearDevices();
      await startScan();
    }
  };

  const handleDevicePress = async (device: Device) => {
    if (isConnected && connectedDevice?.id === device.id) {
      Alert.alert(
        'Bağlantıyı Kes',
        'Bu cihazdan bağlantıyı kesmek istediğinize emin misiniz?',
        [
          { text: 'İptal', style: 'cancel' },
          {
            text: 'Kes',
            style: 'destructive',
            onPress: async () => {
              await disconnectDevice();
            },
          },
        ]
      );
    } else {
      Alert.alert(
        'Cihaza Bağlan',
        `${device.name || device.id} cihazına bağlanmak istediğinize emin misiniz?`,
        [
          { text: 'İptal', style: 'cancel' },
          {
            text: 'Bağlan',
            onPress: async () => {
              await connectToDevice(device.id);
            },
          },
        ]
      );
    }
  };

  const renderDevice = ({ item }: { item: Device }) => {
    const isCurrentDevice = isConnected && connectedDevice?.id === item.id;
    
    return (
      <TouchableOpacity
        style={[styles.deviceItem, isCurrentDevice && styles.deviceItemConnected]}
        onPress={() => handleDevicePress(item)}
      >
        <View style={styles.deviceInfo}>
          <Text style={styles.deviceName}>
            {item.name || 'İsimsiz Cihaz'}
          </Text>
          <Text style={styles.deviceId}>{item.id}</Text>
          {item.rssi && (
            <Text style={styles.deviceRssi}>
              Sinyal: {item.rssi} dBm
            </Text>
          )}
        </View>
        {isCurrentDevice && (
          <View style={styles.connectedBadge}>
            <Text style={styles.connectedText}>Bağlı</Text>
          </View>
        )}
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Bluetooth Cihazları</Text>
      </View>

      {error && (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>{error}</Text>
        </View>
      )}

      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[styles.scanButton, isScanning && styles.scanButtonActive]}
          onPress={handleScanPress}
          disabled={isConnected}
        >
          {isScanning ? (
            <View style={styles.buttonContent}>
              <ActivityIndicator size="small" color="#fff" />
              <Text style={styles.scanButtonText}>Taranıyor...</Text>
            </View>
          ) : (
            <Text style={styles.scanButtonText}>Tara</Text>
          )}
        </TouchableOpacity>

        {isScanning && (
          <TouchableOpacity
            style={styles.stopButton}
            onPress={stopScan}
          >
            <Text style={styles.stopButtonText}>Durdur</Text>
          </TouchableOpacity>
        )}

        {isConnected && (
          <TouchableOpacity
            style={styles.disconnectButton}
            onPress={disconnectDevice}
          >
            <Text style={styles.disconnectButtonText}>Bağlantıyı Kes</Text>
          </TouchableOpacity>
        )}
      </View>

      {isConnected && connectedDevice && (
        <View style={styles.connectedContainer}>
          <Text style={styles.connectedTitle}>Bağlı Cihaz:</Text>
          <Text style={styles.connectedDeviceName}>
            {connectedDevice.name || connectedDevice.id}
          </Text>
        </View>
      )}

      <FlatList
        data={devices}
        renderItem={renderDevice}
        keyExtractor={(item) => item.id}
        style={styles.deviceList}
        contentContainerStyle={styles.deviceListContent}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyText}>
              {isScanning
                ? 'Cihazlar aranıyor...'
                : 'Henüz cihaz bulunamadı. "Tara" butonuna basın.'}
            </Text>
          </View>
        }
      />
    </View>
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
    paddingTop: Platform.OS === 'ios' ? 50 : 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
  },
  errorContainer: {
    backgroundColor: '#ffebee',
    padding: 15,
    margin: 15,
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#f44336',
  },
  errorText: {
    color: '#c62828',
    fontSize: 14,
  },
  buttonContainer: {
    flexDirection: 'row',
    padding: 15,
    gap: 10,
  },
  scanButton: {
    flex: 1,
    backgroundColor: '#2196F3',
    padding: 15,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
  },
  scanButtonActive: {
    backgroundColor: '#1976D2',
  },
  buttonContent: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  scanButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  stopButton: {
    backgroundColor: '#FF9800',
    padding: 15,
    borderRadius: 8,
    paddingHorizontal: 20,
  },
  stopButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  disconnectButton: {
    backgroundColor: '#f44336',
    padding: 15,
    borderRadius: 8,
    paddingHorizontal: 20,
  },
  disconnectButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  connectedContainer: {
    backgroundColor: '#e8f5e9',
    padding: 15,
    margin: 15,
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#4CAF50',
  },
  connectedTitle: {
    fontSize: 14,
    color: '#2e7d32',
    fontWeight: 'bold',
    marginBottom: 5,
  },
  connectedDeviceName: {
    fontSize: 16,
    color: '#1b5e20',
    fontWeight: '600',
  },
  deviceList: {
    flex: 1,
  },
  deviceListContent: {
    padding: 15,
  },
  deviceItem: {
    backgroundColor: '#fff',
    padding: 15,
    borderRadius: 8,
    marginBottom: 10,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  deviceItemConnected: {
    backgroundColor: '#e8f5e9',
    borderWidth: 2,
    borderColor: '#4CAF50',
  },
  deviceInfo: {
    flex: 1,
  },
  deviceName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 5,
  },
  deviceId: {
    fontSize: 12,
    color: '#666',
    marginBottom: 3,
  },
  deviceRssi: {
    fontSize: 12,
    color: '#999',
  },
  connectedBadge: {
    backgroundColor: '#4CAF50',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 12,
  },
  connectedText: {
    color: '#fff',
    fontSize: 12,
    fontWeight: 'bold',
  },
  emptyContainer: {
    padding: 40,
    alignItems: 'center',
  },
  emptyText: {
    fontSize: 16,
    color: '#999',
    textAlign: 'center',
  },
});

export default BluetoothScreen;
