import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../core/config/app_config.dart';

/// OBD-II Service - Handles communication with OBD-II Bluetooth devices
class OBDService {
  static final OBDService _instance = OBDService._internal();
  factory OBDService() => _instance;
  OBDService._internal();

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _obdCharacteristic;
  bool _isConnected = false;
  
  final StreamController<Map<String, dynamic>> _dataController = 
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;
  bool get isConnected => _isConnected;

  /// Scan for available OBD-II devices
  Stream<BluetoothDevice> scanForDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    
    return FlutterBluePlus.scanResults.map((results) {
      return results
          .where((r) => r.device.name.contains('OBD') || 
                       r.device.name.contains('ELM327'))
          .map((r) => r.device)
          .toList();
    }).expand((devices) => devices);
  }

  /// Connect to OBD-II device
  Future<bool> connect(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      
      for (var service in services) {
        if (service.uuid.toString().contains(AppConfig.obdServiceUUID)) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().contains(AppConfig.obdCharacteristicUUID)) {
              _obdCharacteristic = characteristic;
              
              // Enable notifications
              await characteristic.setNotifyValue(true);
              
              // Listen to data
              characteristic.value.listen((value) {
                _parseOBDData(value);
              });
              
              _isConnected = true;
              
              // Initialize OBD-II
              await _initializeOBD();
              
              return true;
            }
          }
        }
      }
      
      return false;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  /// Disconnect from OBD-II device
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _obdCharacteristic = null;
      _isConnected = false;
    }
  }

  /// Initialize OBD-II communication
  Future<void> _initializeOBD() async {
    if (_obdCharacteristic == null) return;

    // Reset device
    await _sendCommand('ATZ');
    await Future.delayed(const Duration(seconds: 1));

    // Turn off echo
    await _sendCommand('ATE0');
    await Future.delayed(const Duration(milliseconds: 500));

    // Set protocol to auto
    await _sendCommand('ATSP0');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Send command to OBD-II device
  Future<void> _sendCommand(String command) async {
    if (_obdCharacteristic == null) return;

    try {
      final data = utf8.encode('$command\r');
      await _obdCharacteristic!.write(data);
    } catch (e) {
      print('Send command error: $e');
    }
  }

  /// Request specific PID (Parameter ID)
  Future<void> requestPID(String pid) async {
    await _sendCommand('01$pid');
  }

  /// Start continuous monitoring
  void startMonitoring() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!_isConnected) {
        timer.cancel();
        return;
      }

      // Request various PIDs
      await requestPID('0C'); // Engine RPM
      await Future.delayed(const Duration(milliseconds: 100));
      
      await requestPID('0D'); // Vehicle Speed
      await Future.delayed(const Duration(milliseconds: 100));
      
      await requestPID('05'); // Engine Coolant Temperature
      await Future.delayed(const Duration(milliseconds: 100));
      
      await requestPID('2F'); // Fuel Level
      await Future.delayed(const Duration(milliseconds: 100));
      
      await requestPID('04'); // Engine Load
      await Future.delayed(const Duration(milliseconds: 100));
      
      await requestPID('0F'); // Intake Air Temperature
    });
  }

  /// Parse OBD-II data
  void _parseOBDData(List<int> data) {
    try {
      final response = utf8.decode(data).trim();
      
      if (response.isEmpty || response.contains('NO DATA')) return;

      // Parse different PIDs
      final Map<String, dynamic> parsedData = {};

      // Engine RPM (PID 0C)
      if (response.startsWith('410C')) {
        final value = int.parse(response.substring(4, 8), radix: 16);
        parsedData['rpm'] = value / 4;
      }

      // Vehicle Speed (PID 0D)
      if (response.startsWith('410D')) {
        final value = int.parse(response.substring(4, 6), radix: 16);
        parsedData['speed'] = value;
      }

      // Engine Coolant Temperature (PID 05)
      if (response.startsWith('4105')) {
        final value = int.parse(response.substring(4, 6), radix: 16);
        parsedData['coolantTemp'] = value - 40;
      }

      // Fuel Level (PID 2F)
      if (response.startsWith('412F')) {
        final value = int.parse(response.substring(4, 6), radix: 16);
        parsedData['fuelLevel'] = (value * 100) / 255;
      }

      // Engine Load (PID 04)
      if (response.startsWith('4104')) {
        final value = int.parse(response.substring(4, 6), radix: 16);
        parsedData['engineLoad'] = (value * 100) / 255;
      }

      // Intake Air Temperature (PID 0F)
      if (response.startsWith('410F')) {
        final value = int.parse(response.substring(4, 6), radix: 16);
        parsedData['intakeTemp'] = value - 40;
      }

      if (parsedData.isNotEmpty) {
        parsedData['timestamp'] = DateTime.now().toIso8601String();
        _dataController.add(parsedData);
      }
    } catch (e) {
      print('Parse error: $e');
    }
  }

  /// Read diagnostic trouble codes (DTCs)
  Future<List<String>> readDTCs() async {
    // This would send command '03' to read stored DTCs
    // For now, return empty list
    return [];
  }

  /// Clear diagnostic trouble codes
  Future<void> clearDTCs() async {
    await _sendCommand('04');
  }

  /// Interpret DTC code in human language (Turkish)
  String interpretDTC(String dtcCode) {
    // Common DTC interpretations in Turkish
    final Map<String, String> dtcDescriptions = {
      'P0300': 'Rastgele ateşleme hatası tespit edildi',
      'P0171': 'Yakıt karışımı çok zayıf (Bank 1)',
      'P0420': 'Katalitik konvertör verimliliği düşük',
      'P0401': 'EGR akışı yetersiz',
      'P0128': 'Motor soğutma suyu sıcaklığı çok düşük',
      'P0442': 'Yakıt buharlaşma sistemi küçük kaçak',
      'P0455': 'Yakıt buharlaşma sistemi büyük kaçak',
      'P0135': 'Oksijen sensörü ısıtıcı devresi arızası',
    };

    return dtcDescriptions[dtcCode] ?? 
           'Bilinmeyen arıza kodu: $dtcCode';
  }

  /// Get AI-powered repair suggestion
  String getAIRepairSuggestion(String dtcCode) {
    // AI Mechanic feature - provides friendly explanation
    final Map<String, String> suggestions = {
      'P0300': 'Korkmayın! Bu genellikle bujilerin yaşlanmasından kaynaklanır. '
               'Buji değişimi ile çözülebilir. Tahmini maliyet: 500-1000 TL',
      'P0171': 'Hava/yakıt dengesi bozulmuş. Hava filtresi veya yakıt pompası '
               'kontrol edilmeli. Ciddi değil, ertelemeyin. Maliyet: 300-800 TL',
      'P0420': 'Katalitik konvertör eskimiş olabilir. Emisyon testinde sorun '
               'çıkarabilir. Kontrol ettirin. Maliyet: 2000-5000 TL',
      'P0401': 'EGR valfı temizlenmesi gerekiyor. Basit bir işlem. '
               'Servis randevusu alın. Maliyet: 400-700 TL',
    };

    return suggestions[dtcCode] ?? 
           'Bu kod için detaylı bilgi bulunmuyor. '
           'Bir serviste kontrol ettirmenizi öneririm.';
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _dataController.close();
  }
}
