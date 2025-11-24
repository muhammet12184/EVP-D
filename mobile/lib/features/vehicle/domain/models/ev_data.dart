class EVData {
  final double batterySOC;        // State of Charge (%)
  final double batterySOH;        // State of Health (%)
  final double batteryVoltage;     // Volt (V)
  final double batteryCurrent;     // Amper (A)
  final double batteryTemp;        // Sıcaklık (°C)
  final double cellVoltageDelta;   // Hücre voltaj farkı (V)
  final double? batteryCapacity;   // Kapasite (kWh)
  final double? cellMinVoltage;    // Min hücre voltajı (V)
  final double? cellMaxVoltage;    // Max hücre voltajı (V)
  final double? dcChargePower;     // DC şarj gücü (kW)
  final double? acChargePower;     // AC şarj gücü (kW)
  final double? batteryInletTemp;  // Batarya giriş sıcaklığı (°C)
  final int? dcFastChargeCount;    // Hızlı şarj sayısı
  
  EVData({
    required this.batterySOC,
    required this.batterySOH,
    required this.batteryVoltage,
    required this.batteryCurrent,
    required this.batteryTemp,
    required this.cellVoltageDelta,
    this.batteryCapacity,
    this.cellMinVoltage,
    this.cellMaxVoltage,
    this.dcChargePower,
    this.acChargePower,
    this.batteryInletTemp,
    this.dcFastChargeCount,
  });
  
  // Estimated range calculation based on weather, elevation, driving style
  double calculateEstimatedRange({
    required double averageConsumption,
    required double weatherFactor,
    required double elevationFactor,
    required double drivingStyleFactor,
  }) {
    if (batteryCapacity == null) return 0;
    
    final usableCapacity = batteryCapacity! * (batterySOC / 100);
    final adjustedConsumption = averageConsumption * 
        weatherFactor * 
        elevationFactor * 
        drivingStyleFactor;
    
    return usableCapacity / adjustedConsumption;
  }
}
