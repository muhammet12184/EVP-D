import 'package:equatable/equatable.dart';

enum UserType { owner, renter, both }

enum MembershipTier { basic, premium, platinum, elite }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserType userType;
  final MembershipTier membershipTier;
  final int ecoCoins;
  final double drivingScore;
  final String? selectedAIPersonaId;
  final List<String> vehicleIds;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImageUrl,
    this.userType = UserType.owner,
    this.membershipTier = MembershipTier.basic,
    this.ecoCoins = 0,
    this.drivingScore = 0.0,
    this.selectedAIPersonaId,
    this.vehicleIds = const [],
    required this.createdAt,
    this.lastActiveAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    UserType? userType,
    MembershipTier? membershipTier,
    int? ecoCoins,
    double? drivingScore,
    String? selectedAIPersonaId,
    List<String>? vehicleIds,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
      membershipTier: membershipTier ?? this.membershipTier,
      ecoCoins: ecoCoins ?? this.ecoCoins,
      drivingScore: drivingScore ?? this.drivingScore,
      selectedAIPersonaId: selectedAIPersonaId ?? this.selectedAIPersonaId,
      vehicleIds: vehicleIds ?? this.vehicleIds,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'userType': userType.name,
      'membershipTier': membershipTier.name,
      'ecoCoins': ecoCoins,
      'drivingScore': drivingScore,
      'selectedAIPersonaId': selectedAIPersonaId,
      'vehicleIds': vehicleIds,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'],
        orElse: () => UserType.owner,
      ),
      membershipTier: MembershipTier.values.firstWhere(
        (e) => e.name == json['membershipTier'],
        orElse: () => MembershipTier.basic,
      ),
      ecoCoins: json['ecoCoins'] as int? ?? 0,
      drivingScore: (json['drivingScore'] as num?)?.toDouble() ?? 0.0,
      selectedAIPersonaId: json['selectedAIPersonaId'] as String?,
      vehicleIds: (json['vehicleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        profileImageUrl,
        userType,
        membershipTier,
        ecoCoins,
        drivingScore,
        selectedAIPersonaId,
        vehicleIds,
        createdAt,
        lastActiveAt,
      ];
}
