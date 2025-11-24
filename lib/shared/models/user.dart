import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'ai_persona.dart';

part 'user.g.dart';

/// Kullanıcı modeli
@HiveType(typeId: 5)
class User extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? phoneNumber;
  
  @HiveField(4)
  final String? avatarUrl;
  
  @HiveField(5)
  final PersonaType selectedPersona;
  
  @HiveField(6)
  final List<String> vehicleIds;
  
  @HiveField(7)
  final int ecoCoins; // Oyunlaştırma puanı
  
  @HiveField(8)
  final String? currentVehicleId;
  
  @HiveField(9)
  final DateTime createdAt;
  
  @HiveField(10)
  final DateTime lastLoginAt;
  
  @HiveField(11)
  final bool isPremium;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
    this.selectedPersona = PersonaType.loyal,
    this.vehicleIds = const [],
    this.ecoCoins = 0,
    this.currentVehicleId,
    required this.createdAt,
    required this.lastLoginAt,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        avatarUrl,
        selectedPersona,
        vehicleIds,
        ecoCoins,
        currentVehicleId,
        createdAt,
        lastLoginAt,
        isPremium,
      ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? avatarUrl,
    PersonaType? selectedPersona,
    List<String>? vehicleIds,
    int? ecoCoins,
    String? currentVehicleId,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      selectedPersona: selectedPersona ?? this.selectedPersona,
      vehicleIds: vehicleIds ?? this.vehicleIds,
      ecoCoins: ecoCoins ?? this.ecoCoins,
      currentVehicleId: currentVehicleId ?? this.currentVehicleId,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'selectedPersona': selectedPersona.toString().split('.').last,
      'vehicleIds': vehicleIds,
      'ecoCoins': ecoCoins,
      'currentVehicleId': currentVehicleId,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'isPremium': isPremium,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      selectedPersona: PersonaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['selectedPersona'],
        orElse: () => PersonaType.loyal,
      ),
      vehicleIds: List<String>.from(json['vehicleIds'] as List),
      ecoCoins: json['ecoCoins'] as int,
      currentVehicleId: json['currentVehicleId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      isPremium: json['isPremium'] as bool,
    );
  }
}
