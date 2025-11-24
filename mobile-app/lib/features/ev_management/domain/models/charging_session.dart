enum ChargingStatus {
  idle,
  connecting,
  charging,
  completed,
  error,
}

class ChargingSession {
  final String id;
  final String stationId;
  final String stationName;
  final ChargingStatus status;
  final double? power; // kW
  final double? currentSOC;
  final double? targetSOC;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? cost;
  final bool isPlugAndCharge; // Plug & Charge enabled
  
  const ChargingSession({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.status,
    this.power,
    this.currentSOC,
    this.targetSOC,
    this.startedAt,
    this.completedAt,
    this.cost,
    this.isPlugAndCharge = false,
  });
  
  Duration? get duration {
    if (startedAt == null) return null;
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt!);
  }
}
