import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet_model.dart';

final walletApiServiceProvider = Provider<WalletApiService>((ref) {
  return WalletApiService();
});

class WalletApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage;
  final String baseUrl = 'https://demosystem.pythonanywhere.com';

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
        throw Exception('Failed to fetch wallet data: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Wallet data fetch error: ${e.response?.data['detail'] ?? e.message}');
    }
  }
}
