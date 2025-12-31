import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/paystack_constants.dart';

/// Service for handling Paystack-related API calls to the backend
class PaystackApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage;
  final String baseUrl;

  PaystackApiService({
    String? customBaseUrl,
  })  : baseUrl = customBaseUrl ?? PaystackConstants.apiBaseUrl,
        _storage = const FlutterSecureStorage() {
    _initializeDio();
  }

  /// Initialize Dio with default settings
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(
          seconds: PaystackConstants.connectionTimeoutSeconds,
        ),
        receiveTimeout: Duration(
          seconds: PaystackConstants.requestTimeoutSeconds,
        ),
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
    return await _storage.read(
      key: PaystackConstants.storageKeyAuthToken,
    );
  }

  /// Initialize a payment transaction
  /// 
  /// Request body:
  /// - amount: double (payment amount in NGN)
  /// - description: string (payment description)
  /// - related_type: string (subscription, deposit, etc.)
  Future<Map<String, dynamic>> initializePayment({
    required double amount,
    required String description,
    required String relatedType,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/initialize',
        data: {
          'amount': amount,
          'description': description,
          'related_type': relatedType,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
          'Failed to initialize payment: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Payment initialization error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  /// Verify a payment transaction
  /// 
  /// Request body:
  /// - reference: string (unique payment reference)
  Future<Map<String, dynamic>> verifyPayment({
    required String reference,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/verify',
        data: {
          'reference': reference,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to verify payment: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Payment verification error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  /// Get wallet balance
  Future<Map<String, dynamic>> getWalletBalance() async {
    try {
      final response = await _dio.get('/payments/wallet/balance');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to fetch wallet balance: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Wallet balance error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  /// Get transaction history
  /// 
  /// Query parameters:
  /// - limit: int (number of transactions, default: 50)
  /// - offset: int (pagination offset, default: 0)
  Future<Map<String, dynamic>> getTransactionHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/payments/transactions',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to fetch transactions: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Transaction history error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  /// Get list of supported banks
  Future<Map<String, dynamic>> getBanks() async {
    try {
      final response = await _dio.get('/payments/banks');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to fetch banks: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Banks fetch error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  /// Initialize withdrawal process
  /// 
  /// Request body:
  /// - amount: double (withdrawal amount)
  /// - account_number: string (beneficiary account)
  /// - bank_code: string (bank code)
  /// - account_name: string (account holder name)
  Future<Map<String, dynamic>> initializeWithdrawal({
    required double amount,
    required String accountNumber,
    required String bankCode,
    required String accountName,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/withdrawal/initialize',
        data: {
          'amount': amount,
          'account_number': accountNumber,
          'bank_code': bankCode,
          'account_name': accountName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
          'Failed to initialize withdrawal: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Withdrawal initialization error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  /// Complete withdrawal transfer
  /// 
  /// Request body:
  /// - reference: string (withdrawal reference)
  Future<Map<String, dynamic>> completeWithdrawal({
    required String reference,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/withdrawal/complete',
        data: {
          'reference': reference,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to complete withdrawal: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Withdrawal completion error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}