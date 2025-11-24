import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationService {
  static Future<void> initialize() async {
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Initialize SharedPreferences
    await SharedPreferences.getInstance();
    
    // TODO: Initialize other services
    // - AWS IoT Core connection
    // - Mapbox initialization
    // - OBD-II scanner initialization
    // - AI model loading
  }
}
