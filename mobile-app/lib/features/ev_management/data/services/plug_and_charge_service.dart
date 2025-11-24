import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/models/charging_session.dart';
import '../../../core/constants/app_constants.dart';

class PlugAndChargeService {
  final Dio _dio;
  
  PlugAndChargeService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
  
  /// Initiates Plug & Charge session when cable is connected
  Future<ChargingSession> initiatePlugAndCharge({
    required String vehicleId,
    required String stationId,
    required String connectorId,
  }) async {
    try {
      final response = await _dio.post(
        '/ev/plug-and-charge/initiate',
        data: {
          'vehicle_id': vehicleId,
          'station_id': stationId,
          'connector_id': connectorId,
        },
      );
      
      return ChargingSession(
        id: response.data['session_id'],
        stationId: stationId,
        stationName: response.data['station_name'],
        status: ChargingStatus.connecting,
        isPlugAndCharge: true,
      );
    } catch (e) {
      throw Exception('Plug & Charge başlatılamadı: $e');
    }
  }
  
  /// Completes payment automatically after charging
  Future<void> completePayment(String sessionId) async {
    try {
      await _dio.post(
        '/ev/plug-and-charge/complete-payment',
        data: {'session_id': sessionId},
      );
    } catch (e) {
      throw Exception('Ödeme tamamlanamadı: $e');
    }
  }
}
