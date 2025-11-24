enum HelpRequestType {
  flatTire,
  outOfCharge,
  outOfFuel,
  batteryDead,
  lockedOut,
  other,
}

enum HelpRequestStatus {
  active,
  accepted,
  completed,
  cancelled,
}

class HelpRequest {
  final String id;
  final String userId;
  final HelpRequestType type;
  final HelpRequestStatus status;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String? acceptedByUserId;
  final DateTime? completedAt;
  final int rewardPoints;
  
  const HelpRequest({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.acceptedByUserId,
    this.completedAt,
    this.rewardPoints = 500,
  });
  
  String get typeDescription {
    switch (type) {
      case HelpRequestType.flatTire:
        return 'Lastik Patladı';
      case HelpRequestType.outOfCharge:
        return 'Şarj Bitti';
      case HelpRequestType.outOfFuel:
        return 'Yakıt Bitti';
      case HelpRequestType.batteryDead:
        return 'Akü Bitti';
      case HelpRequestType.lockedOut:
        return 'Anahtar Kilitlendi';
      case HelpRequestType.other:
        return 'Diğer';
    }
  }
}
