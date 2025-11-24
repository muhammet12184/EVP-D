import 'package:equatable/equatable.dart';

/// League tiers for driving competition
enum LeagueTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  master,
}

/// Achievement types
enum AchievementType {
  ecoDriver,
  distanceMaster,
  communityHero,
  earlyAdopter,
  perfectWeek,
  chargingChampion,
  fuelSaver,
  safeDriver,
}

/// Driving League Model
class DrivingLeague extends Equatable {
  final String id;
  final LeagueTier tier;
  final String name;
  final String description;
  final int minPoints;
  final int maxPoints;
  final List<LeagueParticipant> topParticipants;
  final String? userRank;
  final int? userPoints;

  const DrivingLeague({
    required this.id,
    required this.tier,
    required this.name,
    required this.description,
    required this.minPoints,
    required this.maxPoints,
    this.topParticipants = const [],
    this.userRank,
    this.userPoints,
  });

  String get tierDisplayName {
    switch (tier) {
      case LeagueTier.bronze:
        return 'Bronz Lig';
      case LeagueTier.silver:
        return 'Gümüş Lig';
      case LeagueTier.gold:
        return 'Altın Lig';
      case LeagueTier.platinum:
        return 'Platin Lig';
      case LeagueTier.diamond:
        return 'Elmas Lig';
      case LeagueTier.master:
        return 'Master Lig';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tier': tier.name,
      'name': name,
      'description': description,
      'minPoints': minPoints,
      'maxPoints': maxPoints,
      'topParticipants': topParticipants.map((p) => p.toJson()).toList(),
      'userRank': userRank,
      'userPoints': userPoints,
    };
  }

  factory DrivingLeague.fromJson(Map<String, dynamic> json) {
    return DrivingLeague(
      id: json['id'] as String,
      tier: LeagueTier.values.firstWhere((e) => e.name == json['tier']),
      name: json['name'] as String,
      description: json['description'] as String,
      minPoints: json['minPoints'] as int,
      maxPoints: json['maxPoints'] as int,
      topParticipants: (json['topParticipants'] as List<dynamic>?)
              ?.map((p) => LeagueParticipant.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      userRank: json['userRank'] as String?,
      userPoints: json['userPoints'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tier,
        name,
        description,
        minPoints,
        maxPoints,
        topParticipants,
        userRank,
        userPoints,
      ];
}

/// League Participant Model
class LeagueParticipant extends Equatable {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int points;
  final int rank;
  final int weeklyEcoCoins;

  const LeagueParticipant({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.points,
    required this.rank,
    this.weeklyEcoCoins = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'points': points,
      'rank': rank,
      'weeklyEcoCoins': weeklyEcoCoins,
    };
  }

  factory LeagueParticipant.fromJson(Map<String, dynamic> json) {
    return LeagueParticipant(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      points: json['points'] as int,
      rank: json['rank'] as int,
      weeklyEcoCoins: json['weeklyEcoCoins'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        userName,
        avatarUrl,
        points,
        rank,
        weeklyEcoCoins,
      ];
}

/// Achievement Model
class Achievement extends Equatable {
  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final String iconUrl;
  final int rewardEcoCoins;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0

  const Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.iconUrl,
    this.rewardEcoCoins = 50,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
  });

  Achievement copyWith({
    String? id,
    AchievementType? type,
    String? title,
    String? description,
    String? iconUrl,
    int? rewardEcoCoins,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return Achievement(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      rewardEcoCoins: rewardEcoCoins ?? this.rewardEcoCoins,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'rewardEcoCoins': rewardEcoCoins,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      type: AchievementType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      rewardEcoCoins: json['rewardEcoCoins'] as int? ?? 50,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        iconUrl,
        rewardEcoCoins,
        isUnlocked,
        unlockedAt,
        progress,
      ];
}

/// Eco Coin Model
class EcoCoin extends Equatable {
  final int balance;
  final List<EcoCoinTransaction> recentTransactions;

  const EcoCoin({
    this.balance = 0,
    this.recentTransactions = const [],
  });

  @override
  List<Object?> get props => [balance, recentTransactions];
}

/// Eco Coin Transaction Model
class EcoCoinTransaction extends Equatable {
  final String id;
  final int amount;
  final String reason;
  final DateTime timestamp;
  final bool isCredit; // true for earning, false for spending

  const EcoCoinTransaction({
    required this.id,
    required this.amount,
    required this.reason,
    required this.timestamp,
    this.isCredit = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
      'isCredit': isCredit,
    };
  }

  factory EcoCoinTransaction.fromJson(Map<String, dynamic> json) {
    return EcoCoinTransaction(
      id: json['id'] as String,
      amount: json['amount'] as int,
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isCredit: json['isCredit'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, amount, reason, timestamp, isCredit];
}
