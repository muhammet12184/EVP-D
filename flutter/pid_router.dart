import 'pid_reader.dart';
import 'pid_type.dart';

/// PIDRouter - Araç marka tespiti ve PID yönlendirme
class PIDRouter {
  final PIDReader pidReader;

  VehicleBrand? _detectedBrand;
  String? _detectedModel;
  int _detectionTimestamp = 0;

  PIDRouter(this.pidReader);

  /// ✅ UI için public properties
  VehicleBrand? get detectedBrand => _detectedBrand;
  String? get detectedModel => _detectedModel;
  int get detectionTimestamp => _detectionTimestamp;

  /// Araç tespiti yap
  Future<VehicleDetectionResult> detectVehicle() async {
    final detectionMethods = <DetectionMethod>[];

    // Method 1: VIN okuma
    try {
      final vin = await pidReader.readVIN();
      if (vin.isNotEmpty && vin.length >= 17) {
        final brandFromVIN = VehicleBrand.fromVIN(vin);
        if (brandFromVIN != VehicleBrand.unknown) {
          detectionMethods.add(DetectionMethod.vin(
            vin: vin,
            brand: brandFromVIN,
            confidence: 100,
          ));
          _detectedBrand = brandFromVIN;
          _detectedModel = _extractModelFromVIN(vin);
        }
      }
    } catch (e) {
      // VIN okuma başarısız
    }

    // Method 2: ECU name
    try {
      final ecuName = await pidReader.readECUName();
      if (ecuName.isNotEmpty) {
        final brandFromECU = VehicleBrand.fromName(ecuName);
        if (brandFromECU != VehicleBrand.unknown) {
          detectionMethods.add(DetectionMethod.ecu(
            ecuName: ecuName,
            brand: brandFromECU,
            confidence: 80,
          ));
          _detectedBrand ??= brandFromECU;
        }
      }
    } catch (e) {
      // ECU okuma başarısız
    }

    // Method 3: PID test
    if (_detectedBrand == null) {
      _detectedBrand = await _detectByPIDResponse();
      if (_detectedBrand != null &&
          _detectedBrand != VehicleBrand.unknown) {
        detectionMethods.add(DetectionMethod.pidTest(
          testResult: _detectedBrand!.displayName,
          brand: _detectedBrand!,
          confidence: 60,
        ));
      }
    }

    _detectionTimestamp = DateTime.now().millisecondsSinceEpoch;

    return VehicleDetectionResult(
      brand: _detectedBrand ?? VehicleBrand.unknown,
      model: _detectedModel,
      detectionMethods: detectionMethods,
      confidence:
          detectionMethods.isEmpty ? 0 : detectionMethods.map((m) => m.confidence).reduce((a, b) => a > b ? a : b),
      timestamp: _detectionTimestamp,
    );
  }

  /// PID test ile marka tespit
  Future<VehicleBrand> _detectByPIDResponse() async {
    // Test Nissan
    if (await _testPID('22 015B', '7E4')) return VehicleBrand.nissan;
    // Test Hyundai/Kia
    if (await _testPID('22 0170', '7E4')) return VehicleBrand.hyundai;
    // Test BMW
    if (await _testPID('22 2A38', '7E4')) return VehicleBrand.bmw;
    // Test Tesla
    if (await _testPID('22 1187', '7E4')) return VehicleBrand.tesla;
    // Test TOGG
    if (await _testPID('22 2101', '7E4')) return VehicleBrand.togg;

    return VehicleBrand.unknown;
  }

  Future<bool> _testPID(String pid, String header) async {
    try {
      final response = await pidReader.sendRawCommand(pid, header);
      return response.isNotEmpty &&
          !response.contains('NO DATA') &&
          !response.contains('ERROR');
    } catch (e) {
      return false;
    }
  }

  String _extractModelFromVIN(String vin) {
    if (vin.length < 9) return 'Unknown';
    return vin.substring(3, 9);
  }

  /// PID konfigürasyonu al
  VehiclePIDConfig getVehiclePIDConfig() {
    final brand = _detectedBrand ?? VehicleBrand.unknown;

    return VehiclePIDConfig(
      brand: brand,
      header: _getHeaderForBrand(brand),
      supportedPIDs: _getSupportedPIDsForBrand(brand),
      updateInterval: _getUpdateIntervalForBrand(brand),
    );
  }

  String _getHeaderForBrand(VehicleBrand brand) {
    return brand == VehicleBrand.honda ? '7E2' : '7E4';
  }

  List<PIDType> _getSupportedPIDsForBrand(VehicleBrand brand) {
    final common = [
      PIDType.batterySoc,
      PIDType.batteryVoltage,
      PIDType.batteryCurrent,
      PIDType.batteryTemp,
    ];

    final regenPID = _getRegenPIDForBrand(brand);
    return [...common, regenPID];
  }

  PIDType _getRegenPIDForBrand(VehicleBrand brand) {
    switch (brand) {
      case VehicleBrand.nissan:
      case VehicleBrand.renault:
        return PIDType.regenNissan;
      case VehicleBrand.hyundai:
      case VehicleBrand.kia:
        return PIDType.regenHyundai;
      case VehicleBrand.bmw:
      case VehicleBrand.mini:
        return PIDType.regenBmw;
      case VehicleBrand.tesla:
        return PIDType.regenTesla;
      default:
        return PIDType.regenPower;
    }
  }

  int _getUpdateIntervalForBrand(VehicleBrand brand) {
    switch (brand) {
      case VehicleBrand.tesla:
        return 100; // Tesla hızlı polling destekler
      case VehicleBrand.bmw:
        return 150;
      default:
        return 200;
    }
  }
}

/// Araç markaları enum
enum VehicleBrand {
  nissan,
  renault,
  hyundai,
  kia,
  bmw,
  mini,
  tesla,
  mercedes,
  audi,
  volkswagen,
  porsche,
  volvo,
  toyota,
  honda,
  byd,
  mg,
  togg,
  psa,
  ford,
  gm,
  stellantis,
  unknown;

  String get displayName {
    switch (this) {
      case VehicleBrand.nissan:
        return 'Nissan';
      case VehicleBrand.renault:
        return 'Renault';
      case VehicleBrand.hyundai:
        return 'Hyundai';
      case VehicleBrand.kia:
        return 'Kia';
      case VehicleBrand.bmw:
        return 'BMW';
      case VehicleBrand.mini:
        return 'Mini';
      case VehicleBrand.tesla:
        return 'Tesla';
      case VehicleBrand.mercedes:
        return 'Mercedes-Benz';
      case VehicleBrand.audi:
        return 'Audi';
      case VehicleBrand.volkswagen:
        return 'Volkswagen';
      case VehicleBrand.porsche:
        return 'Porsche';
      case VehicleBrand.volvo:
        return 'Volvo';
      case VehicleBrand.toyota:
        return 'Toyota';
      case VehicleBrand.honda:
        return 'Honda';
      case VehicleBrand.byd:
        return 'BYD';
      case VehicleBrand.mg:
        return 'MG Motor';
      case VehicleBrand.togg:
        return 'TOGG';
      case VehicleBrand.psa:
        return 'PSA Group';
      case VehicleBrand.ford:
        return 'Ford';
      case VehicleBrand.gm:
        return 'General Motors';
      case VehicleBrand.stellantis:
        return 'Stellantis';
      case VehicleBrand.unknown:
        return 'Unknown';
    }
  }

  /// VIN'den marka tespit
  static VehicleBrand fromVIN(String vin) {
    if (vin.length < 3) return VehicleBrand.unknown;

    final wmi = vin.substring(0, 3).toUpperCase();

    if (wmi.startsWith('JN')) return VehicleBrand.nissan;
    if (wmi.startsWith('VF1')) return VehicleBrand.renault;
    if (wmi.startsWith('KM') || wmi.startsWith('MAL')) return VehicleBrand.hyundai;
    if (wmi.startsWith('KNA') || wmi.startsWith('KND')) return VehicleBrand.kia;
    if (wmi.startsWith('WBA') || wmi.startsWith('WBS')) return VehicleBrand.bmw;
    if (wmi.startsWith('WMW')) return VehicleBrand.mini;
    if (wmi.startsWith('5YJ') || wmi.startsWith('7SA')) return VehicleBrand.tesla;
    if (wmi.startsWith('WDD') || wmi.startsWith('WDB')) return VehicleBrand.mercedes;
    if (wmi.startsWith('WAU')) return VehicleBrand.audi;
    if (wmi.startsWith('WVW') || wmi.startsWith('3VW')) return VehicleBrand.volkswagen;
    if (wmi.startsWith('WP0')) return VehicleBrand.porsche;
    if (wmi.startsWith('YV1')) return VehicleBrand.volvo;
    if (wmi.startsWith('JT') || wmi.startsWith('5T')) return VehicleBrand.toyota;
    if (wmi.startsWith('JHM') || wmi.startsWith('1HG')) return VehicleBrand.honda;
    if (wmi.startsWith('LGB')) return VehicleBrand.byd;
    if (wmi.startsWith('LSV')) return VehicleBrand.mg;
    if (wmi.startsWith('NMT')) return VehicleBrand.togg;

    return VehicleBrand.unknown;
  }

  /// İsimden marka tespit
  static VehicleBrand fromName(String name) {
    final upperName = name.toUpperCase();

    if (upperName.contains('NISSAN')) return VehicleBrand.nissan;
    if (upperName.contains('RENAULT')) return VehicleBrand.renault;
    if (upperName.contains('HYUNDAI')) return VehicleBrand.hyundai;
    if (upperName.contains('KIA')) return VehicleBrand.kia;
    if (upperName.contains('BMW')) return VehicleBrand.bmw;
    if (upperName.contains('MINI')) return VehicleBrand.mini;
    if (upperName.contains('TESLA')) return VehicleBrand.tesla;
    if (upperName.contains('MERCEDES')) return VehicleBrand.mercedes;
    if (upperName.contains('AUDI')) return VehicleBrand.audi;
    if (upperName.contains('VOLKSWAGEN') || upperName.contains('VW')) return VehicleBrand.volkswagen;
    if (upperName.contains('PORSCHE')) return VehicleBrand.porsche;
    if (upperName.contains('VOLVO')) return VehicleBrand.volvo;
    if (upperName.contains('TOYOTA')) return VehicleBrand.toyota;
    if (upperName.contains('HONDA')) return VehicleBrand.honda;
    if (upperName.contains('BYD')) return VehicleBrand.byd;
    if (upperName.contains('MG')) return VehicleBrand.mg;
    if (upperName.contains('TOGG')) return VehicleBrand.togg;

    return VehicleBrand.unknown;
  }
}

/// Tespit sonucu
class VehicleDetectionResult {
  final VehicleBrand brand;
  final String? model;
  final List<DetectionMethod> detectionMethods;
  final int confidence;
  final int timestamp;

  VehicleDetectionResult({
    required this.brand,
    this.model,
    required this.detectionMethods,
    required this.confidence,
    required this.timestamp,
  });
}

/// Tespit yöntemi
class DetectionMethod {
  final String source;
  final VehicleBrand brand;
  final int confidence;
  final String? data;

  DetectionMethod._({
    required this.source,
    required this.brand,
    required this.confidence,
    this.data,
  });

  factory DetectionMethod.vin({
    required String vin,
    required VehicleBrand brand,
    required int confidence,
  }) {
    return DetectionMethod._(
      source: 'VIN',
      brand: brand,
      confidence: confidence,
      data: vin,
    );
  }

  factory DetectionMethod.ecu({
    required String ecuName,
    required VehicleBrand brand,
    required int confidence,
  }) {
    return DetectionMethod._(
      source: 'ECU',
      brand: brand,
      confidence: confidence,
      data: ecuName,
    );
  }

  factory DetectionMethod.pidTest({
    required String testResult,
    required VehicleBrand brand,
    required int confidence,
  }) {
    return DetectionMethod._(
      source: 'PID Test',
      brand: brand,
      confidence: confidence,
      data: testResult,
    );
  }
}

/// PID konfigürasyonu
class VehiclePIDConfig {
  final VehicleBrand brand;
  final String header;
  final List<PIDType> supportedPIDs;
  final int updateInterval;

  VehiclePIDConfig({
    required this.brand,
    required this.header,
    required this.supportedPIDs,
    required this.updateInterval,
  });
}
