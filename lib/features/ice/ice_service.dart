import '../../shared/models/ice_vehicle.dart';

/// Benzinli/Dizel Araç Servisi
class ICEService {
  /// OBD-II bağlantısı başlat
  Future<bool> connectOBD({required String deviceId}) async {
    // Flutter Blue Plus kullanarak Bluetooth bağlantısı
    // Gerçek uygulamada ELM327 veya benzeri OBD-II adaptörü ile bağlantı
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

  /// OBD-II verilerini oku
  Future<OBDData> readOBDData() async {
    // Gerçek uygulamada OBD-II protokolü üzerinden veri okunacak
    await Future.delayed(const Duration(milliseconds: 500));
    
    return OBDData(
      rpm: 2500,
      speed: 80,
      coolantTemp: 92,
      fuelLevel: 65,
      engineLoad: 45,
      dtcCodes: const [],
      instantFuelConsumption: 7.2,
      timestamp: DateTime.now(),
    );
  }

  /// Arıza kodlarını oku ve yorumla
  Future<List<Map<String, dynamic>>> readAndInterpretDTCCodes(
    ICEVehicle vehicle,
  ) async {
    final obdData = await readOBDData();
    
    return obdData.dtcCodes.map((code) {
      return {
        'code': code,
        'interpretation': vehicle.interpretDTCCode(code),
        'severity': _getDTCSeverity(code),
      };
    }).toList();
  }

  String _getDTCSeverity(String dtcCode) {
    // P0xxx: Powertrain (Motor/Şanzıman)
    // C0xxx: Chassis (Şasi)
    // B0xxx: Body (Gövde)
    // U0xxx: Network (İletişim)
    
    if (dtcCode.startsWith('P03') || dtcCode.startsWith('P04')) {
      return 'critical'; // Emisyon/Katalitik konvertör
    } else if (dtcCode.startsWith('P01') || dtcCode.startsWith('P02')) {
      return 'moderate'; // Yakıt ve hava sistemi
    } else {
      return 'low';
    }
  }

  /// En yakın ve en ucuz yakıt istasyonunu bul
  Future<List<Map<String, dynamic>>> findBestFuelStations({
    required double latitude,
    required double longitude,
    required FuelType fuelType,
    double radiusKm = 10,
  }) async {
    // Gerçek uygulamada backend API'den güncel yakıt fiyatları çekilecek
    await Future.delayed(const Duration(seconds: 1));
    
    final fuelName = _getFuelName(fuelType);
    
    return [
      {
        'id': 'FS001',
        'name': 'Shell - Bağdat Caddesi',
        'distance': 1.8,
        'fuelType': fuelName,
        'pricePerLiter': 38.5,
        'hasCarWash': true,
        'hasShop': true,
        'rating': 4.5,
        'latitude': latitude + 0.015,
        'longitude': longitude + 0.008,
      },
      {
        'id': 'FS002',
        'name': 'BP - E5 Üzeri',
        'distance': 3.2,
        'fuelType': fuelName,
        'pricePerLiter': 37.9,
        'hasCarWash': false,
        'hasShop': true,
        'rating': 4.2,
        'latitude': latitude - 0.025,
        'longitude': longitude + 0.015,
      },
      {
        'id': 'FS003',
        'name': 'Opet - Maltepe',
        'distance': 4.5,
        'fuelType': fuelName,
        'pricePerLiter': 38.2,
        'hasCarWash': true,
        'hasShop': true,
        'rating': 4.7,
        'latitude': latitude + 0.035,
        'longitude': longitude - 0.012,
      },
    ]..sort((a, b) => (a['pricePerLiter'] as double)
        .compareTo(b['pricePerLiter'] as double));
  }

  String _getFuelName(FuelType type) {
    switch (type) {
      case FuelType.gasoline:
        return 'Benzin (95 Oktan)';
      case FuelType.diesel:
        return 'Motorin';
      case FuelType.lpg:
        return 'LPG (Otogaz)';
    }
  }

  /// Mobil ödeme başlat (pompa başında)
  Future<Map<String, dynamic>> initiateMobilePayment({
    required String stationId,
    required int pumpNumber,
    required double amount,
  }) async {
    // Gerçek uygulamada ödeme gateway'i kullanılacak (Stripe, iyzico vb.)
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'transactionId': 'TX-${DateTime.now().millisecondsSinceEpoch}',
      'pumpNumber': pumpNumber,
      'amount': amount,
      'message': 'Ödemeniz başarıyla alındı. Pompa açılıyor...',
    };
  }

  /// EV simülasyonu - Elektrikli araç ile karşılaştırma
  Map<String, dynamic> calculateEVComparison({
    required ICEVehicle vehicle,
    required double monthlyDistance,
  }) {
    const electricityPrice = 3.5; // TL/kWh
    const fuelPrice = 38.0; // TL/Litre (ortalama)
    const evEfficiency = 15.0; // kWh/100km (ortalama)
    
    final savings = vehicle.calculateEVSavings(
      electricityPricePerKwh: electricityPrice,
      fuelPricePerLiter: fuelPrice,
      evEfficiency: evEfficiency,
    );
    
    // Benzer bir EV modeli öner
    final suggestedEV = _suggestSimilarEV(vehicle.baseVehicle.brand);
    
    return {
      ...savings,
      'suggestedEV': suggestedEV,
      'breakEvenMonths': (suggestedEV['price'] / savings['monthlySavings']).round(),
    };
  }

  Map<String, dynamic> _suggestSimilarEV(String brand) {
    // Marka bazlı EV önerileri
    final evSuggestions = {
      'Tesla': {
        'model': 'Tesla Model 3',
        'price': 1500000,
        'range': 500,
      },
      'BMW': {
        'model': 'BMW i4',
        'price': 1800000,
        'range': 480,
      },
      'Mercedes': {
        'model': 'Mercedes EQE',
        'price': 2000000,
        'range': 520,
      },
      'Volkswagen': {
        'model': 'Volkswagen ID.4',
        'price': 1200000,
        'range': 420,
      },
    };
    
    return evSuggestions[brand] ?? {
      'model': 'Tesla Model 3',
      'price': 1500000,
      'range': 500,
    };
  }

  /// Yakıt tüketimi analizi
  Map<String, dynamic> analyzeFuelConsumption(ICEVehicle vehicle) {
    final efficiency = vehicle.averageFuelConsumption;
    String rating;
    String recommendation;
    
    if (efficiency < 6) {
      rating = 'Mükemmel';
      recommendation = 'Çok ekonomik sürüyorsunuz! Böyle devam edin.';
    } else if (efficiency < 8) {
      rating = 'İyi';
      recommendation = 'Normal aralıkta tüketim. Eco modu kullanarak daha da iyileştirebilirsiniz.';
    } else if (efficiency < 12) {
      rating = 'Orta';
      recommendation = 'Tüketim biraz yüksek. Hızınızı ve hızlanmalarınızı kontrol edin.';
    } else {
      rating = 'Yüksek';
      recommendation = 'Tüketim çok yüksek. Sürüş tarzınızı gözden geçirin veya araç kontrolünden geçirin.';
    }
    
    return {
      'averageConsumption': efficiency,
      'rating': rating,
      'recommendation': recommendation,
      'monthlyFuelCost': _estimateMonthlyFuelCost(vehicle),
    };
  }

  double _estimateMonthlyFuelCost(ICEVehicle vehicle) {
    const monthlyDistance = 1000; // km
    const fuelPrice = 38.0; // TL/Litre
    return (monthlyDistance / 100) * vehicle.averageFuelConsumption * fuelPrice;
  }
}
