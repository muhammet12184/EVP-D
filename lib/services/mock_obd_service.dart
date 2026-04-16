import 'dart:async';
import 'dart:math';
import '../models/sensor_data.dart';

class MockOBDService {
  final Random _random = Random();
  Timer? _updateTimer;
  final StreamController<Map<String, SensorData>> _sensorController =
      StreamController<Map<String, SensorData>>.broadcast();
  final StreamController<BatteryData> _batteryController =
      StreamController<BatteryData>.broadcast();

  Stream<Map<String, SensorData>> get sensorStream => _sensorController.stream;
  Stream<BatteryData> get batteryStream => _batteryController.stream;

  Map<String, SensorData> _currentSensors = {};
  BatteryData? _currentBattery;
  bool _isRunning = false;

  // Simulated base values
  double _baseRpm = 850;
  double _baseSpeed = 0;
  double _baseThrottle = 0;
  double _baseCoolantTemp = 88;
  double _baseIntakeTemp = 29;

  MockOBDService() {
    _initializeSensors();
  }

  void _initializeSensors() {
    final defs = <String, SensorData>{
      'speed': SensorData(id: 'speed', name: 'HIZ', unit: 'km/h', minValue: 0, maxValue: 260, pid: '010D'),
      'rpm': SensorData(id: 'rpm', name: 'RPM', unit: 'rpm', minValue: 0, maxValue: 8000, pid: '010C'),
      'throttle': SensorData(id: 'throttle', name: 'GAZ', unit: '%', minValue: 0, maxValue: 100, pid: '0111'),
      'hp': SensorData(id: 'hp', name: 'HP', unit: 'hp', minValue: 0, maxValue: 300, pid: ''),
      'coolant_temp': SensorData(id: 'coolant_temp', name: 'SU SIC.', unit: '\u00b0C', minValue: -40, maxValue: 215, pid: '0105'),
      'intake_temp': SensorData(id: 'intake_temp', name: 'EMME SIC.', unit: '\u00b0C', minValue: -40, maxValue: 215, pid: '010F'),
      'manifold_pressure': SensorData(id: 'manifold_pressure', name: 'MAN.BAS.', unit: 'kPa', minValue: 0, maxValue: 255, pid: '010B'),
      'fuel_pressure': SensorData(id: 'fuel_pressure', name: 'BASINC', unit: 'kPa', minValue: 0, maxValue: 765, pid: '010A'),
      'boost': SensorData(id: 'boost', name: 'BOOST', unit: 'bar', minValue: -1, maxValue: 3, pid: ''),
      'voltage': SensorData(id: 'voltage', name: 'VOLT', unit: 'V', minValue: 0, maxValue: 16, pid: '0142'),
      'torque': SensorData(id: 'torque', name: 'TORK', unit: 'Nm', minValue: 0, maxValue: 500, pid: ''),
      'oil_temp': SensorData(id: 'oil_temp', name: 'YAG SIC.', unit: '\u00b0C', minValue: -40, maxValue: 210, pid: '015C'),
      'oil_pressure': SensorData(id: 'oil_pressure', name: 'YAG BAS.', unit: 'bar', minValue: 0, maxValue: 10, pid: ''),
      'exhaust_temp': SensorData(id: 'exhaust_temp', name: 'EGZOZ SIC.', unit: '\u00b0C', minValue: 0, maxValue: 900, pid: '0178'),
      'maf': SensorData(id: 'maf', name: 'MAF', unit: 'g/s', minValue: 0, maxValue: 655, pid: '0110'),
      'stft_bank1': SensorData(id: 'stft_bank1', name: 'STFT Banka 1', unit: '%', minValue: -100, maxValue: 99.2, pid: '0106'),
      'ltft_bank1': SensorData(id: 'ltft_bank1', name: 'LTFT Banka 1', unit: '%', minValue: -100, maxValue: 99.2, pid: '0107'),
      'stft_bank2': SensorData(id: 'stft_bank2', name: 'STFT Banka 2', unit: '%', minValue: -100, maxValue: 99.2, pid: '0108'),
      'ltft_bank2': SensorData(id: 'ltft_bank2', name: 'LTFT Banka 2', unit: '%', minValue: -100, maxValue: 99.2, pid: '0109'),
      'fuel_level': SensorData(id: 'fuel_level', name: 'Yakit Deposu', unit: '%', minValue: 0, maxValue: 100, pid: '012F'),
      'engine_load': SensorData(id: 'engine_load', name: 'Motor Yuku', unit: '%', minValue: 0, maxValue: 100, pid: '0104'),
      'timing_advance': SensorData(id: 'timing_advance', name: 'Atesleme Avansi', unit: '\u00b0', minValue: -64, maxValue: 63.5, pid: '010E'),
      'fuel_system': SensorData(id: 'fuel_system', name: 'Yakit Sistemi', unit: 'bit', minValue: 0, maxValue: 1, pid: '0103'),
      'engine_runtime': SensorData(id: 'engine_runtime', name: 'Motor Calisma', unit: 's', minValue: 0, maxValue: 65535, pid: '011F'),
      'catalyst_temp_b1s1': SensorData(id: 'catalyst_temp_b1s1', name: 'Katalizor B1S1', unit: '\u00b0C', minValue: -40, maxValue: 6513.5, pid: '013C'),
      'o2_sensor_map': SensorData(id: 'o2_sensor_map', name: 'O2 Sensor Haritasi', unit: 'bit', minValue: 0, maxValue: 1, pid: '0113'),
      'obd_standard': SensorData(id: 'obd_standard', name: 'OBD Standart', unit: 'enum', minValue: 0, maxValue: 255, pid: '011C'),
      'intake_manifold_pressure': SensorData(id: 'intake_manifold_pressure', name: 'Emme Manifold Basinci', unit: 'kPa', minValue: 0, maxValue: 255, pid: '010B'),
      'barometric_pressure': SensorData(id: 'barometric_pressure', name: 'Barometrik Basinc', unit: 'kPa', minValue: 0, maxValue: 255, pid: '0133'),
      'afr': SensorData(id: 'afr', name: 'AFR', unit: '\u03bb', minValue: 0, maxValue: 2, pid: '0124'),
    };
    _currentSensors = defs;
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _updateValues();
    });
  }

  void stop() {
    _isRunning = false;
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  void _updateValues() {
    // Simulate driving behavior
    _baseThrottle = (_baseThrottle + _random.nextDouble() * 6 - 3).clamp(0, 100);
    _baseRpm = (850 + _baseThrottle * 40 + _random.nextDouble() * 100 - 50).clamp(600, 6500);
    _baseSpeed = (_baseThrottle * 1.6 + _random.nextDouble() * 4 - 2).clamp(0, 220);
    _baseCoolantTemp = (_baseCoolantTemp + _random.nextDouble() * 0.4 - 0.15).clamp(75, 105);
    _baseIntakeTemp = (_baseIntakeTemp + _random.nextDouble() * 0.3 - 0.15).clamp(15, 55);

    double hp = (_baseRpm * _baseThrottle / 100 * 0.05).clamp(0, 250);
    double manifoldPressure = (30 + _baseThrottle * 0.7 + _random.nextDouble() * 3).clamp(20, 101);
    double fuelPressure = (35 + _baseThrottle * 0.1 + _random.nextDouble() * 2).clamp(30, 60);
    double boost = ((_baseThrottle > 50) ? (_baseThrottle - 50) / 50 * 1.2 : 0) + _random.nextDouble() * 0.05;
    double voltage = (13.6 + _random.nextDouble() * 0.6 - 0.3).clamp(12.0, 14.8);
    double torque = (hp * 7120 / (_baseRpm > 100 ? _baseRpm : 850)).clamp(0, 400);
    double mafVal = (_baseRpm * _baseThrottle / 100 * 0.08 + _random.nextDouble() * 2).clamp(0, 120);
    double fuelLevel = 71.0;
    double engineLoad = (_baseThrottle * 0.8 + _random.nextDouble() * 5).clamp(0, 100);
    double timingAdv = (12 + _baseThrottle * 0.15 + _random.nextDouble() * 2 - 1).clamp(-5, 40);
    double engineRuntime = DateTime.now().millisecondsSinceEpoch / 1000 % 65535;
    double barometric = (101.0 + _random.nextDouble() * 1 - 0.5).clamp(95, 106);
    double afrVal = (1.0 + _random.nextDouble() * 0.1 - 0.05).clamp(0.7, 1.3);

    // Active sensors (always have values)
    _currentSensors['speed'] = _currentSensors['speed']!.copyWith(value: _baseSpeed);
    _currentSensors['rpm'] = _currentSensors['rpm']!.copyWith(value: _baseRpm);
    _currentSensors['throttle'] = _currentSensors['throttle']!.copyWith(value: _baseThrottle);
    _currentSensors['hp'] = _currentSensors['hp']!.copyWith(value: hp);
    _currentSensors['coolant_temp'] = _currentSensors['coolant_temp']!.copyWith(value: _baseCoolantTemp);
    _currentSensors['intake_temp'] = _currentSensors['intake_temp']!.copyWith(value: _baseIntakeTemp);
    _currentSensors['manifold_pressure'] = _currentSensors['manifold_pressure']!.copyWith(value: manifoldPressure);
    _currentSensors['fuel_pressure'] = _currentSensors['fuel_pressure']!.copyWith(value: fuelPressure);
    _currentSensors['boost'] = _currentSensors['boost']!.copyWith(value: boost);
    _currentSensors['voltage'] = _currentSensors['voltage']!.copyWith(value: voltage);
    _currentSensors['torque'] = _currentSensors['torque']!.copyWith(value: torque);
    _currentSensors['maf'] = _currentSensors['maf']!.copyWith(value: mafVal);
    _currentSensors['fuel_level'] = _currentSensors['fuel_level']!.copyWith(value: fuelLevel);
    _currentSensors['engine_load'] = _currentSensors['engine_load']!.copyWith(value: engineLoad);
    _currentSensors['timing_advance'] = _currentSensors['timing_advance']!.copyWith(value: timingAdv);
    _currentSensors['engine_runtime'] = _currentSensors['engine_runtime']!.copyWith(value: engineRuntime);
    _currentSensors['barometric_pressure'] = _currentSensors['barometric_pressure']!.copyWith(value: barometric);
    _currentSensors['afr'] = _currentSensors['afr']!.copyWith(value: afrVal);
    _currentSensors['intake_manifold_pressure'] = _currentSensors['intake_manifold_pressure']!.copyWith(value: manifoldPressure);

    // Inactive sensors (no value - null)
    // oil_temp, oil_pressure, exhaust_temp, stft_bank1, ltft_bank1,
    // stft_bank2, ltft_bank2, fuel_system, catalyst_temp_b1s1,
    // o2_sensor_map, obd_standard remain null

    _sensorController.add(Map.from(_currentSensors));

    // Battery data
    _updateBatteryData();
  }

  void _updateBatteryData() {
    List<BatteryCell> cells = [];
    double baseV = 3.85;
    for (int i = 1; i <= 96; i++) {
      double v = baseV + (_random.nextDouble() * 0.04 - 0.02);
      cells.add(BatteryCell(cellNumber: i, voltage: v));
    }

    double minV = cells.map((c) => c.voltage).reduce(min);
    double maxV = cells.map((c) => c.voltage).reduce(max);
    double avgV = cells.map((c) => c.voltage).reduce((a, b) => a + b) / cells.length;
    double totalV = avgV * 96;
    double deltaV = (maxV - minV) * 1000;

    _currentBattery = BatteryData(
      totalVoltage: totalV,
      minVoltage: minV,
      avgVoltage: avgV,
      maxVoltage: maxV,
      deltaVoltage: deltaV,
      temperature: 36.0 + _random.nextDouble() * 1 - 0.5,
      balancing: 0,
      cellCount: 96,
      moduleCount: 8,
      cells: cells,
    );
    _batteryController.add(_currentBattery!);
  }

  Map<String, SensorData> get currentSensors => _currentSensors;
  BatteryData? get currentBattery => _currentBattery;

  /// Dashboard gauge sensors in display order
  List<String> get dashboardSensorIds => [
        'speed', 'rpm', 'throttle',
        'hp', 'coolant_temp', 'intake_temp', 'manifold_pressure',
        'fuel_pressure', 'boost', 'voltage', 'torque',
        'oil_temp', 'oil_pressure', 'exhaust_temp',
      ];

  void dispose() {
    stop();
    _sensorController.close();
    _batteryController.close();
  }
}
