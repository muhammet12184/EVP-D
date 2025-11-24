import '../../shared/models/ev_vehicle.dart';

/// Elektrikli Araç Servisi
class EVService {
  /// Plug & Charge - Otomatik ödeme başlat
  Future<Map<String, dynamic>> initiatePlugAndCharge({
    required EVVehicle vehicle,
    required String chargingStationId,
  }) async {
    // AWS IoT Core üzerinden şarj istasyonu ile iletişim
    // Gerçek uygulamada bu kısım AWS SDK kullanılarak yapılacak
    
    await Future.delayed(const Duration(seconds: 2)); // Simülasyon
    
    return {
      'success': true,
      'sessionId': 'CHG-${DateTime.now().millisecondsSinceEpoch}',
      'stationId': chargingStationId,
      'estimatedChargingTime': _calculateChargingTime(vehicle),
      'estimatedCost': _calculateChargingCost(vehicle),
    };
  }

  /// Şarj süresi hesaplama
  int _calculateChargingTime(EVVehicle vehicle) {
    final remainingCapacity = vehicle.batteryCapacity * 
        ((100 - vehicle.currentBatteryLevel) / 100);
    final chargingTimeHours = remainingCapacity / vehicle.maxChargingPower;
    return (chargingTimeHours * 60).round(); // Dakika cinsinden
  }

  /// Şarj maliyeti hesaplama
  double _calculateChargingCost(EVVehicle vehicle) {
    final remainingCapacity = vehicle.batteryCapacity * 
        ((100 - vehicle.currentBatteryLevel) / 100);
    const electricityPrice = 3.5; // TL/kWh (örnek fiyat)
    return remainingCapacity * electricityPrice;
  }

  /// Gerçekçi menzil hesaplama (hava durumu, eğim, sürüş stili)
  Future<double> calculateRealisticRange({
    required EVVehicle vehicle,
    required double latitude,
    required double longitude,
    String drivingStyle = 'normal',
  }) async {
    // Hava durumu API'sinden veri çek
    final temperature = await _getTemperature(latitude, longitude);
    
    // Eğim verisi (yükseklik API'sinden)
    final elevation = await _getElevation(latitude, longitude);
    
    return vehicle.calculateRealisticRange(
      temperature: temperature,
      elevation: elevation,
      drivingStyle: drivingStyle,
    );
  }

  Future<double> _getTemperature(double lat, double lon) async {
    // Gerçek uygulamada OpenWeatherMap veya benzeri API kullanılacak
    await Future.delayed(const Duration(milliseconds: 500));
    return 20.0; // Örnek sıcaklık
  }

  Future<double> _getElevation(double lat, double lon) async {
    // Gerçek uygulamada Google Elevation API kullanılacak
    await Future.delayed(const Duration(milliseconds: 500));
    return 100.0; // Örnek yükseklik
  }

  /// En yakın şarj istasyonlarını bul
  Future<List<Map<String, dynamic>>> findNearestChargingStations({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    // Gerçek uygulamada backend API'den veri çekilecek
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': 'ST001',
        'name': 'Zekkâ Şarj İstasyonu - Kadıköy',
        'distance': 2.3,
        'availablePorts': 4,
        'maxPower': 150,
        'pricePerKwh': 3.2,
        'latitude': latitude + 0.02,
        'longitude': longitude + 0.01,
      },
      {
        'id': 'ST002',
        'name': 'Trugo Hızlı Şarj - Beşiktaş',
        'distance': 5.1,
        'availablePorts': 2,
        'maxPower': 180,
        'pricePerKwh': 3.5,
        'latitude': latitude - 0.03,
        'longitude': longitude + 0.02,
      },
    ];
  }

  /// Batarya sağlığı analizi
  Map<String, dynamic> analyzeBatteryHealth(EVVehicle vehicle) {
    final healthPercentage = vehicle.batteryHealthPercentage;
    String status;
    String recommendation;
    
    if (healthPercentage >= 90) {
      status = 'Mükemmel';
      recommendation = 'Bataryanız çok iyi durumda. Böyle devam edin!';
    } else if (healthPercentage >= 80) {
      status = 'İyi';
      recommendation = 'Batarya sağlığı normaldir. Düzenli bakım yapın.';
    } else if (healthPercentage >= 70) {
      status = 'Orta';
      recommendation = 'Batarya kapasitesi azalmaya başladı. Bir kontrolden geçirin.';
    } else {
      status = 'Zayıf';
      recommendation = 'Batarya değişimi düşünmelisiniz. Yetkili servise başvurun.';
    }
    
    return {
      'healthPercentage': healthPercentage,
      'status': status,
      'recommendation': recommendation,
      'estimatedRemainingCycles': (1000 * healthPercentage / 100).round(),
    };
  }

  /// V2H (Vehicle to Home) - Eve elektrik aktarımı
  Future<bool> startV2H({
    required EVVehicle vehicle,
    required double powerKw,
    required int durationMinutes,
  }) async {
    if (!vehicle.v2hEnabled) {
      throw Exception('V2H özelliği bu araç için aktif değil');
    }
    
    final requiredEnergy = (powerKw * durationMinutes / 60);
    final availableEnergy = vehicle.batteryCapacity * 
        (vehicle.currentBatteryLevel / 100);
    
    if (requiredEnergy > availableEnergy) {
      throw Exception('Yetersiz batarya kapasitesi');
    }
    
    // AWS IoT Core üzerinden ev sistemine bağlan
    await Future.delayed(const Duration(seconds: 2));
    
    return true;
  }
}
