class OBDData {
  final double engineRPM;
  final double vehicleSpeed; // km/h
  final double engineCoolantTemp; // Celsius
  final double intakeAirTemp; // Celsius
  final double throttlePosition; // %
  final double fuelLevel; // %
  final double fuelConsumptionRate; // L/h
  final List<String> troubleCodes; // DTC codes
  final DateTime timestamp;
  
  const OBDData({
    required this.engineRPM,
    required this.vehicleSpeed,
    required this.engineCoolantTemp,
    required this.intakeAirTemp,
    required this.throttlePosition,
    required this.fuelLevel,
    required this.fuelConsumptionRate,
    required this.troubleCodes,
    required this.timestamp,
  });
  
  bool get hasTroubleCodes => troubleCodes.isNotEmpty;
}
