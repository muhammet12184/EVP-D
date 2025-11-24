import 'package:equatable/equatable.dart';

enum ImeceRequestType { 
  flatTire, // Lastik patlaması
  outOfFuel, // Yakıt bitti
  outOfCharge, // Şarj bitti
  mechanical, // Mekanik arıza
  accident, // Kaza
  other, // Diğer
}

enum ImeceRequestStatus {
  pending, // Bekliyor
  accepted, // Kabul edildi
  onTheWay, // Yolda
  helped, // Yardım edildi
  cancelled, // İptal edildi
  expired, // Süresi doldu
}

/// İmece Request Model - Community help request
class ImeceRequest extends Equatable {
  final String id;
  final String requesterId;
  final String requesterName;
  final String? requesterPhoneNumber;
  final String? requesterVehicleId;
  final ImeceRequestType type;
  final ImeceRequestStatus status;
  final String description;
  final double latitude;
  final double longitude;
  final String locationName;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? helperId;
  final String? helperName;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final int rewardEcoCoins;
  final List<String> nearbyUserIds;

  const ImeceRequest({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    this.requesterPhoneNumber,
    this.requesterVehicleId,
    required this.type,
    required this.status,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.createdAt,
    this.expiresAt,
    this.helperId,
    this.helperName,
    this.acceptedAt,
    this.completedAt,
    this.rewardEcoCoins = 100,
    this.nearbyUserIds = const [],
  });

  bool get isActive => status == ImeceRequestStatus.pending || 
                       status == ImeceRequestStatus.accepted || 
                       status == ImeceRequestStatus.onTheWay;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  String get typeDisplayName {
    switch (type) {
      case ImeceRequestType.flatTire:
        return 'Lastik Patladı';
      case ImeceRequestType.outOfFuel:
        return 'Yakıt Bitti';
      case ImeceRequestType.outOfCharge:
        return 'Şarj Bitti';
      case ImeceRequestType.mechanical:
        return 'Mekanik Arıza';
      case ImeceRequestType.accident:
        return 'Kaza';
      case ImeceRequestType.other:
        return 'Diğer';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case ImeceRequestStatus.pending:
        return 'Yardım Bekleniyor';
      case ImeceRequestStatus.accepted:
        return 'Yardım Kabul Edildi';
      case ImeceRequestStatus.onTheWay:
        return 'Yardım Yolda';
      case ImeceRequestStatus.helped:
        return 'Yardım Tamamlandı';
      case ImeceRequestStatus.cancelled:
        return 'İptal Edildi';
      case ImeceRequestStatus.expired:
        return 'Süresi Doldu';
    }
  }

  ImeceRequest copyWith({
    String? id,
    String? requesterId,
    String? requesterName,
    String? requesterPhoneNumber,
    String? requesterVehicleId,
    ImeceRequestType? type,
    ImeceRequestStatus? status,
    String? description,
    double? latitude,
    double? longitude,
    String? locationName,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? helperId,
    String? helperName,
    DateTime? acceptedAt,
    DateTime? completedAt,
    int? rewardEcoCoins,
    List<String>? nearbyUserIds,
  }) {
    return ImeceRequest(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterPhoneNumber: requesterPhoneNumber ?? this.requesterPhoneNumber,
      requesterVehicleId: requesterVehicleId ?? this.requesterVehicleId,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      helperId: helperId ?? this.helperId,
      helperName: helperName ?? this.helperName,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
      rewardEcoCoins: rewardEcoCoins ?? this.rewardEcoCoins,
      nearbyUserIds: nearbyUserIds ?? this.nearbyUserIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'requesterPhoneNumber': requesterPhoneNumber,
      'requesterVehicleId': requesterVehicleId,
      'type': type.name,
      'status': status.name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'helperId': helperId,
      'helperName': helperName,
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'rewardEcoCoins': rewardEcoCoins,
      'nearbyUserIds': nearbyUserIds,
    };
  }

  factory ImeceRequest.fromJson(Map<String, dynamic> json) {
    return ImeceRequest(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      requesterName: json['requesterName'] as String,
      requesterPhoneNumber: json['requesterPhoneNumber'] as String?,
      requesterVehicleId: json['requesterVehicleId'] as String?,
      type: ImeceRequestType.values.firstWhere((e) => e.name == json['type']),
      status: ImeceRequestStatus.values.firstWhere((e) => e.name == json['status']),
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['locationName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String) 
          : null,
      helperId: json['helperId'] as String?,
      helperName: json['helperName'] as String?,
      acceptedAt: json['acceptedAt'] != null 
          ? DateTime.parse(json['acceptedAt'] as String) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String) 
          : null,
      rewardEcoCoins: json['rewardEcoCoins'] as int? ?? 100,
      nearbyUserIds: (json['nearbyUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        requesterId,
        requesterName,
        requesterPhoneNumber,
        requesterVehicleId,
        type,
        status,
        description,
        latitude,
        longitude,
        locationName,
        createdAt,
        expiresAt,
        helperId,
        helperName,
        acceptedAt,
        completedAt,
        rewardEcoCoins,
        nearbyUserIds,
      ];
}
