import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'vehicle.g.dart';

/// Araç türü enum
enum VehicleType {
  @HiveField(0)
  electric, // Elektrikli araç
  @HiveField(1)
  ice, // Benzinli/Dizel araç
  @HiveField(2)
  hybrid // Hibrit araç
}

/// Temel araç modeli
@HiveType(typeId: 0)
class Vehicle extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String brand;
  
  @HiveField(3)
  final String model;
  
  @HiveField(4)
  final int year;
  
  @HiveField(5)
  final VehicleType type;
  
  @HiveField(6)
  final String? licensePlate;
  
  @HiveField(7)
  final String? vin; // Vehicle Identification Number
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime updatedAt;

  const Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.type,
    this.licensePlate,
    this.vin,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        model,
        year,
        type,
        licensePlate,
        vin,
        createdAt,
        updatedAt,
      ];

  Vehicle copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    int? year,
    VehicleType? type,
    String? licensePlate,
    String? vin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      type: type ?? this.type,
      licensePlate: licensePlate ?? this.licensePlate,
      vin: vin ?? this.vin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'year': year,
      'type': type.toString().split('.').last,
      'licensePlate': licensePlate,
      'vin': vin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      type: VehicleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      licensePlate: json['licensePlate'] as String?,
      vin: json['vin'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
