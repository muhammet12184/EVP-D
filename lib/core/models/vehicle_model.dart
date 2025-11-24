import 'package:equatable/equatable.dart';

enum VehicleType { ev, ice, hybrid }

enum VehicleStatus { active, inactive, maintenance, charging, parked }

class Vehicle extends Equatable {
  final String id;
  final String ownerId;
  final VehicleType type;
  final VehicleStatus status;
  final String brand;
  final String model;
  final int year;
  final String? vin; // Vehicle Identification Number
  final String? licensePlate;
  final String? imageUrl;
  
  // EV Specific
  final double? batteryCapacityKwh;
  final double? currentBatteryLevel; // 0-100
  final double? rangeKm;
  final bool? isCharging;
  final double? chargingPowerKw;
  final DateTime? lastChargedAt;
  
  // ICE Specific
  final double? fuelCapacityLiters;
  final double? currentFuelLevel; // 0-100
  final String? fuelType; // benzin, dizel, lpg
  final bool? obdConnected;
  final String? obdDeviceId;
  
  // Common
  final double? odometerKm;
  final double? averageFuelEconomy; // L/100km or kWh/100km
  final double? co2EmissionKg;
  final DateTime? lastServiceDate;
  final DateTime? nextServiceDate;
  
  // P2P Rental
  final bool availableForRental;
  final double? rentalPricePerHour;
  
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Vehicle({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.status,
    required this.brand,
    required this.model,
    required this.year,
    this.vin,
    this.licensePlate,
    this.imageUrl,
    this.batteryCapacityKwh,
    this.currentBatteryLevel,
    this.rangeKm,
    this.isCharging,
    this.chargingPowerKw,
    this.lastChargedAt,
    this.fuelCapacityLiters,
    this.currentFuelLevel,
    this.fuelType,
    this.obdConnected,
    this.obdDeviceId,
    this.odometerKm,
    this.averageFuelEconomy,
    this.co2EmissionKg,
    this.lastServiceDate,
    this.nextServiceDate,
    this.availableForRental = false,
    this.rentalPricePerHour,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isElectric => type == VehicleType.ev || type == VehicleType.hybrid;
  bool get isICE => type == VehicleType.ice || type == VehicleType.hybrid;
  
  String get displayName => '$brand $model ($year)';
  
  double? get currentRange {
    if (type == VehicleType.ev && currentBatteryLevel != null && rangeKm != null) {
      return (rangeKm! * currentBatteryLevel!) / 100;
    }
    if (type == VehicleType.ice && currentFuelLevel != null && fuelCapacityLiters != null && averageFuelEconomy != null) {
      final fuelLeft = (fuelCapacityLiters! * currentFuelLevel!) / 100;
      return (fuelLeft / averageFuelEconomy!) * 100;
    }
    return null;
  }

  Vehicle copyWith({
    String? id,
    String? ownerId,
    VehicleType? type,
    VehicleStatus? status,
    String? brand,
    String? model,
    int? year,
    String? vin,
    String? licensePlate,
    String? imageUrl,
    double? batteryCapacityKwh,
    double? currentBatteryLevel,
    double? rangeKm,
    bool? isCharging,
    double? chargingPowerKw,
    DateTime? lastChargedAt,
    double? fuelCapacityLiters,
    double? currentFuelLevel,
    String? fuelType,
    bool? obdConnected,
    String? obdDeviceId,
    double? odometerKm,
    double? averageFuelEconomy,
    double? co2EmissionKg,
    DateTime? lastServiceDate,
    DateTime? nextServiceDate,
    bool? availableForRental,
    double? rentalPricePerHour,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      status: status ?? this.status,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      vin: vin ?? this.vin,
      licensePlate: licensePlate ?? this.licensePlate,
      imageUrl: imageUrl ?? this.imageUrl,
      batteryCapacityKwh: batteryCapacityKwh ?? this.batteryCapacityKwh,
      currentBatteryLevel: currentBatteryLevel ?? this.currentBatteryLevel,
      rangeKm: rangeKm ?? this.rangeKm,
      isCharging: isCharging ?? this.isCharging,
      chargingPowerKw: chargingPowerKw ?? this.chargingPowerKw,
      lastChargedAt: lastChargedAt ?? this.lastChargedAt,
      fuelCapacityLiters: fuelCapacityLiters ?? this.fuelCapacityLiters,
      currentFuelLevel: currentFuelLevel ?? this.currentFuelLevel,
      fuelType: fuelType ?? this.fuelType,
      obdConnected: obdConnected ?? this.obdConnected,
      obdDeviceId: obdDeviceId ?? this.obdDeviceId,
      odometerKm: odometerKm ?? this.odometerKm,
      averageFuelEconomy: averageFuelEconomy ?? this.averageFuelEconomy,
      co2EmissionKg: co2EmissionKg ?? this.co2EmissionKg,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      availableForRental: availableForRental ?? this.availableForRental,
      rentalPricePerHour: rentalPricePerHour ?? this.rentalPricePerHour,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'type': type.name,
      'status': status.name,
      'brand': brand,
      'model': model,
      'year': year,
      'vin': vin,
      'licensePlate': licensePlate,
      'imageUrl': imageUrl,
      'batteryCapacityKwh': batteryCapacityKwh,
      'currentBatteryLevel': currentBatteryLevel,
      'rangeKm': rangeKm,
      'isCharging': isCharging,
      'chargingPowerKw': chargingPowerKw,
      'lastChargedAt': lastChargedAt?.toIso8601String(),
      'fuelCapacityLiters': fuelCapacityLiters,
      'currentFuelLevel': currentFuelLevel,
      'fuelType': fuelType,
      'obdConnected': obdConnected,
      'obdDeviceId': obdDeviceId,
      'odometerKm': odometerKm,
      'averageFuelEconomy': averageFuelEconomy,
      'co2EmissionKg': co2EmissionKg,
      'lastServiceDate': lastServiceDate?.toIso8601String(),
      'nextServiceDate': nextServiceDate?.toIso8601String(),
      'availableForRental': availableForRental,
      'rentalPricePerHour': rentalPricePerHour,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      type: VehicleType.values.firstWhere((e) => e.name == json['type']),
      status: VehicleStatus.values.firstWhere((e) => e.name == json['status']),
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      vin: json['vin'] as String?,
      licensePlate: json['licensePlate'] as String?,
      imageUrl: json['imageUrl'] as String?,
      batteryCapacityKwh: (json['batteryCapacityKwh'] as num?)?.toDouble(),
      currentBatteryLevel: (json['currentBatteryLevel'] as num?)?.toDouble(),
      rangeKm: (json['rangeKm'] as num?)?.toDouble(),
      isCharging: json['isCharging'] as bool?,
      chargingPowerKw: (json['chargingPowerKw'] as num?)?.toDouble(),
      lastChargedAt: json['lastChargedAt'] != null
          ? DateTime.parse(json['lastChargedAt'] as String)
          : null,
      fuelCapacityLiters: (json['fuelCapacityLiters'] as num?)?.toDouble(),
      currentFuelLevel: (json['currentFuelLevel'] as num?)?.toDouble(),
      fuelType: json['fuelType'] as String?,
      obdConnected: json['obdConnected'] as bool?,
      obdDeviceId: json['obdDeviceId'] as String?,
      odometerKm: (json['odometerKm'] as num?)?.toDouble(),
      averageFuelEconomy: (json['averageFuelEconomy'] as num?)?.toDouble(),
      co2EmissionKg: (json['co2EmissionKg'] as num?)?.toDouble(),
      lastServiceDate: json['lastServiceDate'] != null
          ? DateTime.parse(json['lastServiceDate'] as String)
          : null,
      nextServiceDate: json['nextServiceDate'] != null
          ? DateTime.parse(json['nextServiceDate'] as String)
          : null,
      availableForRental: json['availableForRental'] as bool? ?? false,
      rentalPricePerHour: (json['rentalPricePerHour'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        type,
        status,
        brand,
        model,
        year,
        vin,
        licensePlate,
        imageUrl,
        batteryCapacityKwh,
        currentBatteryLevel,
        rangeKm,
        isCharging,
        chargingPowerKw,
        lastChargedAt,
        fuelCapacityLiters,
        currentFuelLevel,
        fuelType,
        obdConnected,
        obdDeviceId,
        odometerKm,
        averageFuelEconomy,
        co2EmissionKg,
        lastServiceDate,
        nextServiceDate,
        availableForRental,
        rentalPricePerHour,
        createdAt,
        updatedAt,
      ];
}
