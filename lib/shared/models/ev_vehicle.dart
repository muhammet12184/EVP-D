import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'vehicle.dart';

part 'ev_vehicle.g.dart';

/// Elektrikli araç özel modeli
@HiveType(typeId: 1)
class EVVehicle extends Equatable {
  @HiveField(0)
  final Vehicle baseVehicle;
  
  @HiveField(1)
  final double batteryCapacity; // kWh cinsinden
  
  @HiveField(2)
  final double currentBatteryLevel; // % cinsinden (0-100)
  
  @HiveField(3)
  final double estimatedRange; // km cinsinden
  
  @HiveField(4)
  final double maxChargingPower; // kW cinsinden
  
  @HiveField(5)
  final int batteryHealthPercentage; // % cinsinden (0-100)
  
  @HiveField(6)
  final String? chargingStationId; // Şu an bağlı olduğu şarj istasyonu
  
  @HiveField(7)
  final bool isCharging;
  
  @HiveField(8)
  final DateTime? lastChargeDate;
  
  @HiveField(9)
  final double totalChargedKwh; // Toplam şarj edilen enerji
  
  @HiveField(10)
  final bool v2lEnabled; // Vehicle to Load
  
  @HiveField(11)
  final bool v2hEnabled; // Vehicle to Home

  const EVVehicle({
    required this.baseVehicle,
    required this.batteryCapacity,
    required this.currentBatteryLevel,
    required this.estimatedRange,
    required this.maxChargingPower,
    required this.batteryHealthPercentage,
    this.chargingStationId,
    this.isCharging = false,
    this.lastChargeDate,
    this.totalChargedKwh = 0.0,
    this.v2lEnabled = false,
    this.v2hEnabled = false,
  });

  @override
  List<Object?> get props => [
        baseVehicle,
        batteryCapacity,
        currentBatteryLevel,
        estimatedRange,
        maxChargingPower,
        batteryHealthPercentage,
        chargingStationId,
        isCharging,
        lastChargeDate,
        totalChargedKwh,
        v2lEnabled,
        v2hEnabled,
      ];

  /// Menzil hesaplama (gerçekçi)
  double calculateRealisticRange({
    required double temperature,
    required double elevation,
    required String drivingStyle,
  }) {
    double baseRange = estimatedRange;
    
    // Sıcaklık etkisi
    if (temperature < 0) {
      baseRange *= 0.7; // Soğukta %30 azalma
    } else if (temperature < 10) {
      baseRange *= 0.85; // Serin havada %15 azalma
    }
    
    // Eğim etkisi
    if (elevation > 1000) {
      baseRange *= 0.9; // Yüksek rakımda %10 azalma
    }
    
    // Sürüş stili etkisi
    switch (drivingStyle.toLowerCase()) {
      case 'aggressive':
        baseRange *= 0.8;
        break;
      case 'normal':
        baseRange *= 0.95;
        break;
      case 'eco':
        baseRange *= 1.05;
        break;
    }
    
    return baseRange;
  }

  EVVehicle copyWith({
    Vehicle? baseVehicle,
    double? batteryCapacity,
    double? currentBatteryLevel,
    double? estimatedRange,
    double? maxChargingPower,
    int? batteryHealthPercentage,
    String? chargingStationId,
    bool? isCharging,
    DateTime? lastChargeDate,
    double? totalChargedKwh,
    bool? v2lEnabled,
    bool? v2hEnabled,
  }) {
    return EVVehicle(
      baseVehicle: baseVehicle ?? this.baseVehicle,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      currentBatteryLevel: currentBatteryLevel ?? this.currentBatteryLevel,
      estimatedRange: estimatedRange ?? this.estimatedRange,
      maxChargingPower: maxChargingPower ?? this.maxChargingPower,
      batteryHealthPercentage: batteryHealthPercentage ?? this.batteryHealthPercentage,
      chargingStationId: chargingStationId ?? this.chargingStationId,
      isCharging: isCharging ?? this.isCharging,
      lastChargeDate: lastChargeDate ?? this.lastChargeDate,
      totalChargedKwh: totalChargedKwh ?? this.totalChargedKwh,
      v2lEnabled: v2lEnabled ?? this.v2lEnabled,
      v2hEnabled: v2hEnabled ?? this.v2hEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseVehicle': baseVehicle.toJson(),
      'batteryCapacity': batteryCapacity,
      'currentBatteryLevel': currentBatteryLevel,
      'estimatedRange': estimatedRange,
      'maxChargingPower': maxChargingPower,
      'batteryHealthPercentage': batteryHealthPercentage,
      'chargingStationId': chargingStationId,
      'isCharging': isCharging,
      'lastChargeDate': lastChargeDate?.toIso8601String(),
      'totalChargedKwh': totalChargedKwh,
      'v2lEnabled': v2lEnabled,
      'v2hEnabled': v2hEnabled,
    };
  }

  factory EVVehicle.fromJson(Map<String, dynamic> json) {
    return EVVehicle(
      baseVehicle: Vehicle.fromJson(json['baseVehicle'] as Map<String, dynamic>),
      batteryCapacity: (json['batteryCapacity'] as num).toDouble(),
      currentBatteryLevel: (json['currentBatteryLevel'] as num).toDouble(),
      estimatedRange: (json['estimatedRange'] as num).toDouble(),
      maxChargingPower: (json['maxChargingPower'] as num).toDouble(),
      batteryHealthPercentage: json['batteryHealthPercentage'] as int,
      chargingStationId: json['chargingStationId'] as String?,
      isCharging: json['isCharging'] as bool,
      lastChargeDate: json['lastChargeDate'] != null
          ? DateTime.parse(json['lastChargeDate'] as String)
          : null,
      totalChargedKwh: (json['totalChargedKwh'] as num).toDouble(),
      v2lEnabled: json['v2lEnabled'] as bool,
      v2hEnabled: json['v2hEnabled'] as bool,
    );
  }
}
