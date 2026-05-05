import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movr/core/config/app_environment.dart';
import 'package:movr/core/utils/pref_utils.dart';
import 'package:movr/data/services/auth_session_service.dart';
import 'package:path/path.dart' as path;

class AccountApiService {
  AccountApiService({
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

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/api/accounts/me/');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get('/api/accounts/profile/');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Map<String, dynamic>? linkedSocials,
    String? avatarUrl,
    String? avatarFilePath,
  }) async {
    final payload = <String, dynamic>{
      if (firstName != null) 'first_name': firstName.trim(),
      if (lastName != null) 'last_name': lastName.trim(),
      if (phoneNumber != null) 'phone_number': phoneNumber.trim(),
      if (linkedSocials != null) 'linked_socials': linkedSocials,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };

    final hasAvatarFile =
        avatarFilePath != null && avatarFilePath.trim().isNotEmpty;
    final response = await _dio.put(
      '/api/accounts/profile/',
      data: hasAvatarFile
          ? FormData.fromMap({
              ...payload,
              'avatar': await MultipartFile.fromFile(
                avatarFilePath,
                filename: path.basename(avatarFilePath),
              ),
            })
          : payload,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getKyc() async {
    final response = await _dio.get('/api/accounts/kyc/');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updateKyc({
    required String nin,
    required String bvn,
  }) async {
    final response = await _dio.put(
      '/api/accounts/kyc/',
      data: {
        'nin': nin.trim(),
        'bvn': bvn.trim(),
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getVehicles() async {
    final response = await _dio.get('/api/accounts/vehicles/');
    final data = response.data;
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

  Future<Map<String, dynamic>> createVehicle({
    required String vehicleType,
    required String make,
    required String model,
    required String color,
    required String plateNumber,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _dio.post(
      '/api/accounts/vehicles/',
      data: {
        'vehicle_type': vehicleType,
        'make': make,
        'model': model,
        'color': color,
        'plate_number': plateNumber.trim(),
        'metadata': metadata ?? <String, dynamic>{},
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updateVehicle({
    required String vehicleId,
    required String vehicleType,
    required String make,
    required String model,
    required String color,
    required String plateNumber,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _dio.patch(
      '/api/accounts/vehicles/$vehicleId/',
      data: {
        'vehicle_type': vehicleType,
        'make': make,
        'model': model,
        'color': color,
        'plate_number': plateNumber.trim(),
        'metadata': metadata ?? <String, dynamic>{},
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> hydrateSessionFromMe() async {
    final me = await getMe();
    final user = (me['user'] as Map?)?.cast<String, dynamic>() ?? {};
    final profile = (me['profile'] as Map?)?.cast<String, dynamic>() ?? {};

    final firstName = user['first_name']?.toString() ?? '';
    final lastName = user['last_name']?.toString() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final email = user['email']?.toString();
    final avatarUrl = profile['avatar_url']?.toString();

    if (email != null && email.isNotEmpty) {
      await _storage.write(key: 'user_email', value: email);
    }
    final displayName = fullName.isNotEmpty ? fullName : email;
    if (displayName != null && displayName.isNotEmpty) {
      await _storage.write(key: 'user_name', value: displayName);
    }
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      await PrefUtils().setProfileImagePath(avatarUrl);
    }
  }

  Future<void> clearSession() async {
    await _sessionService.clearSession();
  }

  String extractErrorMessage(Object error) {
    return AuthSessionService.extractErrorMessage(error);
  }
}
