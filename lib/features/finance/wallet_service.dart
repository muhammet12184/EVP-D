/// Finansal İşlemler ve Cüzdan Servisi
class WalletService {
  /// Cüzdan bakiyesi
  Future<Map<String, dynamic>> getWalletBalance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return {
      'balance': 523.50,
      'currency': 'TL',
      'ecoCoins': 2850,
      'pendingTransactions': 2,
    };
  }

  /// Ödeme yap (Tek cüzdan sistemi)
  Future<Map<String, dynamic>> makePayment({
    required String userId,
    required String paymentType,
    required double amount,
    Map<String, dynamic>? metadata,
  }) async {
    // paymentType: 'charging', 'fuel', 'insurance', 'mtv', 'hgs', 'parking', 'drive_thru'
    
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'transactionId': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'type': paymentType,
      'timestamp': DateTime.now().toIso8601String(),
      'ecoCoinsEarned': _calculateEcoCoinsForPayment(paymentType, amount),
    };
  }

  int _calculateEcoCoinsForPayment(String type, double amount) {
    // Ödeme türüne göre Eco-Coin kazanımı
    if (type == 'charging') {
      return (amount * 0.1).round(); // %10 Eco-Coin
    } else if (type == 'fuel') {
      return (amount * 0.05).round(); // %5 Eco-Coin
    } else {
      return (amount * 0.03).round(); // %3 Eco-Coin
    }
  }

  /// HGS/OGS otomatik ödeme
  Future<bool> setupAutoPayment({
    required String userId,
    required String paymentType,
    required double autoRechargeAmount,
    required double triggerBalance,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  /// Sigorta ödeme
  Future<Map<String, dynamic>> payInsurance({
    required String userId,
    required String vehicleId,
    required String insuranceCompany,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'transactionId': 'INS-${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'company': insuranceCompany,
      'validUntil': DateTime.now().add(const Duration(days: 365)),
    };
  }

  /// MTV ödeme
  Future<Map<String, dynamic>> payMTV({
    required String userId,
    required String vehicleId,
    required String licensePlate,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Araç yaşı ve motor hacmine göre MTV tutarı hesapla
    final mtvAmount = 2500.0; // Örnek tutar
    
    return {
      'success': true,
      'transactionId': 'MTV-${DateTime.now().millisecondsSinceEpoch}',
      'amount': mtvAmount,
      'licensePlate': licensePlate,
      'validUntil': DateTime.now().add(const Duration(days: 365)),
    };
  }

  /// P2P Araç Kiralama - Aracını kiraya ver
  Future<Map<String, dynamic>> listVehicleForRent({
    required String vehicleId,
    required double hourlyRate,
    required List<String> availableTimeSlots,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'success': true,
      'listingId': 'RENT-${DateTime.now().millisecondsSinceEpoch}',
      'vehicleId': vehicleId,
      'hourlyRate': hourlyRate,
      'estimatedMonthlyIncome': hourlyRate * 80, // 80 saat/ay varsayımı
    };
  }

  /// Kiralık araç rezervasyonu
  Future<Map<String, dynamic>> rentVehicle({
    required String userId,
    required String listingId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final hours = endTime.difference(startTime).inHours;
    final totalCost = hours * 150.0; // 150 TL/saat örnek
    
    return {
      'success': true,
      'reservationId': 'RES-${DateTime.now().millisecondsSinceEpoch}',
      'totalCost': totalCost,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'depositAmount': totalCost * 0.2, // %20 depozito
    };
  }

  /// Drive-Thru ödeme
  Future<Map<String, dynamic>> payDriveThru({
    required String userId,
    required String restaurantId,
    required List<Map<String, dynamic>> items,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int),
    );
    
    return {
      'success': true,
      'transactionId': 'DT-${DateTime.now().millisecondsSinceEpoch}',
      'amount': totalAmount,
      'items': items,
      'estimatedReadyTime': 8, // dakika
    };
  }

  /// İşlem geçmişi
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    required String userId,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      {
        'id': 'TRX001',
        'type': 'charging',
        'amount': -85.50,
        'description': 'Zekkâ Şarj İstasyonu',
        'date': '2025-11-23T14:30:00',
        'status': 'completed',
        'ecoCoinsEarned': 8,
      },
      {
        'id': 'TRX002',
        'type': 'parking',
        'amount': -25.00,
        'description': 'AVM Park - 2 saat',
        'date': '2025-11-23T10:15:00',
        'status': 'completed',
        'ecoCoinsEarned': 0,
      },
      {
        'id': 'TRX003',
        'type': 'p2p_income',
        'amount': +240.00,
        'description': 'Araç Kiralama Geliri - 3 saat',
        'date': '2025-11-22T18:00:00',
        'status': 'completed',
        'ecoCoinsEarned': 24,
      },
    ];
  }

  /// Akıllı harcama analizi
  Future<Map<String, dynamic>> getSpendingAnalysis({
    required String userId,
    required int months,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'totalSpent': 3250.75,
      'categories': {
        'charging': 1200.00,
        'fuel': 850.50,
        'parking': 450.25,
        'insurance': 500.00,
        'maintenance': 250.00,
      },
      'comparisonWithLastMonth': -12.5, // %12.5 azalma
      'recommendations': [
        'Şarj istasyonu değiştirerek ayda 50 TL tasarruf edebilirsiniz',
        'Off-peak saatlerde şarj ederek %20 indirim kazanabilirsiniz',
      ],
    };
  }
}
