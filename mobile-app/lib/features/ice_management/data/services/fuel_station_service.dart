import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_constants.dart';

class FuelStation {
  final String id;
  final String name;
  final Position location;
  final double pricePerLiter;
  final String fuelType;
  final double distance; // km
  final double rating;
  
  const FuelStation({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerLiter,
    required this.fuelType,
    required this.distance,
    required this.rating,
  });
}

class FuelStationService {
  final Dio _dio;
  
  FuelStationService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
  
  /// Finds cheapest and highest quality fuel stations nearby
  Future<List<FuelStation>> findBestFuelStations({
    required Position currentLocation,
    required String fuelType,
    double radiusKm = 10.0,
  }) async {
    try {
      final response = await _dio.get(
        '/ice/fuel-stations',
        queryParameters: {
          'lat': currentLocation.latitude,
          'lng': currentLocation.longitude,
          'fuel_type': fuelType,
          'radius': radiusKm,
        },
      );
      
      return (response.data['stations'] as List)
          .map((json) => FuelStation(
                id: json['id'],
                name: json['name'],
                location: Position(
                  latitude: json['latitude'],
                  longitude: json['longitude'],
                ),
                pricePerLiter: json['price_per_liter'].toDouble(),
                fuelType: json['fuel_type'],
                distance: json['distance'].toDouble(),
                rating: json['rating'].toDouble(),
              ))
          .toList()
        ..sort((a, b) {
          // Sort by price first, then by rating
          final priceCompare = a.pricePerLiter.compareTo(b.pricePerLiter);
          if (priceCompare != 0) return priceCompare;
          return b.rating.compareTo(a.rating);
        });
    } catch (e) {
      throw Exception('Yakıt istasyonu bulunamadı: $e');
    }
  }
  
  /// Initiates mobile payment at fuel station
  Future<void> initiateMobilePayment({
    required String stationId,
    required String pumpId,
    required double amount,
  }) async {
    try {
      await _dio.post(
        '/ice/fuel-stations/payment',
        data: {
          'station_id': stationId,
          'pump_id': pumpId,
          'amount': amount,
        },
      );
    } catch (e) {
      throw Exception('Mobil ödeme başlatılamadı: $e');
    }
  }
}
