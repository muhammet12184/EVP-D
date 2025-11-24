import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';

class TroubleCodeExplanation {
  final String code;
  final String userFriendlyExplanation;
  final String severity; // 'low', 'medium', 'high', 'critical'
  final String recommendedAction;
  final double estimatedCost;
  
  const TroubleCodeExplanation({
    required this.code,
    required this.userFriendlyExplanation,
    required this.severity,
    required this.recommendedAction,
    required this.estimatedCost,
  });
}

class AIMechanicService {
  final Dio _dio;
  
  AIMechanicService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
  
  /// Translates OBD trouble codes to user-friendly explanations
  Future<TroubleCodeExplanation> explainTroubleCode(String dtcCode) async {
    try {
      final response = await _dio.post(
        '/ai/mechanic/explain-trouble-code',
        data: {'dtc_code': dtcCode},
      );
      
      return TroubleCodeExplanation(
        code: dtcCode,
        userFriendlyExplanation: response.data['explanation'],
        severity: response.data['severity'],
        recommendedAction: response.data['recommended_action'],
        estimatedCost: response.data['estimated_cost'].toDouble(),
      );
    } catch (e) {
      throw Exception('Arıza kodu açıklanamadı: $e');
    }
  }
  
  /// Calculates potential EV savings simulation
  Future<Map<String, dynamic>> calculateEVSavings({
    required double monthlyFuelCost,
    required double averageMonthlyKm,
  }) async {
    try {
      final response = await _dio.post(
        '/ai/mechanic/ev-savings-simulation',
        data: {
          'monthly_fuel_cost': monthlyFuelCost,
          'average_monthly_km': averageMonthlyKm,
        },
      );
      
      return response.data;
    } catch (e) {
      throw Exception('EV tasarruf simülasyonu hesaplanamadı: $e');
    }
  }
}
