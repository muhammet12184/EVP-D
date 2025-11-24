import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Location Service - Handles GPS, location tracking, and geofencing
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  
  final StreamController<Position> _positionController = 
      StreamController<Position>.broadcast();

  Stream<Position> get positionStream => _positionController.stream;
  Position? get currentPosition => _currentPosition;

  /// Initialize location service
  Future<bool> initialize() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check and request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    // Get initial position
    await _updatePosition();

    return true;
  }

  /// Start tracking location
  void startTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentPosition = position;
      _positionController.add(position);
    });
  }

  /// Stop tracking location
  void stopTracking() {
    _positionStreamSubscription?.cancel();
  }

  /// Update current position
  Future<void> _updatePosition() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (_currentPosition != null) {
        _positionController.add(_currentPosition!);
      }
    } catch (e) {
      print('Error getting position: $e');
    }
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting position: $e');
      return null;
    }
  }

  /// Get address from coordinates
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.subLocality}, ${place.locality}';
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    return null;
  }

  /// Calculate distance between two coordinates (in meters)
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Find nearby users for İmece (within radius in meters)
  Future<List<String>> findNearbyUsers(
    double centerLat,
    double centerLon,
    double radiusMeters,
    List<Map<String, dynamic>> allUsers,
  ) async {
    List<String> nearbyUserIds = [];

    for (var user in allUsers) {
      if (user['latitude'] != null && user['longitude'] != null) {
        double distance = calculateDistance(
          centerLat,
          centerLon,
          user['latitude'] as double,
          user['longitude'] as double,
        );

        if (distance <= radiusMeters) {
          nearbyUserIds.add(user['userId'] as String);
        }
      }
    }

    return nearbyUserIds;
  }

  /// Check if coordinate is within geofence
  bool isWithinGeofence(
    double lat,
    double lon,
    double centerLat,
    double centerLon,
    double radiusMeters,
  ) {
    double distance = calculateDistance(lat, lon, centerLat, centerLon);
    return distance <= radiusMeters;
  }

  /// Get bearing between two coordinates
  double getBearing(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) {
    return Geolocator.bearingBetween(startLat, startLon, endLat, endLon);
  }

  /// Dispose resources
  void dispose() {
    stopTracking();
    _positionController.close();
  }
}
