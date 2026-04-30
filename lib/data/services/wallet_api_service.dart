import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movr/core/config/app_environment.dart';
import '../models/wallet_model.dart';

final walletApiServiceProvider = Provider<WalletApiService>((ref) {
  return WalletApiService();
});

class WalletApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage;
  final String baseUrl = AppEnvironment.apiBaseUrl;

  WalletApiService() : _storage = const FlutterSecureStorage() {
    _initializeDio();
  }

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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<WalletModel> fetchWalletData() async {
    try {
      final response = await _dio.get('/wallet/');
      if (response.statusCode == 200) {
        return WalletModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch wallet data: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Wallet data fetch error: ${e.response?.data['detail'] ?? e.message}');
    }
  }

  Future<WalletFundingAccount?> fetchFundingAccount() async {
    try {
      final response = await _dio.get('/api/payments/wallet/funding-account');
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data['data'] as Map<String, dynamic>?
            : null;
        if (data == null) {
          return null;
        }
        return WalletFundingAccount.fromJson(data);
      }
      throw Exception(
          'Failed to fetch funding account: ${response.statusMessage}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['detail'] ??
              e.response?.data['message'] ??
              e.message)
          : e.message;
      throw Exception('Funding account error: $message');
    }
  }

  Future<WalletFundingAccount> provisionFundingAccount() async {
    try {
      final response = await _dio.post('/api/payments/wallet/funding-account');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data is Map<String, dynamic>
            ? response.data['data'] as Map<String, dynamic>?
            : null;
        if (data == null) {
          throw Exception(
              'Funding account details are missing from the response.');
        }
        return WalletFundingAccount.fromJson(data);
      }
      throw Exception(
          'Failed to create funding account: ${response.statusMessage}');
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        final missingRequirements = responseData['missing_requirements'];
        if (missingRequirements is List && missingRequirements.isNotEmpty) {
          throw Exception(responseData['detail'] ??
              'Complete your KYC before creating a funding account.');
        }
        throw Exception(
            responseData['detail'] ?? responseData['message'] ?? e.message);
      }
      throw Exception('Funding account creation error: ${e.message}');
    }
  }
}
