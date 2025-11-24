/// Oyunlaştırma Servisi
class GamificationService {
  /// Sürüş puanı hesapla (0-100)
  int calculateDrivingScore({
    required double averageSpeed,
    required double acceleration,
    required double braking,
    required double cornering,
  }) {
    int score = 100;
    
    // Hız kontrolü
    if (averageSpeed > 120) {
      score -= 20;
    } else if (averageSpeed > 100) {
      score -= 10;
    }
    
    // Ani hızlanma
    if (acceleration > 0.8) {
      score -= 15;
    } else if (acceleration > 0.5) {
      score -= 8;
    }
    
    // Ani fren
    if (braking > 0.8) {
      score -= 15;
    } else if (braking > 0.5) {
      score -= 8;
    }
    
    // Viraj alma
    if (cornering > 0.7) {
      score -= 10;
    }
    
    return score.clamp(0, 100);
  }

  /// Eco-Coin kazanımı hesapla
  int calculateEcoCoins({
    required int drivingScore,
    required double distanceKm,
    required bool isEcoMode,
  }) {
    // Temel puan: Her 10 km için 10 coin
    int baseCoins = (distanceKm / 10).floor() * 10;
    
    // Sürüş puanı bonusu
    if (drivingScore >= 90) {
      baseCoins = (baseCoins * 1.5).round();
    } else if (drivingScore >= 80) {
      baseCoins = (baseCoins * 1.2).round();
    }
    
    // Eco mod bonusu
    if (isEcoMode) {
      baseCoins = (baseCoins * 1.3).round();
    }
    
    return baseCoins;
  }

  /// Haftalık lig sıralaması
  Future<List<Map<String, dynamic>>> getWeeklyLeaderboard({
    required String userId,
    int limit = 10,
  }) async {
    // Gerçek uygulamada backend'den veri çekilecek
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'rank': 1,
        'userId': 'user123',
        'name': 'Ahmet Yılmaz',
        'ecoCoins': 2850,
        'avatar': 'https://example.com/avatar1.jpg',
        'badge': 'Eco Master',
      },
      {
        'rank': 2,
        'userId': 'user456',
        'name': 'Ayşe Demir',
        'ecoCoins': 2720,
        'avatar': 'https://example.com/avatar2.jpg',
        'badge': 'Green Driver',
      },
      {
        'rank': 3,
        'userId': userId,
        'name': 'Sen',
        'ecoCoins': 2580,
        'avatar': 'https://example.com/avatar3.jpg',
        'badge': 'Eco Champion',
      },
    ];
  }

  /// Rozet sistemi
  Map<String, dynamic> checkBadgeEligibility({
    required int totalEcoCoins,
    required double totalDistance,
    required int consecutiveDaysUsed,
  }) {
    final badges = <String>[];
    
    // Mesafe rozetleri
    if (totalDistance >= 10000) {
      badges.add('10K Explorer');
    }
    if (totalDistance >= 50000) {
      badges.add('50K Voyager');
    }
    if (totalDistance >= 100000) {
      badges.add('100K Legend');
    }
    
    // Coin rozetleri
    if (totalEcoCoins >= 5000) {
      badges.add('Eco Master');
    }
    if (totalEcoCoins >= 10000) {
      badges.add('Green Champion');
    }
    
    // Süreklilik rozetleri
    if (consecutiveDaysUsed >= 7) {
      badges.add('Week Warrior');
    }
    if (consecutiveDaysUsed >= 30) {
      badges.add('Monthly Hero');
    }
    
    return {
      'earnedBadges': badges,
      'nextBadge': _getNextBadge(totalEcoCoins, totalDistance, consecutiveDaysUsed),
    };
  }

  Map<String, dynamic> _getNextBadge(
    int coins,
    double distance,
    int days,
  ) {
    if (coins < 5000) {
      return {
        'name': 'Eco Master',
        'requirement': '5000 Eco-Coin',
        'progress': coins / 5000,
      };
    }
    if (distance < 10000) {
      return {
        'name': '10K Explorer',
        'requirement': '10.000 km',
        'progress': distance / 10000,
      };
    }
    if (days < 7) {
      return {
        'name': 'Week Warrior',
        'requirement': '7 gün üst üste kullanım',
        'progress': days / 7,
      };
    }
    return {
      'name': 'Hepsini Tamamladın!',
      'requirement': 'Tebrikler!',
      'progress': 1.0,
    };
  }

  /// Şehir kaşifi - Rota üzerindeki ilginç yerler
  Future<List<Map<String, dynamic>>> getRoutePointsOfInterest({
    required List<Map<String, double>> routeCoordinates,
  }) async {
    // Gerçek uygulamada Google Places API kullanılacak
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      {
        'name': 'Kız Kulesi',
        'description': 'İstanbul\'un simgesi, 2500 yıllık tarihi yapı',
        'category': 'Tarihi Mekan',
        'latitude': 41.0214,
        'longitude': 29.0044,
        'audioGuideUrl': 'https://example.com/audio/kiz-kulesi.mp3',
      },
      {
        'name': 'Çamlıca Kulesi',
        'description': 'Türkiye\'nin en yüksek yapısı, 369 metre',
        'category': 'Modern Mimari',
        'latitude': 41.0386,
        'longitude': 29.0678,
        'audioGuideUrl': 'https://example.com/audio/camlica.mp3',
      },
    ];
  }

  /// Haftalık ödül hesapla
  Map<String, dynamic> calculateWeeklyReward(int weeklyEcoCoins) {
    if (weeklyEcoCoins >= 1000) {
      return {
        'tier': 'Gold',
        'reward': '50 TL indirim kuponu',
        'description': 'Tebrikler! Altın lige ulaştınız.',
      };
    } else if (weeklyEcoCoins >= 500) {
      return {
        'tier': 'Silver',
        'reward': '25 TL indirim kuponu',
        'description': 'Gümüş lige ulaştınız!',
      };
    } else if (weeklyEcoCoins >= 200) {
      return {
        'tier': 'Bronze',
        'reward': '10 TL indirim kuponu',
        'description': 'Bronz lige ulaştınız.',
      };
    } else {
      return {
        'tier': 'None',
        'reward': 'Henüz ödül yok',
        'description': 'Daha fazla Eco-Coin kazanarak ödül kazanabilirsiniz.',
      };
    }
  }
}
