class ICEData {
  final double? engineRPM;
  final double? vehicleSpeed;
  final double? throttlePosition;
  final double? engineLoad;
  final double? coolantTemp;
  final double? intakeAirTemp;
  final double? mafAirFlow;        // Mass Air Flow
  final double? fuelLevel;
  final String? dtcCodes;          // Diagnostic Trouble Codes
  
  ICEData({
    this.engineRPM,
    this.vehicleSpeed,
    this.throttlePosition,
    this.engineLoad,
    this.coolantTemp,
    this.intakeAirTemp,
    this.mafAirFlow,
    this.fuelLevel,
    this.dtcCodes,
  });
  
  // Calculate estimated fuel consumption
  double? calculateFuelConsumption() {
    if (engineRPM == null || vehicleSpeed == null || engineLoad == null) {
      return null;
    }
    
    // Simplified fuel consumption calculation
    final baseConsumption = 8.0; // L/100km base
    final loadFactor = engineLoad! / 100;
    final speedFactor = vehicleSpeed! < 60 ? 1.2 : (vehicleSpeed! > 100 ? 1.1 : 1.0);
    
    return baseConsumption * loadFactor * speedFactor;
  }
  
  // Simulate EV savings
  double calculateEVSavings({
    required double evConsumption, // kWh/100km
    required double electricityPrice, // TL/kWh
    required double fuelPrice, // TL/L
  }) {
    final fuelConsumption = calculateFuelConsumption();
    if (fuelConsumption == null) return 0;
    
    final iceCost = fuelConsumption * fuelPrice;
    final evCost = (evConsumption / 100) * electricityPrice;
    
    return iceCost - evCost;
  }
}
