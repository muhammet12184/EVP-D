import { useState, useEffect, useCallback } from 'react';
import { Device } from 'react-native-ble-plx';
import BluetoothService from '../services/BluetoothService';

interface UseBluetoothReturn {
  devices: Device[];
  isScanning: boolean;
  isConnected: boolean;
  connectedDevice: Device | null;
  error: string | null;
  startScan: () => Promise<void>;
  stopScan: () => Promise<void>;
  connectToDevice: (deviceId: string) => Promise<void>;
  disconnectDevice: () => Promise<void>;
  clearDevices: () => void;
}

export const useBluetooth = (): UseBluetoothReturn => {
  const [devices, setDevices] = useState<Device[]>([]);
  const [isScanning, setIsScanning] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [connectedDevice, setConnectedDevice] = useState<Device | null>(null);
  const [error, setError] = useState<string | null>(null);

  // Taramayı başlat
  const startScan = useCallback(async () => {
    try {
      setError(null);
      setIsScanning(true);
      setDevices([]);

      await BluetoothService.startScan(
        (device: Device) => {
          setDevices(prevDevices => {
            // Aynı cihazı tekrar eklemeyi önle
            const exists = prevDevices.find(d => d.id === device.id);
            if (!exists) {
              return [...prevDevices, device];
            }
            return prevDevices;
          });
        },
        (err: Error) => {
          setError(err.message);
          setIsScanning(false);
        }
      );
    } catch (err: any) {
      setError(err.message);
      setIsScanning(false);
    }
  }, []);

  // Taramayı durdur
  const stopScan = useCallback(async () => {
    try {
      await BluetoothService.stopScan();
      setIsScanning(false);
    } catch (err: any) {
      setError(err.message);
    }
  }, []);

  // Cihaza bağlan
  const connectToDevice = useCallback(async (deviceId: string) => {
    try {
      setError(null);
      const device = await BluetoothService.connectToDevice(deviceId);
      setConnectedDevice(device);
      setIsConnected(true);
      
      // Taramayı durdur
      await stopScan();
    } catch (err: any) {
      setError(err.message);
      setIsConnected(false);
      setConnectedDevice(null);
    }
  }, [stopScan]);

  // Cihazdan bağlantıyı kes
  const disconnectDevice = useCallback(async () => {
    try {
      if (connectedDevice) {
        await BluetoothService.disconnectDevice(connectedDevice.id);
      }
      setIsConnected(false);
      setConnectedDevice(null);
      setError(null);
    } catch (err: any) {
      setError(err.message);
    }
  }, [connectedDevice]);

  // Cihaz listesini temizle
  const clearDevices = useCallback(() => {
    setDevices([]);
  }, []);

  // Component unmount olduğunda temizlik yap
  useEffect(() => {
    return () => {
      BluetoothService.stopScan();
    };
  }, []);

  return {
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
  };
};
