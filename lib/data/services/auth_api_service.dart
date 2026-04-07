import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movr/core/config/app_environment.dart';
import 'package:movr/core/utils/pref_utils.dart';

class AuthApiService {
  AuthApiService({
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
  }

  final String _baseUrl;
  final FlutterSecureStorage _storage;
  late final Dio _dio;

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String firstName = '',
    String lastName = '',
    String accountType = 'both',
  }) async {
    final response = await _dio.post(
      '/api/auth/register/',
      data: {
        'email': email.trim(),
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'account_type': accountType,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/api/auth/login/',
      data: {
        'email': email.trim(),
        'password': password,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> persistSession(Map<String, dynamic> authPayload) async {
    final tokens = (authPayload['tokens'] as Map?)?.cast<String, dynamic>() ?? {};
    final user = (authPayload['user'] as Map?)?.cast<String, dynamic>() ?? {};

    final accessToken = tokens['access']?.toString();
    final refreshToken = tokens['refresh']?.toString();
    final email = user['email']?.toString();
    final firstName = user['first_name']?.toString() ?? '';
    final lastName = user['last_name']?.toString() ?? '';
    final fullName = '$firstName $lastName'.trim();

    if (accessToken != null && accessToken.isNotEmpty) {
      await _storage.write(key: 'auth_token', value: accessToken);
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
    if (email != null && email.isNotEmpty) {
      await _storage.write(key: 'user_email', value: email);
    }
    if (fullName.isNotEmpty) {
      await _storage.write(key: 'user_name', value: fullName);
    }

    await PrefUtils().setOnboardingCompleted(true);
  }

  String extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final detail = data['detail']?.toString();
        if (detail != null && detail.isNotEmpty) {
          return detail;
        }
        final message = data['message']?.toString();
        if (message != null && message.isNotEmpty) {
          return message;
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
