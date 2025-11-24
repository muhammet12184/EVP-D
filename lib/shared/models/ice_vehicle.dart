import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'vehicle.dart';

part 'ice_vehicle.g.dart';

/// Yakıt türü enum
enum FuelType {
  @HiveField(0)
  gasoline, // Benzin
  @HiveField(1)
  diesel, // Dizel
  @HiveField(2)
  lpg // LPG
}

/// OBD-II veri modeli
@HiveType(typeId: 3)
class OBDData extends Equatable {
  @HiveField(0)
  final int rpm; // Motor devri
  
  @HiveField(1)
  final double speed; // Hız (km/h)
  
  @HiveField(2)
  final double coolantTemp; // Soğutma suyu sıcaklığı (°C)
  
  @HiveField(3)
  final double fuelLevel; // Yakıt seviyesi (%)
  
  @HiveField(4)
  final double engineLoad; // Motor yükü (%)
  
  @HiveField(5)
  final List<String> dtcCodes; // Arıza kodları
  
  @HiveField(6)
  final double instantFuelConsumption; // Anlık yakıt tüketimi (L/100km)
  
  @HiveField(7)
  final DateTime timestamp;

  const OBDData({
    required this.rpm,
    required this.speed,
    required this.coolantTemp,
    required this.fuelLevel,
    required this.engineLoad,
    required this.dtcCodes,
    required this.instantFuelConsumption,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        rpm,
        speed,
        coolantTemp,
        fuelLevel,
        engineLoad,
        dtcCodes,
        instantFuelConsumption,
        timestamp,
      ];

  Map<String, dynamic> toJson() {
    return {
      'rpm': rpm,
      'speed': speed,
      'coolantTemp': coolantTemp,
      'fuelLevel': fuelLevel,
      'engineLoad': engineLoad,
      'dtcCodes': dtcCodes,
      'instantFuelConsumption': instantFuelConsumption,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory OBDData.fromJson(Map<String, dynamic> json) {
    return OBDData(
      rpm: json['rpm'] as int,
      speed: (json['speed'] as num).toDouble(),
      coolantTemp: (json['coolantTemp'] as num).toDouble(),
      fuelLevel: (json['fuelLevel'] as num).toDouble(),
      engineLoad: (json['engineLoad'] as num).toDouble(),
      dtcCodes: List<String>.from(json['dtcCodes'] as List),
      instantFuelConsumption: (json['instantFuelConsumption'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// Benzinli/Dizel araç özel modeli
@HiveType(typeId: 2)
class ICEVehicle extends Equatable {
  @HiveField(0)
  final Vehicle baseVehicle;
  
  @HiveField(1)
  final FuelType fuelType;
  
  @HiveField(2)
  final double tankCapacity; // Litre cinsinden
  
  @HiveField(3)
  final double currentFuelLevel; // % cinsinden (0-100)
  
  @HiveField(4)
  final double estimatedRange; // km cinsinden
  
  @HiveField(5)
  final double averageFuelConsumption; // L/100km
  
  @HiveField(6)
  final bool isOBDConnected;
  
  @HiveField(7)
  final OBDData? latestOBDData;
  
  @HiveField(8)
  final double totalDistanceTraveled; // km
  
  @HiveField(9)
  final double totalFuelConsumed; // Litre

  const ICEVehicle({
    required this.baseVehicle,
    required this.fuelType,
    required this.tankCapacity,
    required this.currentFuelLevel,
    required this.estimatedRange,
    required this.averageFuelConsumption,
    this.isOBDConnected = false,
    this.latestOBDData,
    this.totalDistanceTraveled = 0.0,
    this.totalFuelConsumed = 0.0,
  });

  @override
  List<Object?> get props => [
        baseVehicle,
        fuelType,
        tankCapacity,
        currentFuelLevel,
        estimatedRange,
        averageFuelConsumption,
        isOBDConnected,
        latestOBDData,
        totalDistanceTraveled,
        totalFuelConsumed,
      ];

  /// EV simülasyonu - "Elektrikli olsaydın ne kadar tasarruf ederdin?"
  Map<String, dynamic> calculateEVSavings({
    required double electricityPricePerKwh,
    required double fuelPricePerLiter,
    required double evEfficiency, // kWh/100km
  }) {
    // Son 30 günlük ortalama tüketim varsayımı
    double monthlyDistance = 1000; // km
    double monthlyFuelCost = (monthlyDistance / 100) * averageFuelConsumption * fuelPricePerLiter;
    double monthlyEVCost = (monthlyDistance / 100) * evEfficiency * electricityPricePerKwh;
    double monthlySavings = monthlyFuelCost - monthlyEVCost;
    
    return {
      'monthlyFuelCost': monthlyFuelCost,
      'monthlyEVCost': monthlyEVCost,
      'monthlySavings': monthlySavings,
      'yearlySavings': monthlySavings * 12,
      'co2Reduction': monthlyDistance * 0.12, // kg CO2/ay
    };
  }

  /// Arıza kodunu halk diline çevir
  String interpretDTCCode(String dtcCode) {
    // Basitleştirilmiş yorumlar
    final Map<String, String> commonCodes = {
      'P0171': 'Yakıt karışımı çok zayıf - Oksijen sensörü kontrol edilmeli',
      'P0300': 'Motor ateşleme sorunu - Bujiler kontrol edilmeli',
      'P0420': 'Katalitik konvertör verimsiz - Egzoz sistemi kontrol edilmeli',
      'P0128': 'Motor soğutma suyu düşük - Termostat kontrol edilmeli',
    };
    
    return commonCodes[dtcCode] ?? 'Bilinmeyen arıza kodu: $dtcCode';
  }

  ICEVehicle copyWith({
    Vehicle? baseVehicle,
    FuelType? fuelType,
    double? tankCapacity,
    double? currentFuelLevel,
    double? estimatedRange,
    double? averageFuelConsumption,
    bool? isOBDConnected,
    OBDData? latestOBDData,
    double? totalDistanceTraveled,
    double? totalFuelConsumed,
  }) {
    return ICEVehicle(
      baseVehicle: baseVehicle ?? this.baseVehicle,
      fuelType: fuelType ?? this.fuelType,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      currentFuelLevel: currentFuelLevel ?? this.currentFuelLevel,
      estimatedRange: estimatedRange ?? this.estimatedRange,
      averageFuelConsumption: averageFuelConsumption ?? this.averageFuelConsumption,
      isOBDConnected: isOBDConnected ?? this.isOBDConnected,
      latestOBDData: latestOBDData ?? this.latestOBDData,
      totalDistanceTraveled: totalDistanceTraveled ?? this.totalDistanceTraveled,
      totalFuelConsumed: totalFuelConsumed ?? this.totalFuelConsumed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseVehicle': baseVehicle.toJson(),
      'fuelType': fuelType.toString().split('.').last,
      'tankCapacity': tankCapacity,
      'currentFuelLevel': currentFuelLevel,
      'estimatedRange': estimatedRange,
      'averageFuelConsumption': averageFuelConsumption,
      'isOBDConnected': isOBDConnected,
      'latestOBDData': latestOBDData?.toJson(),
      'totalDistanceTraveled': totalDistanceTraveled,
      'totalFuelConsumed': totalFuelConsumed,
    };
  }

  factory ICEVehicle.fromJson(Map<String, dynamic> json) {
    return ICEVehicle(
      baseVehicle: Vehicle.fromJson(json['baseVehicle'] as Map<String, dynamic>),
      fuelType: FuelType.values.firstWhere(
        (e) => e.toString().split('.').last == json['fuelType'],
      ),
      tankCapacity: (json['tankCapacity'] as num).toDouble(),
      currentFuelLevel: (json['currentFuelLevel'] as num).toDouble(),
      estimatedRange: (json['estimatedRange'] as num).toDouble(),
      averageFuelConsumption: (json['averageFuelConsumption'] as num).toDouble(),
      isOBDConnected: json['isOBDConnected'] as bool,
      latestOBDData: json['latestOBDData'] != null
          ? OBDData.fromJson(json['latestOBDData'] as Map<String, dynamic>)
          : null,
      totalDistanceTraveled: (json['totalDistanceTraveled'] as num).toDouble(),
      totalFuelConsumed: (json['totalFuelConsumed'] as num).toDouble(),
    );
  }
}
