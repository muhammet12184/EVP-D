import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/models/help_request.dart';
import '../../../core/constants/app_constants.dart';

class ImeceService {
  final Dio _dio;
  
  ImeceService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
  
  /// Creates a new help request
  Future<HelpRequest> createHelpRequest({
    required HelpRequestType type,
    required String description,
    required Position location,
  }) async {
    try {
      final response = await _dio.post(
        '/imece/help-requests',
        data: {
          'type': type.name,
          'description': description,
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
      );
      
      return HelpRequest(
        id: response.data['id'],
        userId: response.data['user_id'],
        type: type,
        status: HelpRequestStatus.active,
        description: description,
        latitude: location.latitude,
        longitude: location.longitude,
        createdAt: DateTime.parse(response.data['created_at']),
        rewardPoints: response.data['reward_points'],
      );
    } catch (e) {
      throw Exception('Yardım talebi oluşturulamadı: $e');
    }
  }
  
  /// Gets nearby active help requests
  Future<List<HelpRequest>> getNearbyHelpRequests({
    required Position currentLocation,
    double radiusKm = 5.0,
  }) async {
    try {
      final response = await _dio.get(
        '/imece/help-requests/nearby',
        queryParameters: {
          'lat': currentLocation.latitude,
          'lng': currentLocation.longitude,
          'radius': radiusKm,
        },
      );
      
      return (response.data['requests'] as List)
          .map((json) => HelpRequest(
                id: json['id'],
                userId: json['user_id'],
                type: HelpRequestType.values.firstWhere(
                  (e) => e.name == json['type'],
                ),
                status: HelpRequestStatus.values.firstWhere(
                  (e) => e.name == json['status'],
                ),
                description: json['description'],
                latitude: json['latitude'].toDouble(),
                longitude: json['longitude'].toDouble(),
                createdAt: DateTime.parse(json['created_at']),
                rewardPoints: json['reward_points'],
              ))
          .toList();
    } catch (e) {
      throw Exception('Yakındaki yardım talepleri alınamadı: $e');
    }
  }
  
  /// Accepts a help request
  Future<void> acceptHelpRequest(String requestId) async {
    try {
      await _dio.post(
        '/imece/help-requests/$requestId/accept',
      );
    } catch (e) {
      throw Exception('Yardım talebi kabul edilemedi: $e');
    }
  }
  
  /// Completes a help request and awards points
  Future<void> completeHelpRequest(String requestId) async {
    try {
      await _dio.post(
        '/imece/help-requests/$requestId/complete',
      );
    } catch (e) {
      throw Exception('Yardım talebi tamamlanamadı: $e');
    }
  }
}
