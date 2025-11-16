import 'pid_type.dart';

/// PID Reader interface - OBD-II bağlantısı için
abstract class PIDReader {
  /// PID oku ve parse edilmiş değer döndür
  Future<double> readPID(PIDType pidType);

  /// Ham OBD komutu gönder
  Future<String> sendRawCommand(String command, String header);

  /// Bağlantı durumu
  Future<bool> isConnected();

  /// VIN oku
  Future<String> readVIN() async {
    try {
      return await sendRawCommand('09 02', '7DF');
    } catch (e) {
      return '';
    }
  }

  /// ECU adını oku
  Future<String> readECUName() async {
    try {
      return await sendRawCommand('09 0A', '7DF');
    } catch (e) {
      return '';
    }
  }
}

/// Mock PID Reader - Test için
class MockPIDReader implements PIDReader {
  final Map<PIDType, double> _mockData = {};

  MockPIDReader() {
    // Varsayılan değerler
    _mockData[PIDType.engineRpm] = 2000.0;
    _mockData[PIDType.vehicleSpeed] = 60.0;
    _mockData[PIDType.throttlePosition] = 45.0;
    _mockData[PIDType.engineLoad] = 35.0;
    _mockData[PIDType.coolantTemp] = 85.0;
    _mockData[PIDType.intakeTemp] = 25.0;
    _mockData[PIDType.fuelRate] = 8.5; // ✅ Gerçek yakıt tüketimi
    _mockData[PIDType.maf] = 15.0;
    _mockData[PIDType.batterySoc] = 75.0;
    _mockData[PIDType.batteryVoltage] = 360.0;
    _mockData[PIDType.batteryCurrent] = -20.0;
    _mockData[PIDType.batteryTemp] = 30.0;
    _mockData[PIDType.regenPower] = 15.0; // ✅ Regen gücü
    _mockData[PIDType.regenCurrent] = 40.0;
    _mockData[PIDType.motorTorque] = -50.0;
    _mockData[PIDType.regenEnergyTotal] = 125.5;
  }

  @override
  Future<double> readPID(PIDType pidType) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simüle gecikme
    return _mockData[pidType] ?? 0.0;
  }

  @override
  Future<String> sendRawCommand(String command, String header) async {
    await Future.delayed(const Duration(milliseconds: 50));

    // Mock responses
    if (command.contains('09 02')) {
      return '1HGCM82633A123456'; // Honda VIN
    } else if (command.contains('09 0A')) {
      return 'HONDA-ECU-2023';
    } else if (command.contains('22 015B')) {
      return '62 015B 64'; // Nissan yanıtı
    }

    return 'NO DATA';
  }

  @override
  Future<bool> isConnected() async {
    return true;
  }

  /// Test için mock değer ayarla
  void setMockValue(PIDType pidType, double value) {
    _mockData[pidType] = value;
  }
}
