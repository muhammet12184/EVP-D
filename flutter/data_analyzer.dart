import 'dart:async';
import 'pid_reader.dart';
import 'pid_type.dart';

/// EV DataAnalyzer - Rejeneratif fren desteği ile
class DataAnalyzer {
  final PIDReader pidReader;
  final String vehicleBrand;

  DataAnalyzer(this.pidReader, {this.vehicleBrand = 'Unknown'});

  /// EV verilerini izle (regen dahil)
  Stream<EVData> monitorEVData() async* {
    while (true) {
      // Standart batarya PID'leri
      final soc = await pidReader.readPID(PIDType.batterySoc);
      final voltage = await pidReader.readPID(PIDType.batteryVoltage);
      final current = await pidReader.readPID(PIDType.batteryCurrent);
      final batteryTemp = await pidReader.readPID(PIDType.batteryTemp);

      // Güç hesapla (kW)
      final power = (voltage * current) / 1000.0;

      // ✅ REJENERATİF FREN VERİLERİ
      final regenData = await _getRegenData();
      final regenEnergyTotal =
          await pidReader.readPID(PIDType.regenEnergyTotal);

      // Regen durumu tespiti
      final isRegenerating = regenData.power > 0.1 || current < -1.0;

      // Menzil tahmini
      final batteryCapacity = _estimateBatteryCapacity();
      final remainingKwh = batteryCapacity * (soc / 100.0);
      final estimatedRange = remainingKwh * 5.0; // 5 km/kWh ortalama

      yield EVData(
        soc: soc,
        voltage: voltage,
        current: current,
        power: power,
        batteryTemp: batteryTemp,
        range: estimatedRange,
        regenPower: regenData.power,
        regenCurrent: regenData.current,
        regenEnergyTotal: regenEnergyTotal,
        isRegenerating: isRegenerating,
        motorTorque: regenData.torque,
        timestamp: DateTime.now(),
      );

      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  /// Marka bazlı regen PID oku
  Future<RegenData> _getRegenData() async {
    double regenPower;
    double regenCurrent;
    double motorTorque;

    switch (vehicleBrand.toUpperCase()) {
      case 'NISSAN':
      case 'RENAULT':
        regenPower =
            (await pidReader.readPID(PIDType.regenNissan)).toDouble();
        regenCurrent = await pidReader.readPID(PIDType.regenCurrent);
        motorTorque = await pidReader.readPID(PIDType.motorTorque);
        break;

      case 'HYUNDAI':
      case 'KIA':
        regenPower = await pidReader.readPID(PIDType.regenHyundai);
        regenCurrent = await pidReader.readPID(PIDType.regenCurrent);
        motorTorque = await pidReader.readPID(PIDType.motorTorque);
        break;

      case 'BMW':
      case 'MINI':
        regenPower = await pidReader.readPID(PIDType.regenBmw);
        regenCurrent = await pidReader.readPID(PIDType.regenCurrent);
        motorTorque = await pidReader.readPID(PIDType.motorTorque);
        break;

      case 'TESLA':
        regenPower = await pidReader.readPID(PIDType.regenTesla);
        regenCurrent = await pidReader.readPID(PIDType.regenCurrent);
        motorTorque = await pidReader.readPID(PIDType.motorTorque);
        break;

      default:
        // Generic regen PID
        regenPower = await pidReader.readPID(PIDType.regenPower);
        regenCurrent = await pidReader.readPID(PIDType.regenCurrent);
        motorTorque = await pidReader.readPID(PIDType.motorTorque);
    }

    return RegenData(
      power: regenPower,
      current: regenCurrent,
      torque: motorTorque,
    );
  }

  /// Regen verimliliği hesapla
  Future<RegenStats> calculateRegenEfficiency(Duration duration) async {
    double totalEnergyConsumed = 0.0;
    double totalEnergyRecovered = 0.0;
    int regenEvents = 0;
    double lastRegenEnergy = 0.0;
    final startTime = DateTime.now();

    await for (final data in monitorEVData()) {
      if (DateTime.now().difference(startTime) > duration) {
        break;
      }

      // Enerji tüketimi
      if (data.power > 0) {
        totalEnergyConsumed += data.power * (0.2 / 3600.0);
      }

      // Regen olayları
      if (data.isRegenerating) {
        regenEvents++;
        totalEnergyRecovered += data.regenPower * (0.2 / 3600.0);
      }

      lastRegenEnergy = data.regenEnergyTotal;
    }

    final efficiency = totalEnergyConsumed > 0
        ? (totalEnergyRecovered / totalEnergyConsumed) * 100.0
        : 0.0;

    return RegenStats(
      totalRecovered: totalEnergyRecovered,
      totalConsumed: totalEnergyConsumed,
      efficiency: efficiency,
      regenEvents: regenEvents,
      cumulativeRegen: lastRegenEnergy,
    );
  }

  /// Marka bazlı batarya kapasitesi tahmini
  double _estimateBatteryCapacity() {
    switch (vehicleBrand.toUpperCase()) {
      case 'NISSAN':
        return 40.0; // Leaf
      case 'RENAULT':
        return 52.0; // Zoe
      case 'HYUNDAI':
      case 'KIA':
        return 64.0; // Kona/Niro
      case 'BMW':
        return 42.2; // i3
      case 'TESLA':
        return 75.0; // Model 3 LR
      case 'TOGG':
        return 88.5; // T10X
      default:
        return 60.0;
    }
  }
}

/// EV verileri model
class EVData {
  final double soc;
  final double voltage;
  final double current;
  final double power;
  final double batteryTemp;
  final double range;
  // ✅ REGEN VERİLERİ
  final double regenPower;
  final double regenCurrent;
  final double regenEnergyTotal;
  final bool isRegenerating;
  final double motorTorque;
  final DateTime timestamp;

  EVData({
    required this.soc,
    required this.voltage,
    required this.current,
    required this.power,
    required this.batteryTemp,
    required this.range,
    required this.regenPower,
    required this.regenCurrent,
    required this.regenEnergyTotal,
    required this.isRegenerating,
    required this.motorTorque,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'EVData(soc: $soc%, power: $power kW, regen: ${isRegenerating ? "ACTIVE" : "IDLE"} ${regenPower.toStringAsFixed(1)} kW)';
  }
}

/// Regen verileri helper
class RegenData {
  final double power;
  final double current;
  final double torque;

  RegenData({
    required this.power,
    required this.current,
    required this.torque,
  });
}

/// Regen istatistikleri
class RegenStats {
  final double totalRecovered; // kWh
  final double totalConsumed; // kWh
  final double efficiency; // %
  final int regenEvents;
  final double cumulativeRegen; // kWh lifetime

  RegenStats({
    required this.totalRecovered,
    required this.totalConsumed,
    required this.efficiency,
    required this.regenEvents,
    required this.cumulativeRegen,
  });

  @override
  String toString() {
    return 'RegenStats(recovered: ${totalRecovered.toStringAsFixed(3)} kWh, efficiency: ${efficiency.toStringAsFixed(1)}%)';
  }
}
