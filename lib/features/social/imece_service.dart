/// İmece (Yardımlaşma) Servisi
class ImeceService {
  /// Yardım çağrısı oluştur
  Future<String> createHelpRequest({
    required String userId,
    required double latitude,
    required double longitude,
    required String problemType,
    String? description,
  }) async {
    // Gerçek uygulamada Firebase Realtime Database veya Socket.io kullanılacak
    await Future.delayed(const Duration(seconds: 1));
    
    final requestId = 'HELP-${DateTime.now().millisecondsSinceEpoch}';
    
    // Yakındaki kullanıcılara bildirim gönder
    await _notifyNearbyUsers(latitude, longitude, requestId, problemType);
    
    return requestId;
  }

  Future<void> _notifyNearbyUsers(
    double lat,
    double lon,
    String requestId,
    String problemType,
  ) async {
    // Firebase Cloud Messaging ile push notification
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Yardım isteğine yanıt ver
  Future<bool> respondToHelpRequest({
    required String requestId,
    required String responderId,
    required int estimatedArrivalMinutes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Yardım eden kullanıcıya yüksek Eco-Coin ver
    await _awardHelpCoins(responderId, estimatedArrivalMinutes);
    
    return true;
  }

  Future<void> _awardHelpCoins(String userId, int arrivalTime) async {
    // Yakınlık ve hız bonusu
    int coins = 500; // Temel yardım puanı
    
    if (arrivalTime < 10) {
      coins += 200; // Hızlı yanıt bonusu
    } else if (arrivalTime < 20) {
      coins += 100;
    }
    
    // Backend'e coin ekle
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Aktif yardım isteklerini listele
  Future<List<Map<String, dynamic>>> getActiveHelpRequests({
    required double userLatitude,
    required double userLongitude,
    double maxDistanceKm = 20,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': 'HELP-001',
        'userName': 'Mehmet K.',
        'problemType': 'Patlak Lastik',
        'description': 'Sol ön lastik patladı, kriko yok',
        'distance': 3.5,
        'waitingMinutes': 12,
        'rewardCoins': 500,
        'latitude': userLatitude + 0.03,
        'longitude': userLongitude + 0.02,
      },
      {
        'id': 'HELP-002',
        'userName': 'Ayşe T.',
        'problemType': 'Batarya Bitti',
        'description': 'Şarj istasyonuna gidemiyorum, %2 kaldı',
        'distance': 8.2,
        'waitingMinutes': 25,
        'rewardCoins': 650,
        'latitude': userLatitude - 0.05,
        'longitude': userLongitude + 0.04,
      },
    ];
  }

  /// Yardımlaşma geçmişi
  Future<Map<String, dynamic>> getHelpHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return {
      'totalHelpsGiven': 15,
      'totalHelpsReceived': 3,
      'totalCoinsEarned': 7500,
      'reputationScore': 4.8,
      'badges': ['Yardımsever', 'İmece Kahramanı', 'Topluluk Lideri'],
      'recentHelps': [
        {
          'date': '2025-11-20',
          'type': 'given',
          'problem': 'Patlak Lastik',
          'coinsEarned': 500,
        },
        {
          'date': '2025-11-18',
          'type': 'received',
          'problem': 'Batarya Bitti',
          'helper': 'Ali Y.',
        },
      ],
    };
  }

  /// Yardımı tamamla ve puanla
  Future<bool> completeHelpRequest({
    required String requestId,
    required int rating,
    String? feedback,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Yüksek puan için ekstra bonus
    if (rating >= 4) {
      // Yardım eden kişiye ekstra 100 coin
    }
    
    return true;
  }

  /// Problem türleri
  List<Map<String, dynamic>> getProblemTypes() {
    return [
      {
        'id': 'flat_tire',
        'name': 'Patlak Lastik',
        'icon': '🛞',
        'description': 'Lastiğim patladı, yedek veya kriko lazım',
      },
      {
        'id': 'dead_battery',
        'name': 'Batarya/Akü Bitti',
        'icon': '🔋',
        'description': 'Aracım şarj olmadı veya akü bitti',
      },
      {
        'id': 'out_of_fuel',
        'name': 'Yakıt Bitti',
        'icon': '⛽',
        'description': 'Yakıtım bitti, istasyona gidemiyorum',
      },
      {
        'id': 'locked_out',
        'name': 'Araç Kilitli',
        'icon': '🔐',
        'description': 'Anahtarı içerde unuttum',
      },
      {
        'id': 'accident',
        'name': 'Kaza Yaptım',
        'icon': '🚨',
        'description': 'Küçük bir kaza oldu, yardım lazım',
      },
      {
        'id': 'other',
        'name': 'Diğer',
        'icon': '❓',
        'description': 'Başka bir sorun',
      },
    ];
  }
}
