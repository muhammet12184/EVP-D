import 'dart:async';
import 'pid_reader.dart';
import 'pid_type.dart';

/// Motor/ICE (Internal Combustion Engine) analyzer
/// Gerçek zamanlı yakıt tüketimi desteği ile
class MotorAnalyzer {
  final PIDReader pidReader;

  MotorAnalyzer(this.pidReader);

  /// Motor verileri
  Stream<MotorData> monitorMotorData() async* {
    while (true) {
      final rpm = await pidReader.readPID(PIDType.engineRpm);
      final speed = await pidReader.readPID(PIDType.vehicleSpeed);
      final throttle = await pidReader.readPID(PIDType.throttlePosition);
      final load = await pidReader.readPID(PIDType.engineLoad);
      final coolant = await pidReader.readPID(PIDType.coolantTemp);
      final intake = await pidReader.readPID(PIDType.intakeTemp);

      // ✅ GERÇEK YAKIT TÜKETİMİ (artık 0.0 placeholder değil!)
      final fuelRate = await pidReader.readPID(PIDType.fuelRate);
      final maf = await pidReader.readPID(PIDType.maf);

      // MAF'tan yedek hesaplama
      final calculatedFuelRate = (fuelRate == 0.0 && maf > 0)
          ? (maf / 14.7 / 0.74) * 3.6
          : fuelRate;

      // Anlık tüketim (L/100km)
      final instantConsumption =
          speed > 0 ? (calculatedFuelRate / speed) * 100 : calculatedFuelRate;

      yield MotorData(
        rpm: rpm,
        speed: speed,
        throttlePosition: throttle,
        engineLoad: load,
        coolantTemp: coolant,
        intakeTemp: intake,
        fuelConsumption: calculatedFuelRate,
        instantFuelRate: instantConsumption,
        maf: maf,
        timestamp: DateTime.now(),
      );

      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Ortalama yakıt tüketimi hesapla
  Future<double> getAverageFuelConsumption(Duration duration) async {
    double totalFuel = 0.0;
    int samples = 0;
    final startTime = DateTime.now();

    await for (final data in monitorMotorData()) {
      if (DateTime.now().difference(startTime) > duration) {
        break;
      }
      totalFuel += data.fuelConsumption;
      samples++;
    }

    return samples > 0 ? totalFuel / samples : 0.0;
  }
}

/// Motor verileri model
class MotorData {
  final double rpm;
  final double speed;
  final double throttlePosition;
  final double engineLoad;
  final double coolantTemp;
  final double intakeTemp;
  final double fuelConsumption; // L/h - GERÇEK DEĞER
  final double instantFuelRate; // L/100km
  final double maf; // g/s
  final DateTime timestamp;

  MotorData({
    required this.rpm,
    required this.speed,
    required this.throttlePosition,
    required this.engineLoad,
    required this.coolantTemp,
    required this.intakeTemp,
    required this.fuelConsumption,
    required this.instantFuelRate,
    required this.maf,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'MotorData(rpm: $rpm, speed: $speed, fuel: $fuelConsumption L/h, instant: ${instantFuelRate.toStringAsFixed(2)} L/100km)';
  }
}
