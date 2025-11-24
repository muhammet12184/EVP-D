class AppConfig {
  static const String appName = 'Super App';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.superapp.com',
  );
  
  static const String wsUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'wss://ws.superapp.com',
  );
  
  // Mapbox Configuration
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
  );
  
  // AWS IoT Configuration
  static const String awsIotEndpoint = String.fromEnvironment(
    'AWS_IOT_ENDPOINT',
    defaultValue: '',
  );
  
  // AI Service Configuration
  static const String aiServiceUrl = String.fromEnvironment(
    'AI_SERVICE_URL',
    defaultValue: 'https://ai.superapp.com',
  );
  
  static Future<void> initialize() async {
    // Initialize any required services
    // Load environment variables, configure services, etc.
  }
}
