import 'dart:async';
import '../../../core/models/gamification_model.dart';
import '../../../core/config/app_config.dart';

/// Gamification Service - Handles leagues, achievements, and eco-coins
class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  DrivingLeague? _currentLeague;
  List<Achievement> _achievements = [];
  EcoCoin _ecoCoins = const EcoCoin();
  
  final StreamController<DrivingLeague> _leagueController = 
      StreamController<DrivingLeague>.broadcast();
  final StreamController<EcoCoin> _ecoCoinController = 
      StreamController<EcoCoin>.broadcast();

  Stream<DrivingLeague> get leagueStream => _leagueController.stream;
  Stream<EcoCoin> get ecoCoinStream => _ecoCoinController.stream;
  
  DrivingLeague? get currentLeague => _currentLeague;
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  EcoCoin get ecoCoins => _ecoCoins;

  /// Initialize gamification service
  Future<void> initialize(String userId) async {
    await _loadUserLeague(userId);
    await _loadAchievements(userId);
    await _loadEcoCoins(userId);
  }

  /// Load user's current league
  Future<void> _loadUserLeague(String userId) async {
    // TODO: Load from API
    // For now, use mock data
    _currentLeague = DrivingLeague(
      id: 'bronze_league',
      tier: LeagueTier.bronze,
      name: 'Bronz Lig',
      description: 'Yeni başlayanlar için mükemmel!',
      minPoints: 0,
      maxPoints: 1000,
      topParticipants: [
        LeagueParticipant(
          userId: 'user1',
          userName: 'Ahmet Y.',
          points: 950,
          rank: 1,
          weeklyEcoCoins: 100,
        ),
        LeagueParticipant(
          userId: 'user2',
          userName: 'Zeynep K.',
          points: 920,
          rank: 2,
          weeklyEcoCoins: 80,
        ),
        LeagueParticipant(
          userId: userId,
          userName: 'Sen',
          points: 750,
          rank: 15,
          weeklyEcoCoins: 50,
        ),
      ],
      userRank: '15',
      userPoints: 750,
    );
    
    _leagueController.add(_currentLeague!);
  }

  /// Load user achievements
  Future<void> _loadAchievements(String userId) async {
    // TODO: Load from API
    _achievements = [
      Achievement(
        id: 'eco_driver_1',
        type: AchievementType.ecoDriver,
        title: 'Eko Sürücü',
        description: '100 km ekonomik sürüş yapın',
        iconUrl: 'assets/achievements/eco_driver.png',
        rewardEcoCoins: 50,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
        progress: 1.0,
      ),
      Achievement(
        id: 'distance_master_1',
        type: AchievementType.distanceMaster,
        title: 'Mesafe Ustası',
        description: '1000 km yol kat edin',
        iconUrl: 'assets/achievements/distance.png',
        rewardEcoCoins: 100,
        isUnlocked: false,
        progress: 0.65,
      ),
      Achievement(
        id: 'community_hero_1',
        type: AchievementType.communityHero,
        title: 'Topluluk Kahramanı',
        description: '5 İmece yardımı yapın',
        iconUrl: 'assets/achievements/hero.png',
        rewardEcoCoins: 150,
        isUnlocked: false,
        progress: 0.4,
      ),
    ];
  }

  /// Load eco coins
  Future<void> _loadEcoCoins(String userId) async {
    // TODO: Load from API
    _ecoCoins = const EcoCoin(
      balance: 450,
      recentTransactions: [],
    );
    
    _ecoCoinController.add(_ecoCoins);
  }

  /// Award eco coins
  Future<void> awardEcoCoins({
    required String userId,
    required int amount,
    required String reason,
  }) async {
    final transaction = EcoCoinTransaction(
      id: 'eco_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      reason: reason,
      timestamp: DateTime.now(),
      isCredit: true,
    );

    final transactions = [transaction, ..._ecoCoins.recentTransactions];
    
    _ecoCoins = EcoCoin(
      balance: _ecoCoins.balance + amount,
      recentTransactions: transactions.take(20).toList(),
    );
    
    _ecoCoinController.add(_ecoCoins);

    // TODO: Save to API
  }

  /// Calculate eco-driving score
  Future<double> calculateEcoDrivingScore({
    required double distanceKm,
    required double averageSpeed,
    required double fuelEfficiency,
    required int hardBrakingCount,
    required int hardAccelerationCount,
  }) async {
    double score = 100.0;

    // Penalize for hard braking
    score -= hardBrakingCount * 2;

    // Penalize for hard acceleration
    score -= hardAccelerationCount * 1.5;

    // Reward for optimal speed (50-90 km/h)
    if (averageSpeed < 50 || averageSpeed > 90) {
      score -= 5;
    }

    // Reward for good fuel efficiency
    // Lower is better for fuel, higher for electric
    if (fuelEfficiency < 6.0) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  /// Process trip and award points
  Future<void> processTripAndAwardPoints({
    required String userId,
    required double distanceKm,
    required double ecoDrivingScore,
    required bool isElectric,
  }) async {
    // Base points for distance
    int points = (distanceKm * 2).round();

    // Bonus for eco driving
    if (ecoDrivingScore >= 90) {
      points = (points * 1.5).round();
    } else if (ecoDrivingScore >= 80) {
      points = (points * 1.2).round();
    }

    // Bonus for electric vehicles
    if (isElectric) {
      points = (points * AppConfig.fuelSavingMultiplier).round();
    }

    // Award eco coins (10% of points)
    final ecoCoinsToAward = (points * 0.1).round();
    await awardEcoCoins(
      userId: userId,
      amount: ecoCoinsToAward,
      reason: 'Yolculuk tamamlandı (${distanceKm.toStringAsFixed(1)} km)',
    );

    // Update league points
    if (_currentLeague != null) {
      final newPoints = (_currentLeague!.userPoints ?? 0) + points;
      
      // Check for league promotion
      if (newPoints > _currentLeague!.maxPoints) {
        await _promoteToNextLeague(userId);
      } else {
        _currentLeague = _currentLeague!.copyWith(userPoints: newPoints);
        _leagueController.add(_currentLeague!);
      }
    }

    // Check achievement progress
    await _updateAchievementProgress(userId, distanceKm, ecoDrivingScore);
  }

  /// Promote user to next league
  Future<void> _promoteToNextLeague(String userId) async {
    if (_currentLeague == null) return;

    LeagueTier nextTier;
    switch (_currentLeague!.tier) {
      case LeagueTier.bronze:
        nextTier = LeagueTier.silver;
        break;
      case LeagueTier.silver:
        nextTier = LeagueTier.gold;
        break;
      case LeagueTier.gold:
        nextTier = LeagueTier.platinum;
        break;
      case LeagueTier.platinum:
        nextTier = LeagueTier.diamond;
        break;
      case LeagueTier.diamond:
        nextTier = LeagueTier.master;
        break;
      case LeagueTier.master:
        return; // Already at max
    }

    // Award promotion bonus
    await awardEcoCoins(
      userId: userId,
      amount: 200,
      reason: 'Lig terfi ödülü! 🎉',
    );

    // TODO: Load new league from API
  }

  /// Update achievement progress
  Future<void> _updateAchievementProgress(
    String userId,
    double distanceKm,
    double ecoDrivingScore,
  ) async {
    for (var i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];
      
      if (achievement.isUnlocked) continue;

      bool updated = false;
      double newProgress = achievement.progress;

      switch (achievement.type) {
        case AchievementType.distanceMaster:
          // Assume target is 1000 km
          newProgress = (newProgress * 1000 + distanceKm) / 1000;
          updated = true;
          break;
        case AchievementType.ecoDriver:
          if (ecoDrivingScore >= 90) {
            newProgress = (newProgress * 100 + distanceKm) / 100;
            updated = true;
          }
          break;
        default:
          break;
      }

      if (updated) {
        newProgress = newProgress.clamp(0, 1);
        
        _achievements[i] = achievement.copyWith(progress: newProgress);

        // Check if unlocked
        if (newProgress >= 1.0 && !achievement.isUnlocked) {
          _achievements[i] = _achievements[i].copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
          );

          // Award coins
          await awardEcoCoins(
            userId: userId,
            amount: achievement.rewardEcoCoins,
            reason: 'Başarı kazanıldı: ${achievement.title}',
          );
        }
      }
    }
  }

  /// Get leaderboard
  Future<List<LeagueParticipant>> getLeaderboard({
    LeagueTier? tier,
    int limit = 50,
  }) async {
    // TODO: Load from API
    return _currentLeague?.topParticipants ?? [];
  }

  /// Redeem eco coins for rewards
  Future<bool> redeemEcoCoins({
    required String userId,
    required String rewardId,
    required int cost,
  }) async {
    if (_ecoCoins.balance < cost) {
      return false; // Insufficient balance
    }

    final transaction = EcoCoinTransaction(
      id: 'eco_${DateTime.now().millisecondsSinceEpoch}',
      amount: cost,
      reason: 'Ödül kullanıldı',
      timestamp: DateTime.now(),
      isCredit: false,
    );

    final transactions = [transaction, ..._ecoCoins.recentTransactions];
    
    _ecoCoins = EcoCoin(
      balance: _ecoCoins.balance - cost,
      recentTransactions: transactions.take(20).toList(),
    );
    
    _ecoCoinController.add(_ecoCoins);

    // TODO: Save to API and grant reward

    return true;
  }

  /// Dispose resources
  void dispose() {
    _leagueController.close();
    _ecoCoinController.close();
  }
}
