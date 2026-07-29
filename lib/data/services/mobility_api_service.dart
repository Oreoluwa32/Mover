import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movr/core/config/app_environment.dart';
import 'package:movr/core/utils/task_state_sync.dart';
import 'package:movr/data/services/auth_session_service.dart';

class MobilityApiService {
  MobilityApiService({
    String? customBaseUrl,
    FlutterSecureStorage? storage,
  })  : _baseUrl = customBaseUrl ?? AppEnvironment.apiBaseUrl,
        _storage = storage ?? const FlutterSecureStorage() {
    _sessionService = AuthSessionService(
      customBaseUrl: _baseUrl,
      storage: _storage,
    );
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final retriedResponse =
              await _sessionService.retryIfUnauthorized(error, _dio);
          if (retriedResponse != null) {
            return handler.resolve(retriedResponse);
          }
          handler.next(error);
        },
      ),
    );
  }

  final String _baseUrl;
  final FlutterSecureStorage _storage;
  late final Dio _dio;
  late final AuthSessionService _sessionService;

  double _roundCoordinate(double value) {
    return double.parse(value.toStringAsFixed(6));
  }

  List<Map<String, dynamic>> _extractCollection(dynamic data) {
    if (data is List) {
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _filterPlansByType(
    List<Map<String, dynamic>> allPlans, {
    String? planType,
  }) {
    if (planType == null || planType.trim().isEmpty) {
      return allPlans;
    }

    final expectedType = planType.trim().toLowerCase();
    return allPlans.where((plan) {
      final currentType = plan['plan_type']?.toString().trim().toLowerCase();
      if (expectedType == 'ride') {
        return currentType == 'ride' || currentType == 'hybrid';
      }
      if (expectedType == 'delivery') {
        return currentType == 'delivery' || currentType == 'hybrid';
      }
      return currentType == expectedType;
    }).toList();
  }

  bool _isPlanBidEligible(Map<String, dynamic> plan) {
    final status = plan['status']?.toString().trim().toLowerCase();
    return status == 'published' || status == 'in_progress';
  }

  void _notifyTaskStateChanged(String reason) {
    TaskStateSync.emit(reason);
  }

  Future<List<Map<String, dynamic>>> getMyTravelPlans() async {
    final response =
        await _dio.get('/api/mobility/travel-plans/', queryParameters: {
      'mine': 'true',
    });
    return _extractCollection(response.data);
  }

  Future<List<Map<String, dynamic>>> searchAvailableTravelPlans({
    String? origin,
    String? destination,
    String? planType,
    String? date,
  }) async {
    final response = await _dio.get(
      '/api/mobility/travel-plans/',
      queryParameters: {
        if (origin != null && origin.isNotEmpty) 'origin': origin,
        if (destination != null && destination.isNotEmpty)
          'destination': destination,
        if (planType != null && planType.isNotEmpty && planType != 'hybrid')
          'plan_type': planType,
        if (date != null && date.isNotEmpty) 'date': date,
      },
    );
    return _extractCollection(response.data);
  }

  Future<Map<String, dynamic>?> getLatestTravelPlan({
    String? planType,
  }) async {
    final allPlans = await getMyTravelPlans();
    final plans = _filterPlansByType(allPlans, planType: planType);
    if (plans.isEmpty) {
      return null;
    }
    for (final plan in plans) {
      if (plan['is_live'] == true) {
        return plan;
      }
    }
    for (final plan in plans) {
      final status = plan['status']?.toString();
      if (status == 'in_progress' || status == 'published') {
        return plan;
      }
    }
    return plans.first;
  }

  Future<Map<String, dynamic>?> getLatestBiddableTravelPlan({
    String? planType,
  }) async {
    final allPlans = await getMyTravelPlans();
    final plans = _filterPlansByType(allPlans, planType: planType)
        .where(_isPlanBidEligible)
        .toList();
    if (plans.isEmpty) {
      return null;
    }
    for (final plan in plans) {
      if (plan['is_live'] == true) {
        return plan;
      }
    }
    return plans.first;
  }

  Future<Map<String, dynamic>> createTravelPlan({
    required String title,
    required String planType,
    required String originName,
    double? originLatitude,
    double? originLongitude,
    required String destinationName,
    double? destinationLatitude,
    double? destinationLongitude,
    required DateTime departureTime,
    DateTime? arrivalTime,
    String? vehicleType,
    int? seatsAvailable,
    double? pricePerSeat,
    double? packageCapacityKg,
    String? status,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _dio.post(
      '/api/mobility/travel-plans/',
      data: {
        'title': title,
        'plan_type': planType,
        'origin_name': originName,
        if (originLatitude != null)
          'origin_latitude': _roundCoordinate(originLatitude),
        if (originLongitude != null)
          'origin_longitude': _roundCoordinate(originLongitude),
        'destination_name': destinationName,
        if (destinationLatitude != null)
          'destination_latitude': _roundCoordinate(destinationLatitude),
        if (destinationLongitude != null)
          'destination_longitude': _roundCoordinate(destinationLongitude),
        'departure_time': departureTime.toUtc().toIso8601String(),
        if (arrivalTime != null)
          'arrival_time': arrivalTime.toUtc().toIso8601String(),
        if (vehicleType != null && vehicleType.isNotEmpty)
          'vehicle_type': vehicleType,
        'seats_available': seatsAvailable ?? 1,
        'price_per_seat': pricePerSeat ?? 0,
        'package_capacity_kg': packageCapacityKg ?? 0,
        'status': status ?? 'published',
        'metadata': metadata ?? <String, dynamic>{},
      },
    );
    _notifyTaskStateChanged('travel_plan_created');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> toggleTravelPlanLive({
    required String travelPlanId,
    required bool isLive,
  }) async {
    final response = await _dio.post(
      '/api/mobility/travel-plans/$travelPlanId/toggle_live/',
      data: {
        'is_live': isLive,
      },
    );
    _notifyTaskStateChanged('travel_plan_live_toggled');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> deleteTravelPlan({
    required String travelPlanId,
  }) async {
    await _dio.delete('/api/mobility/travel-plans/$travelPlanId/');
    _notifyTaskStateChanged('travel_plan_deleted');
  }

  /// PATCH the given TravelPlan with any of the supported fields. Only the
  /// fields that are non-null in [fields] are sent, so callers can update a
  /// single value (e.g. just the title, or just departure_time) without
  /// having to send the whole plan.
  Future<Map<String, dynamic>> updateTravelPlan({
    required String travelPlanId,
    Map<String, dynamic> fields = const {},
  }) async {
    final response = await _dio.patch(
      '/api/mobility/travel-plans/$travelPlanId/',
      data: fields,
    );
    _notifyTaskStateChanged('travel_plan_updated');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> createRideRequest({
    required String originName,
    double? originLatitude,
    double? originLongitude,
    required String destinationName,
    double? destinationLatitude,
    double? destinationLongitude,
    required DateTime scheduledTime,
    int seatsRequested = 1,
    String? note,
  }) async {
    final response = await _dio.post(
      '/api/mobility/ride-requests/',
      data: {
        'origin_name': originName,
        if (originLatitude != null)
          'origin_latitude': _roundCoordinate(originLatitude),
        if (originLongitude != null)
          'origin_longitude': _roundCoordinate(originLongitude),
        'destination_name': destinationName,
        if (destinationLatitude != null)
          'destination_latitude': _roundCoordinate(destinationLatitude),
        if (destinationLongitude != null)
          'destination_longitude': _roundCoordinate(destinationLongitude),
        'scheduled_time': scheduledTime.toUtc().toIso8601String(),
        'seats_requested': seatsRequested,
        'note': note ?? '',
      },
    );
    _notifyTaskStateChanged('ride_request_created');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> createDeliveryRequest({
    required String pickupName,
    double? pickupLatitude,
    double? pickupLongitude,
    required String dropoffName,
    double? dropoffLatitude,
    double? dropoffLongitude,
    required DateTime scheduledTime,
    required String packageDescription,
    double weightKg = 0,
    double insuredValue = 0,
    bool insuranceOpted = false,
  }) async {
    final response = await _dio.post(
      '/api/mobility/delivery-requests/',
      data: {
        'pickup_name': pickupName,
        if (pickupLatitude != null)
          'pickup_latitude': _roundCoordinate(pickupLatitude),
        if (pickupLongitude != null)
          'pickup_longitude': _roundCoordinate(pickupLongitude),
        'dropoff_name': dropoffName,
        if (dropoffLatitude != null)
          'dropoff_latitude': _roundCoordinate(dropoffLatitude),
        if (dropoffLongitude != null)
          'dropoff_longitude': _roundCoordinate(dropoffLongitude),
        'scheduled_time': scheduledTime.toUtc().toIso8601String(),
        'package_description': packageDescription,
        'weight_kg': weightKg,
        'insured_value': insuredValue,
        'insurance_opted': insuranceOpted,
      },
    );
    _notifyTaskStateChanged('delivery_request_created');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getRideRequests() async {
    final response = await _dio.get('/api/mobility/ride-requests/');
    return _extractCollection(response.data);
  }

  Future<void> deleteRideRequest({
    required String requestId,
  }) async {
    await _dio.delete('/api/mobility/ride-requests/$requestId/');
    _notifyTaskStateChanged('ride_request_deleted');
  }

  Future<List<Map<String, dynamic>>> getDeliveryRequests() async {
    final response = await _dio.get('/api/mobility/delivery-requests/');
    return _extractCollection(response.data);
  }

  Future<void> deleteDeliveryRequest({
    required String requestId,
  }) async {
    await _dio.delete('/api/mobility/delivery-requests/$requestId/');
    _notifyTaskStateChanged('delivery_request_deleted');
  }

  Future<List<Map<String, dynamic>>> getDiscoverRideRequests() async {
    final response = await _dio.get(
      '/api/mobility/ride-requests/',
      queryParameters: {'discover': 'true'},
    );
    return _extractCollection(response.data);
  }

  Future<List<Map<String, dynamic>>> getDiscoverDeliveryRequests() async {
    final response = await _dio.get(
      '/api/mobility/delivery-requests/',
      queryParameters: {'discover': 'true'},
    );
    return _extractCollection(response.data);
  }

  Future<Map<String, dynamic>> bidRideRequest({
    required String requestId,
    required double agreedPrice,
    String? travelPlanId,
  }) async {
    final response = await _dio.post(
      '/api/mobility/ride-requests/$requestId/bid/',
      data: {
        'agreed_price': agreedPrice,
        if (travelPlanId != null && travelPlanId.isNotEmpty)
          'travel_plan_id': travelPlanId,
      },
    );
    _notifyTaskStateChanged('ride_bid_submitted');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> bidDeliveryRequest({
    required String requestId,
    required double agreedPrice,
    String? travelPlanId,
  }) async {
    final response = await _dio.post(
      '/api/mobility/delivery-requests/$requestId/bid/',
      data: {
        'agreed_price': agreedPrice,
        if (travelPlanId != null && travelPlanId.isNotEmpty)
          'travel_plan_id': travelPlanId,
      },
    );
    _notifyTaskStateChanged('delivery_bid_submitted');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getMatches() async {
    final response = await _dio.get('/api/mobility/matches/');
    return _extractCollection(response.data);
  }

  Future<Map<String, dynamic>> acceptMatch({
    required String matchId,
  }) async {
    final response = await _dio.post('/api/mobility/matches/$matchId/accept/');
    _notifyTaskStateChanged('match_accepted');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> cancelMatch({
    required String matchId,
    String? reason,
    String? details,
  }) async {
    final response = await _dio.post(
      '/api/mobility/matches/$matchId/cancel/',
      data: {
        if (reason != null && reason.isNotEmpty) 'reason': reason,
        if (details != null && details.isNotEmpty) 'details': details,
      },
    );
    _notifyTaskStateChanged('match_cancelled');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> submitTaskReport({
    required String matchId,
    required String reason,
    String? details,
  }) async {
    final response = await _dio.post(
      '/api/mobility/matches/$matchId/report/',
      data: {
        'reason': reason,
        if (details != null && details.isNotEmpty) 'details': details,
      },
    );
    _notifyTaskStateChanged('task_report_submitted');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getMatchMessages({
    required String matchId,
  }) async {
    final response = await _dio.get('/api/mobility/matches/$matchId/messages/');
    return _extractCollection(response.data);
  }

  Future<Map<String, dynamic>> sendMatchMessage({
    required String matchId,
    required String body,
  }) async {
    final response = await _dio.post(
      '/api/mobility/matches/$matchId/messages/',
      data: {
        'body': body,
      },
    );
    _notifyTaskStateChanged('task_message_sent');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> submitMatchReview({
    required String matchId,
    required int rating,
    String? comment,
    List<String>? tags,
  }) async {
    final response = await _dio.post(
      '/api/mobility/matches/$matchId/review/',
      data: {
        'rating': rating,
        'comment': comment ?? '',
        'tags': tags ?? const <String>[],
      },
    );
    _notifyTaskStateChanged('match_review_submitted');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> confirmDeliveryPickup({
    required String matchId,
    required String verificationCode,
  }) async {
    final response = await _dio.post(
      '/api/mobility/matches/$matchId/confirm_pickup/',
      data: {
        'verification_code': verificationCode,
      },
    );
    _notifyTaskStateChanged('delivery_pickup_confirmed');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> confirmDeliveryDropoff({
    required String matchId,
    required String verificationCode,
  }) async {
    final response = await _dio.post(
      '/api/mobility/matches/$matchId/confirm_delivery/',
      data: {
        'verification_code': verificationCode,
      },
    );
    _notifyTaskStateChanged('delivery_dropoff_confirmed');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> startRideTrip({
    required String matchId,
  }) async {
    final response =
        await _dio.post('/api/mobility/matches/$matchId/start_ride/');
    _notifyTaskStateChanged('ride_started');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> endRideTrip({
    required String matchId,
  }) async {
    final response =
        await _dio.post('/api/mobility/matches/$matchId/end_ride/');
    _notifyTaskStateChanged('ride_ended');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getTrackingSessions() async {
    final response = await _dio.get('/api/mobility/tracking-sessions/');
    return _extractCollection(response.data);
  }

  Future<Map<String, dynamic>> createEmergencyAlert({
    String? travelPlanId,
    double? latitude,
    double? longitude,
    String? message,
  }) async {
    final response = await _dio.post(
      '/api/mobility/emergency-alerts/',
      data: {
        if (travelPlanId != null && travelPlanId.isNotEmpty)
          'travel_plan': travelPlanId,
        if (latitude != null) 'latitude': _roundCoordinate(latitude),
        if (longitude != null) 'longitude': _roundCoordinate(longitude),
        'message': message ?? 'Emergency alert triggered by user.',
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  String extractErrorMessage(Object error) {
    return AuthSessionService.extractErrorMessage(error);
  }
}
