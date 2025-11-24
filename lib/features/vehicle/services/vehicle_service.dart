import 'dart:async';
import '../../../core/models/vehicle_model.dart';

/// Vehicle Service - Handles all vehicle-related operations
class VehicleService {
  static final VehicleService _instance = VehicleService._internal();
  factory VehicleService() => _instance;
  VehicleService._internal();

  final List<Vehicle> _vehicles = [];
  Vehicle? _activeVehicle;
  
  final StreamController<Vehicle?> _activeVehicleController = 
      StreamController<Vehicle?>.broadcast();

  Stream<Vehicle?> get activeVehicleStream => _activeVehicleController.stream;
  Vehicle? get activeVehicle => _activeVehicle;
  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);

  /// Initialize vehicle service
  Future<void> initialize() async {
    // Load vehicles from local storage or API
    await _loadVehicles();
  }

  /// Load vehicles from storage
  Future<void> _loadVehicles() async {
    // TODO: Load from Hive or API
    // For now, we'll use mock data
  }

  /// Add a new vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    _vehicles.add(vehicle);
    
    // If this is the first vehicle, set it as active
    if (_vehicles.length == 1) {
      await setActiveVehicle(vehicle);
    }
    
    // TODO: Save to storage
  }

  /// Set active vehicle
  Future<void> setActiveVehicle(Vehicle vehicle) async {
    _activeVehicle = vehicle;
    _activeVehicleController.add(vehicle);
    // TODO: Save to storage
  }

  /// Update vehicle data
  Future<void> updateVehicle(Vehicle vehicle) async {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      
      if (_activeVehicle?.id == vehicle.id) {
        _activeVehicle = vehicle;
        _activeVehicleController.add(vehicle);
      }
      
      // TODO: Save to storage
    }
  }

  /// Remove vehicle
  Future<void> removeVehicle(String vehicleId) async {
    _vehicles.removeWhere((v) => v.id == vehicleId);
    
    if (_activeVehicle?.id == vehicleId) {
      _activeVehicle = _vehicles.isNotEmpty ? _vehicles.first : null;
      _activeVehicleController.add(_activeVehicle);
    }
    
    // TODO: Save to storage
  }

  /// Get vehicle by ID
  Vehicle? getVehicleById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update battery level (for EV)
  Future<void> updateBatteryLevel(String vehicleId, double level) async {
    final vehicle = getVehicleById(vehicleId);
    if (vehicle != null && vehicle.isElectric) {
      final updated = vehicle.copyWith(
        currentBatteryLevel: level,
        updatedAt: DateTime.now(),
      );
      await updateVehicle(updated);
    }
  }

  /// Update fuel level (for ICE)
  Future<void> updateFuelLevel(String vehicleId, double level) async {
    final vehicle = getVehicleById(vehicleId);
    if (vehicle != null && vehicle.isICE) {
      final updated = vehicle.copyWith(
        currentFuelLevel: level,
        updatedAt: DateTime.now(),
      );
      await updateVehicle(updated);
    }
  }

  /// Update vehicle status
  Future<void> updateStatus(String vehicleId, VehicleStatus status) async {
    final vehicle = getVehicleById(vehicleId);
    if (vehicle != null) {
      final updated = vehicle.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await updateVehicle(updated);
    }
  }

  /// Calculate EV simulation savings for ICE vehicles
  Map<String, dynamic> calculateEVSimulation(Vehicle iceVehicle) {
    if (!iceVehicle.isICE) {
      return {'error': 'Vehicle is not ICE'};
    }

    // Average calculations (Turkey 2024 estimates)
    const double avgFuelPricePerLiter = 40.0; // TRY
    const double avgElectricityPricePerKwh = 3.5; // TRY
    const double avgICEConsumption = 7.5; // L/100km
    const double avgEVConsumption = 18.0; // kWh/100km
    
    final yearlyKm = iceVehicle.odometerKm ?? 15000;
    
    // ICE costs
    final yearlyFuelCost = (yearlyKm / 100) * avgICEConsumption * avgFuelPricePerLiter;
    
    // EV costs
    final yearlyElectricityCost = (yearlyKm / 100) * avgEVConsumption * avgElectricityPricePerKwh;
    
    // Savings
    final yearlySavings = yearlyFuelCost - yearlyElectricityCost;
    final monthlySavings = yearlySavings / 12;
    
    // CO2 reduction (avg 2.3 kg CO2 per liter of fuel)
    final yearlyCO2Reduction = (yearlyKm / 100) * avgICEConsumption * 2.3;

    return {
      'currentYearlyCost': yearlyFuelCost,
      'projectedEVYearlyCost': yearlyElectricityCost,
      'yearlySavings': yearlySavings,
      'monthlySavings': monthlySavings,
      'yearlyCO2Reduction': yearlyCO2Reduction,
      'paybackPeriodYears': 5, // Simplified calculation
    };
  }

  /// Get vehicle health score
  double getVehicleHealthScore(Vehicle vehicle) {
    double score = 100.0;

    // Reduce score based on various factors
    if (vehicle.isElectric && vehicle.currentBatteryLevel != null) {
      if (vehicle.currentBatteryLevel! < 20) score -= 20;
      else if (vehicle.currentBatteryLevel! < 50) score -= 10;
    }

    if (vehicle.isICE && vehicle.currentFuelLevel != null) {
      if (vehicle.currentFuelLevel! < 20) score -= 20;
      else if (vehicle.currentFuelLevel! < 50) score -= 10;
    }

    if (vehicle.nextServiceDate != null) {
      final daysUntilService = vehicle.nextServiceDate!.difference(DateTime.now()).inDays;
      if (daysUntilService < 0) score -= 30; // Overdue
      else if (daysUntilService < 7) score -= 15;
    }

    return score.clamp(0, 100);
  }

  /// Dispose resources
  void dispose() {
    _activeVehicleController.close();
  }
}
