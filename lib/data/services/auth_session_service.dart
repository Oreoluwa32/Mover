import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movr/core/config/app_environment.dart';
import 'package:movr/core/utils/pref_utils.dart';
import 'package:movr/services/device_memory_service.dart';

class AuthSessionService {
  AuthSessionService({
    String? customBaseUrl,
    FlutterSecureStorage? storage,
  })  : _baseUrl = customBaseUrl ?? AppEnvironment.apiBaseUrl,
        _storage = storage ?? const FlutterSecureStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  final String _baseUrl;
  final FlutterSecureStorage _storage;
  late final Dio _dio;

  Future<String?> getAccessToken() async {
    return _storage.read(key: 'auth_token');
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null || refreshToken.isEmpty) {
      await clearSession();
      return null;
    }

    try {
      final response = await _dio.post(
        '/api/auth/refresh/',
        data: {'refresh': refreshToken},
      );
      final data = Map<String, dynamic>.from(response.data as Map);
      final nextAccessToken = data['access']?.toString();
      final nextRefreshToken = data['refresh']?.toString();

      if (nextAccessToken == null || nextAccessToken.isEmpty) {
        await clearSession();
        return null;
      }

      await _storage.write(key: 'auth_token', value: nextAccessToken);
      if (nextRefreshToken != null && nextRefreshToken.isNotEmpty) {
        await _storage.write(key: 'refresh_token', value: nextRefreshToken);
      }

      return nextAccessToken;
    } on DioException catch (error) {
      if (isAuthFailure(error)) {
        await clearSession();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> validateStoredSession() async {
    final accessToken = await getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      await clearSession();
      return false;
    }

    try {
      await _dio.get(
        '/api/accounts/me/',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return true;
    } on DioException catch (error) {
      if (!isAuthFailure(error)) {
        return true;
      }

      final refreshedToken = await refreshAccessToken();
      if (refreshedToken == null || refreshedToken.isEmpty) {
        await clearSession();
        return false;
      }

      try {
        await _dio.get(
          '/api/accounts/me/',
          options: Options(
            headers: {'Authorization': 'Bearer $refreshedToken'},
          ),
        );
        return true;
      } on DioException catch (retryError) {
        if (isAuthFailure(retryError)) {
          await clearSession();
          return false;
        }
        return true;
      }
    } catch (_) {
      return true;
    }
  }

  Future<Response<dynamic>?> retryIfUnauthorized(
    DioException error,
    Dio dio,
  ) async {
    if (!isAuthFailure(error)) {
      return null;
    }
    if (error.requestOptions.extra['authRetried'] == true) {
      await clearSession();
      return null;
    }

    final nextAccessToken = await refreshAccessToken();
    if (nextAccessToken == null || nextAccessToken.isEmpty) {
      await clearSession();
      return null;
    }

    final requestOptions = error.requestOptions;
    requestOptions.headers = Map<String, dynamic>.from(requestOptions.headers);
    requestOptions.extra = Map<String, dynamic>.from(requestOptions.extra);
    requestOptions.headers['Authorization'] = 'Bearer $nextAccessToken';
    requestOptions.extra['authRetried'] = true;

    try {
      return await dio.fetch<dynamic>(requestOptions);
    } on DioException catch (retryError) {
      if (isAuthFailure(retryError)) {
        await clearSession();
      }
      rethrow;
    }
  }

  Future<void> clearSession() async {
    final deviceMemory = DeviceMemoryService();
    await deviceMemory.init();
    await deviceMemory.forgetDevice();
    await PrefUtils().clearProfileImagePath();
  }

  static bool isAuthFailure(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return true;
    }

    final data = error.response?.data;
    if (data is Map) {
      final normalized = Map<String, dynamic>.from(data);
      final code = normalized['code']?.toString().toLowerCase();
      final detail = normalized['detail']?.toString().toLowerCase() ?? '';
      final message = normalized['message']?.toString().toLowerCase() ?? '';

      if (code == 'token_not_valid') {
        return true;
      }
      if (detail.contains('token not valid') ||
          detail.contains('not valid for any token type') ||
          detail.contains('token is invalid') ||
          detail.contains('token is expired') ||
          detail.contains('token has expired') ||
          message.contains('token not valid') ||
          message.contains('not valid for any token type')) {
        return true;
      }
    }

    return false;
  }

  static String extractErrorMessage(
    Object error, {
    String fallback = 'Request failed.',
  }) {
    if (error is DioException) {
      if (isAuthFailure(error)) {
        return 'Session expired. Please sign in again.';
      }

      final data = error.response?.data;
      if (data is Map) {
        final normalized = Map<String, dynamic>.from(data);
        final detail = normalized['detail']?.toString();
        if (detail != null && detail.isNotEmpty) {
          return detail;
        }

        final message = normalized['message']?.toString();
        if (message != null && message.isNotEmpty) {
          return message;
        }

        if (normalized.entries.isNotEmpty) {
          final value = normalized.entries.first.value;
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
          if (value != null && value.toString().isNotEmpty) {
            return value.toString();
          }
        }
      }

      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }

      return error.message ?? fallback;
    }

    return error.toString().isEmpty ? fallback : error.toString();
  }
}
