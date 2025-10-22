import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_project/core/utils/keys.dart';
import '../models/paystack_auth_response.dart';
import '../../models/api_response.dart';
import '../models/transactions.dart';

/// PaystackServices - Frontend should NEVER touch Paystack secret keys
/// 🔒 SECURITY: All sensitive operations (initialization, verification) must go through the backend
/// Backend keeps the secret key in its .env file - NOT exposed to frontend
class PaystackServices {
  /// Backend endpoint that handles transaction initialization
  /// The backend has Paystack secret key in its environment variables
  static const String _backendPaystackInitEndpoint = '/api/paystack/initialize-transaction';
  static const String _backendPaystackVerifyEndpoint = '/api/paystack/verify-transaction';

  /// Initialize transaction by calling BACKEND endpoint (NOT Paystack directly)
  /// 
  /// The backend will:
  /// 1. Receive amount, email, reference from frontend
  /// 2. Use its secret key to initialize transaction with Paystack
  /// 3. Return the authorization URL to frontend
  /// 4. Frontend loads URL in WebView for user to complete payment
  /// 
  /// ⚠️ NEVER make direct Paystack API calls from frontend!
  Future<PaystackAuthResponse> initializeTransaction({
    required String amount,
    required String email,
    String currency = 'NGN',
    required String reference,
    List<String> channels = const ["card", "bank", "bank_transfer"],
  }) async {
    final String url = '${Keys.backendBaseUrl}$_backendPaystackInitEndpoint';
    
    final data = {
      'amount': amount,
      'email': email,
      'currency': currency,
      'reference': reference,
      'channels': channels,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // Optional: Add auth token if your backend requires it
          // 'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return PaystackAuthResponse.fromJson(jsonResponse['data']);
      } else {
        throw ('Failed to initialize transaction: ${response.reasonPhrase}');
      }
    } on Exception catch (e) {
      throw ('An error occurred while initializing the transaction: $e');
    }
  }

  /// Get payment URL - Initialize transaction and return the authorization URL for WebView
  /// 
  /// Process:
  /// 1. Calls backend endpoint with payment details
  /// 2. Backend initializes transaction with Paystack using secret key
  /// 3. Backend returns authorization URL to frontend
  /// 4. Frontend loads URL in WebView
  Future<String> getPaymentUrl({
    required String amount,
    required String email,
    String currency = 'NGN',
    required String reference,
    List<String> channels = const ["card", "bank", "bank_transfer"],
  }) async {
    try {
      final response = await initializeTransaction(
        amount: amount,
        email: email,
        currency: currency,
        reference: reference,
        channels: channels,
      );
      return response.authorizationUrl ?? '';
    } on Exception catch (e) {
      throw ('Failed to get payment URL: $e');
    }
  }

  /// Verify transaction by calling BACKEND endpoint
  /// 
  /// 🔒 SECURITY: Frontend should NOT verify transactions directly
  /// The backend will:
  /// 1. Receive transaction reference from frontend
  /// 2. Call Paystack API with its secret key to verify
  /// 3. Return verification result to frontend
  /// 
  /// This ensures transaction verification is done securely on the backend
  Future<Transactions> verifyTransaction(String reference) async {
    final String url = '${Keys.backendBaseUrl}$_backendPaystackVerifyEndpoint/$reference';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // Optional: Add auth token if your backend requires it
          // 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          return Transactions.fromJson(jsonResponse['data']);
        } else {
          throw ('Transaction verification failed: ${jsonResponse['message']}');
        }
      } else {
        throw ('Failed to verify transaction: ${response.reasonPhrase}');
      }
    } on Exception catch (e) {
      throw ('An error occurred while verifying the transaction: $e');
    }
  }
}