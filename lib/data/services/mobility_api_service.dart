import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movr/core/config/app_environment.dart';

class MobilityApiService {
  MobilityApiService({
    String? customBaseUrl,
    FlutterSecureStorage? storage,
  })  : _baseUrl = customBaseUrl ?? AppEnvironment.apiBaseUrl,
        _storage = storage ?? const FlutterSecureStorage() {
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
      ),
    );
  }

  final String _baseUrl;
  final FlutterSecureStorage _storage;
  late final Dio _dio;

  double _roundCoordinate(double value) {
    return double.parse(value.toStringAsFixed(6));
  }

  List<Map<String, dynamic>> _extractCollection(dynamic data) {
    if (data is List) {
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  Future<List<Map<String, dynamic>>> getMyTravelPlans() async {
    final response = await _dio.get('/api/mobility/travel-plans/', queryParameters: {
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
        if (destination != null && destination.isNotEmpty) 'destination': destination,
        if (planType != null && planType.isNotEmpty && planType != 'hybrid')
          'plan_type': planType,
        if (date != null && date.isNotEmpty) 'date': date,
      },
    );
    return _extractCollection(response.data);
  }

  Future<Map<String, dynamic>?> getLatestTravelPlan() async {
    final plans = await getMyTravelPlans();
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
        if (originLatitude != null) 'origin_latitude': _roundCoordinate(originLatitude),
        if (originLongitude != null) 'origin_longitude': _roundCoordinate(originLongitude),
        'destination_name': destinationName,
        if (destinationLatitude != null)
          'destination_latitude': _roundCoordinate(destinationLatitude),
        if (destinationLongitude != null)
          'destination_longitude': _roundCoordinate(destinationLongitude),
        'departure_time': departureTime.toUtc().toIso8601String(),
        if (arrivalTime != null) 'arrival_time': arrivalTime.toUtc().toIso8601String(),
        if (vehicleType != null && vehicleType.isNotEmpty) 'vehicle_type': vehicleType,
        'seats_available': seatsAvailable ?? 1,
        'price_per_seat': pricePerSeat ?? 0,
        'package_capacity_kg': packageCapacityKg ?? 0,
        'status': status ?? 'published',
        'metadata': metadata ?? <String, dynamic>{},
      },
    );
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
        if (originLatitude != null) 'origin_latitude': _roundCoordinate(originLatitude),
        if (originLongitude != null) 'origin_longitude': _roundCoordinate(originLongitude),
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
        if (pickupLatitude != null) 'pickup_latitude': _roundCoordinate(pickupLatitude),
        if (pickupLongitude != null) 'pickup_longitude': _roundCoordinate(pickupLongitude),
        'dropoff_name': dropoffName,
        if (dropoffLatitude != null) 'dropoff_latitude': _roundCoordinate(dropoffLatitude),
        if (dropoffLongitude != null) 'dropoff_longitude': _roundCoordinate(dropoffLongitude),
        'scheduled_time': scheduledTime.toUtc().toIso8601String(),
        'package_description': packageDescription,
        'weight_kg': weightKg,
        'insured_value': insuredValue,
        'insurance_opted': insuranceOpted,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getRideRequests() async {
    final response = await _dio.get('/api/mobility/ride-requests/');
    return _extractCollection(response.data);
  }

  Future<List<Map<String, dynamic>>> getDeliveryRequests() async {
    final response = await _dio.get('/api/mobility/delivery-requests/');
    return _extractCollection(response.data);
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
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getMatches() async {
    final response = await _dio.get('/api/mobility/matches/');
    return _extractCollection(response.data);
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
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final detail = data['detail']?.toString();
        if (detail != null && detail.isNotEmpty) {
          return detail;
        }
        if (data.entries.isNotEmpty) {
          final value = data.entries.first.value;
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
          if (value != null) {
            return value.toString();
          }
        }
      }
      return error.message ?? 'Request failed.';
    }
    return error.toString();
  }
}
