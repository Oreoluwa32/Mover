import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_project/core/utils/keys.dart';
import '../models/monnify_auth_response.dart';

/// MonnifyServices - Frontend should NEVER touch Monnify secret keys
/// 🔒 SECURITY: All sensitive operations (initialization, verification) must go through the backend
/// Backend keeps the secret key in its .env file - NOT exposed to frontend
class MonnifyServices {
  /// Backend endpoint that handles Monnify transaction initialization
  /// The backend has Monnify secret key in its environment variables
  static const String _backendMonnifyInitEndpoint = '/api/v1/merchant/transactions/init-transaction';
  static const String _backendMonnifyVerifyEndpoint = '/api/v1/merchant/transactions/verify';

  /// Initialize transaction by calling BACKEND endpoint (NOT Monnify directly)
  /// 
  /// The backend will:
  /// 1. Receive amount, email, reference from frontend
  /// 2. Use its secret key to initialize transaction with Monnify
  /// 3. Return the payment URL to frontend
  /// 4. Frontend loads URL in WebView for user to complete payment
  /// 
  /// ⚠️ NEVER make direct Monnify API calls from frontend!
  Future<MonnifyAuthResponse> initializeTransaction({
    required String amount,
    required String email,
    String currency = 'NGN',
    required String reference,
    String? customerName,
  }) async {
    final String url = '${Keys.backendBaseUrl}$_backendMonnifyInitEndpoint';
    
    final data = {
      'amount': amount,
      'email': email,
      'currency': currency,
      'reference': reference,
      if (customerName != null) 'customerName': customerName,
    };

    try {
      print('🔵 Monnify: Calling backend at: $url');
      print('🔵 Monnify: Request data: $data');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // Optional: Add auth token if your backend requires it
          // 'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(data),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw 'Request timeout - backend not responding',
      );

      print('🔵 Monnify: Response status: ${response.statusCode}');
      print('🔵 Monnify: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('🔵 Monnify: Parsed response: $jsonResponse');
        return MonnifyAuthResponse.fromJson(jsonResponse);
      } else {
        throw ('Failed to initialize transaction: ${response.statusCode} ${response.reasonPhrase} - ${response.body}');
      }
    } on Exception catch (e) {
      print('❌ Monnify Error: $e');
      throw ('An error occurred while initializing the transaction: $e');
    }
  }

  /// Get payment URL - Initialize transaction and return the payment URL for WebView
  /// 
  /// Process:
  /// 1. Calls backend endpoint with payment details
  /// 2. Backend initializes transaction with Monnify using secret key
  /// 3. Backend returns payment URL to frontend
  /// 4. Frontend loads URL in WebView
  Future<String> getPaymentUrl({
    required String amount,
    required String email,
    String currency = 'NGN',
    required String reference,
    String? customerName,
  }) async {
    try {
      final response = await initializeTransaction(
        amount: amount,
        email: email,
        currency: currency,
        reference: reference,
        customerName: customerName,
      );
      return response.paymentUrl ?? '';
    } on Exception catch (e) {
      throw ('Failed to get payment URL: $e');
    }
  }

  /// Verify transaction by calling BACKEND endpoint
  /// 
  /// 🔒 SECURITY: Frontend should NOT verify transactions directly
  /// The backend will:
  /// 1. Receive transaction reference from frontend
  /// 2. Call Monnify API with its secret key to verify
  /// 3. Return verification result to frontend
  /// 
  /// This ensures transaction verification is done securely on the backend
  Future<bool> verifyTransaction(String reference) async {
    final String url = '${Keys.backendBaseUrl}$_backendMonnifyVerifyEndpoint/$reference';

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
        return jsonResponse['status'] == true;
      } else {
        throw ('Failed to verify transaction: ${response.reasonPhrase}');
      }
    } on Exception catch (e) {
      throw ('An error occurred while verifying the transaction: $e');
    }
  }
}
