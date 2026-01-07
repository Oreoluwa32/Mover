import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling user-related API calls to the backend
class UserApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage;
  final String baseUrl;

  UserApiService({
    String? customBaseUrl,
  })  : baseUrl = customBaseUrl ?? 'http://localhost:8000',
        _storage = const FlutterSecureStorage() {
    _initializeDio();
  }

  /// Initialize Dio with default settings
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
      ),
    );
  }

  /// Get stored authentication token
  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Toggle user's live status (location sharing)
  /// 
  /// Parameters:
  /// - routeId: String (the route ID to toggle)
  /// - isLive: bool (true to enable, false to disable)
  /// 
  /// Response:
  /// - status: bool (true if successful)
  /// - message: string (notification message)
  /// - is_live: bool (current live status)
  Future<Map<String, dynamic>> toggleLiveStatus({
    required String routeId,
    required bool isLive,
  }) async {
    try {
      final response = await _dio.post(
        '/toggle-is-live/$routeId/',
        data: {
          'is_live': isLive,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
          'Failed to toggle live status: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Live status toggle error: ${e.response?.data['detail'] ?? e.message}',
      );
    }
  }

  /// Get user's current live status
  /// 
  /// Response:
  /// - status: bool (true if request successful)
  /// - is_live: bool (current live status)
  Future<Map<String, dynamic>> getLiveStatus() async {
    try {
      final response = await _dio.get('/api/v1/user/live-status');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to fetch live status: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Live status fetch error: ${e.response?.data['detail'] ?? e.message}',
      );
    }
  }
}