class SensorData {
  final String id;
  final String name;
  final String unit;
  final double? value;
  final double minValue;
  final double maxValue;
  final String pid;

  SensorData({
    required this.id,
    required this.name,
    required this.unit,
    this.value,
    required this.minValue,
    required this.maxValue,
    this.pid = '',
  });

  bool get hasValue => value != null;

  String get displayValue {
    if (value == null) return '---';
    if (value! == value!.roundToDouble() && value!.abs() < 10000) {
      return value!.toStringAsFixed(0);
    }
    if (value!.abs() >= 100) return value!.toStringAsFixed(0);
    if (value!.abs() >= 10) return value!.toStringAsFixed(1);
    return value!.toStringAsFixed(2);
  }

  double get normalizedValue {
    if (value == null) return 0;
    return ((value! - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
  }

  SensorData copyWith({double? value}) {
    return SensorData(
      id: id,
      name: name,
      unit: unit,
      value: value ?? this.value,
      minValue: minValue,
      maxValue: maxValue,
      pid: pid,
    );
  }
}

class BatteryCell {
  final int cellNumber;
  final double voltage;

  BatteryCell({required this.cellNumber, required this.voltage});
}

class BatteryData {
  final double totalVoltage;
  final double minVoltage;
  final double avgVoltage;
  final double maxVoltage;
  final double deltaVoltage;
  final double temperature;
  final int balancing;
  final int cellCount;
  final int moduleCount;
  final List<BatteryCell> cells;

  BatteryData({
    required this.totalVoltage,
    required this.minVoltage,
    required this.avgVoltage,
    required this.maxVoltage,
    required this.deltaVoltage,
    required this.temperature,
    required this.balancing,
    required this.cellCount,
    required this.moduleCount,
    required this.cells,
  });
}
