import 'package:flutter/foundation.dart';

/// Global application configuration
class AppConfig {
  // API Endpoints
  static const String baseUrl = kDebugMode
      ? 'http://localhost:8080/api/v1'
      : 'https://api.mobilityapp.com/v1';

  // AWS IoT Configuration
  static const String awsIotEndpoint = 'YOUR_AWS_IOT_ENDPOINT';
  static const String awsIotRegion = 'eu-central-1';

  // Mapbox Configuration
  static const String mapboxAccessToken = 'YOUR_MAPBOX_ACCESS_TOKEN';
  static const String mapboxStyleUrl = 'mapbox://styles/mapbox/dark-v11';

  // Firebase Configuration (will be auto-configured with google-services.json)
  
  // Feature Flags
  static const bool enableAIPersonas = true;
  static const bool enableImeceMode = true;
  static const bool enableP2PRental = true;
  static const bool enableSmartHome = true;

  // OBD-II Configuration
  static const String obdServiceUUID = '0000fff0-0000-1000-8000-00805f9b34fb';
  static const String obdCharacteristicUUID = '0000fff1-0000-1000-8000-00805f9b34fb';

  // Gamification
  static const int ecoCoinBaseReward = 10;
  static const double fuelSavingMultiplier = 1.5;

  static Future<void> initialize() async {
    if (kDebugMode) {
      print('🚀 Mobility Super App Initializing...');
      print('📍 Environment: DEBUG');
      print('🌐 Base URL: $baseUrl');
    }
    
    // Add any initialization logic here
    // e.g., Firebase, Analytics, etc.
  }

  // Environment checks
  static bool get isProduction => !kDebugMode;
  static bool get isDevelopment => kDebugMode;
}
