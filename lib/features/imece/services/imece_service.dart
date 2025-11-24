import 'dart:async';
import '../../../core/models/imece_request_model.dart';
import '../../../core/services/location_service.dart';

/// İmece Service - Handles community help requests
class ImeceService {
  static final ImeceService _instance = ImeceService._internal();
  factory ImeceService() => _instance;
  ImeceService._internal();

  final List<ImeceRequest> _activeRequests = [];
  final LocationService _locationService = LocationService();
  
  final StreamController<List<ImeceRequest>> _requestsController = 
      StreamController<List<ImeceRequest>>.broadcast();

  Stream<List<ImeceRequest>> get requestsStream => _requestsController.stream;
  List<ImeceRequest> get activeRequests => List.unmodifiable(_activeRequests);

  /// Initialize İmece service
  Future<void> initialize() async {
    // Load active requests from API
    await _loadActiveRequests();
    
    // Start monitoring for nearby requests
    _startMonitoring();
  }

  /// Load active requests
  Future<void> _loadActiveRequests() async {
    // TODO: Load from API
    // For now, use mock data
    _activeRequests.clear();
    _requestsController.add(_activeRequests);
  }

  /// Start monitoring for nearby requests
  void _startMonitoring() {
    _locationService.positionStream.listen((position) {
      // Check for nearby requests
      _checkNearbyRequests(position.latitude, position.longitude);
    });
  }

  /// Check for nearby requests
  Future<void> _checkNearbyRequests(double lat, double lon) async {
    // Filter requests within 10 km
    final nearby = _activeRequests.where((request) {
      final distance = _locationService.calculateDistance(
        lat, lon,
        request.latitude, request.longitude,
      );
      return distance <= 10000; // 10 km
    }).toList();

    // Notify user if new nearby requests found
    // This would trigger a notification
  }

  /// Create help request
  Future<ImeceRequest> createHelpRequest({
    required String userId,
    required String userName,
    String? phoneNumber,
    String? vehicleId,
    required ImeceRequestType type,
    required String description,
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    final request = ImeceRequest(
      id: 'imece_${DateTime.now().millisecondsSinceEpoch}',
      requesterId: userId,
      requesterName: userName,
      requesterPhoneNumber: phoneNumber,
      requesterVehicleId: vehicleId,
      type: type,
      status: ImeceRequestStatus.pending,
      description: description,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 2)),
      rewardEcoCoins: _calculateReward(type),
    );

    _activeRequests.add(request);
    _requestsController.add(_activeRequests);

    // TODO: Save to API and notify nearby users

    return request;
  }

  /// Calculate reward based on request type
  int _calculateReward(ImeceRequestType type) {
    switch (type) {
      case ImeceRequestType.flatTire:
        return 150;
      case ImeceRequestType.outOfFuel:
        return 100;
      case ImeceRequestType.outOfCharge:
        return 100;
      case ImeceRequestType.mechanical:
        return 200;
      case ImeceRequestType.accident:
        return 250;
      case ImeceRequestType.other:
        return 100;
    }
  }

  /// Accept help request
  Future<bool> acceptHelpRequest({
    required String requestId,
    required String helperId,
    required String helperName,
  }) async {
    final index = _activeRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return false;

    final request = _activeRequests[index];
    
    if (request.status != ImeceRequestStatus.pending) {
      return false; // Already accepted by someone
    }

    final updated = request.copyWith(
      status: ImeceRequestStatus.accepted,
      helperId: helperId,
      helperName: helperName,
      acceptedAt: DateTime.now(),
    );

    _activeRequests[index] = updated;
    _requestsController.add(_activeRequests);

    // TODO: Save to API and notify requester

    return true;
  }

  /// Update request status
  Future<void> updateRequestStatus({
    required String requestId,
    required ImeceRequestStatus status,
  }) async {
    final index = _activeRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;

    final request = _activeRequests[index];
    final updated = request.copyWith(
      status: status,
      completedAt: status == ImeceRequestStatus.helped ? DateTime.now() : null,
    );

    if (status == ImeceRequestStatus.helped ||
        status == ImeceRequestStatus.cancelled ||
        status == ImeceRequestStatus.expired) {
      // Remove from active requests
      _activeRequests.removeAt(index);
      
      // Award coins to helper if helped
      if (status == ImeceRequestStatus.helped && request.helperId != null) {
        // TODO: Award eco coins to helper via GamificationService
      }
    } else {
      _activeRequests[index] = updated;
    }

    _requestsController.add(_activeRequests);

    // TODO: Save to API
  }

  /// Cancel help request
  Future<void> cancelHelpRequest(String requestId) async {
    await updateRequestStatus(
      requestId: requestId,
      status: ImeceRequestStatus.cancelled,
    );
  }

  /// Mark help as completed
  Future<void> completeHelpRequest(String requestId) async {
    await updateRequestStatus(
      requestId: requestId,
      status: ImeceRequestStatus.helped,
    );
  }

  /// Get nearby help requests
  Future<List<ImeceRequest>> getNearbyRequests({
    required double latitude,
    required double longitude,
    double radiusKm = 50,
  }) async {
    return _activeRequests.where((request) {
      if (!request.isActive) return false;

      final distance = _locationService.calculateDistance(
        latitude, longitude,
        request.latitude, request.longitude,
      );
      
      return distance <= (radiusKm * 1000);
    }).toList();
  }

  /// Get user's help history
  Future<List<ImeceRequest>> getUserHelpHistory(String userId) async {
    // TODO: Load from API
    return [];
  }

  /// Get user's help request history
  Future<List<ImeceRequest>> getUserRequestHistory(String userId) async {
    // TODO: Load from API
    return [];
  }

  /// Calculate user's help karma (community score)
  Future<Map<String, dynamic>> getUserHelpKarma(String userId) async {
    final history = await getUserHelpHistory(userId);
    
    final totalHelps = history.length;
    final totalRewards = history.fold<int>(
      0, 
      (sum, request) => sum + request.rewardEcoCoins,
    );

    String karmaLevel;
    if (totalHelps >= 50) {
      karmaLevel = 'Topluluk Efsanesi 🏆';
    } else if (totalHelps >= 20) {
      karmaLevel = 'Yardım Kahramanı 🦸';
    } else if (totalHelps >= 10) {
      karmaLevel = 'İyi İnsan 😊';
    } else if (totalHelps >= 5) {
      karmaLevel = 'Yeni Yardımcı 👍';
    } else {
      karmaLevel = 'Başlangıç 🌱';
    }

    return {
      'totalHelps': totalHelps,
      'totalRewards': totalRewards,
      'karmaLevel': karmaLevel,
      'averageResponseTime': 15, // minutes - mock data
    };
  }

  /// Dispose resources
  void dispose() {
    _requestsController.close();
  }
}
