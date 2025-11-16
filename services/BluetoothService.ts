import { Platform, PermissionsAndroid } from 'react-native';
import { BleManager, Device, State } from 'react-native-ble-plx';

class BluetoothService {
  private manager: BleManager;
  private scanSubscription: any = null;
  private isScanning: boolean = false;
  private discoveredDevices: Map<string, Device> = new Map();

  constructor() {
    this.manager = new BleManager();
    this.setupManager();
  }

  private setupManager() {
    // Bluetooth durumunu dinle
    this.manager.onStateChange((state: State) => {
      if (state === 'PoweredOn') {
        console.log('Bluetooth açık ve hazır');
      } else {
        console.log('Bluetooth durumu:', state);
      }
    });
  }

  // İzinleri kontrol et ve iste
  async requestPermissions(): Promise<boolean> {
    if (Platform.OS === 'android') {
      // Android 12+ için yeni izinler
      if (Platform.Version >= 31) {
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
        // Android 11 ve öncesi için eski izinler
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
          PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION,
        ]);

        return (
          granted['android.permission.ACCESS_FINE_LOCATION'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.ACCESS_COARSE_LOCATION'] === PermissionsAndroid.RESULTS.GRANTED
        );
      }
    }
    // iOS için izinler Info.plist'te tanımlanmalı
    return true;
  }

  // Bluetooth durumunu kontrol et
  async checkBluetoothState(): Promise<State> {
    return await this.manager.state();
  }

  // Bluetooth'u açık hale getir (sadece Android)
  async enableBluetooth(): Promise<void> {
    if (Platform.OS === 'android') {
      await this.manager.enable();
    }
  }

  // Cihazları tara
  async startScan(
    onDeviceFound: (device: Device) => void,
    onError?: (error: Error) => void
  ): Promise<void> {
    try {
      // İzinleri kontrol et
      const hasPermission = await this.requestPermissions();
      if (!hasPermission) {
        throw new Error('Bluetooth izinleri reddedildi');
      }

      // Bluetooth durumunu kontrol et
      const state = await this.checkBluetoothState();
      if (state !== 'PoweredOn') {
        if (Platform.OS === 'android') {
          await this.enableBluetooth();
          // Bluetooth'un açılmasını bekle
          await new Promise(resolve => setTimeout(resolve, 1000));
        } else {
          throw new Error('Bluetooth kapalı. Lütfen Bluetooth\'u açın.');
        }
      }

      // Önceki taramayı durdur
      if (this.isScanning) {
        await this.stopScan();
      }

      // Bulunan cihazları temizle
      this.discoveredDevices.clear();

      this.isScanning = true;

      // iOS ve Android için farklı tarama stratejileri
      if (Platform.OS === 'ios') {
        // iOS için tüm servisleri tara
        this.scanSubscription = this.manager.startDeviceScan(
          null, // Tüm servisler
          { allowDuplicates: false },
          (error, device) => {
            if (error) {
              this.isScanning = false;
              if (onError) {
                onError(error);
              }
              return;
            }

            if (device && device.name) {
              // Aynı cihazı tekrar eklemeyi önle
              if (!this.discoveredDevices.has(device.id)) {
                this.discoveredDevices.set(device.id, device);
                onDeviceFound(device);
              }
            }
          }
        );
      } else {
        // Android için tüm cihazları tara
        this.scanSubscription = this.manager.startDeviceScan(
          null, // Tüm servisler
          { 
            allowDuplicates: false,
            scanMode: 2, // SCAN_MODE_LOW_LATENCY
          },
          (error, device) => {
            if (error) {
              this.isScanning = false;
              if (onError) {
                onError(error);
              }
              return;
            }

            if (device) {
              // Android'de isim olmayabilir, ID'ye göre kontrol et
              if (!this.discoveredDevices.has(device.id)) {
                this.discoveredDevices.set(device.id, device);
                onDeviceFound(device);
              }
            }
          }
        );
      }

      // 10 saniye sonra otomatik durdur (isteğe bağlı)
      setTimeout(() => {
        if (this.isScanning) {
          this.stopScan();
        }
      }, 10000);

    } catch (error: any) {
      this.isScanning = false;
      if (onError) {
        onError(error);
      } else {
        throw error;
      }
    }
  }

  // Taramayı durdur
  async stopScan(): Promise<void> {
    if (this.scanSubscription) {
      this.scanSubscription.remove();
      this.scanSubscription = null;
    }
    this.manager.stopDeviceScan();
    this.isScanning = false;
  }

  // Cihaza bağlan
  async connectToDevice(deviceId: string): Promise<Device> {
    try {
      const device = await this.manager.connectToDevice(deviceId);
      await device.discoverAllServicesAndCharacteristics();
      return device;
    } catch (error: any) {
      throw new Error(`Bağlantı hatası: ${error.message}`);
    }
  }

  // Cihazdan bağlantıyı kes
  async disconnectDevice(deviceId: string): Promise<void> {
    try {
      await this.manager.cancelDeviceConnection(deviceId);
    } catch (error: any) {
      console.error('Bağlantı kesme hatası:', error);
    }
  }

  // Bağlı cihazları listele
  async getConnectedDevices(): Promise<Device[]> {
    try {
      return await this.manager.connectedDevices([]);
    } catch (error: any) {
      console.error('Bağlı cihazları alma hatası:', error);
      return [];
    }
  }

  // Servisi temizle
  destroy(): void {
    if (this.scanSubscription) {
      this.scanSubscription.remove();
    }
    this.manager.destroy();
  }
}

export default new BluetoothService();
