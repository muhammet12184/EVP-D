class AppConstants {
  // API Endpoints
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.supermobility.app',
  );
  
  // AWS IoT Core
  static const String awsIotEndpoint = String.fromEnvironment(
    'AWS_IOT_ENDPOINT',
    defaultValue: '',
  );
  
  // Mapbox
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
  );
  
  // AI Assistant Personas
  static const String personaSadikKahya = 'sadik_kahya';
  static const String personaEglenceliKanka = 'eglenceli_kanka';
  static const String personaSertKoc = 'sert_koc';
  
  // Gamification
  static const int ecoCoinPerKm = 10;
  static const int imeceRewardPoints = 500;
  
  // EV Constants
  static const double defaultBatteryCapacity = 40.0; // kWh
  static const int defaultChargingPower = 7; // kW
}
