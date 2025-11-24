class EVBatteryState {
  final double soc; // State of Charge (0-100)
  final double soh; // State of Health (0-100)
  final double voltage; // Volts
  final double current; // Amperes
  final double temperature; // Celsius
  final double capacity; // kWh
  final DateTime lastUpdated;
  
  const EVBatteryState({
    required this.soc,
    required this.soh,
    required this.voltage,
    required this.current,
    required this.temperature,
    required this.capacity,
    required this.lastUpdated,
  });
  
  bool get isCharging => current > 0;
  bool get isDischarging => current < 0;
  
  String get healthStatus {
    if (soh >= 80) return 'Mükemmel';
    if (soh >= 60) return 'İyi';
    if (soh >= 40) return 'Orta';
    return 'Dikkat Gerekli';
  }
}
