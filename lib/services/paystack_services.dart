import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_project/core/utils/keys.dart';
import '../models/paystack_auth_response.dart';
import '../../models/api_response.dart';
import '../models/transactions.dart';

class PaystackServices {
  // final ApiService _apiService = ApiService();

  // Initialize Paystack services here, such as API endpoints, headers, etc.
  // Future<PaystackAuthResponse> initializeTransaction(Transactions transactions) async {
  //   // Call the Paystack API to initialize a transaction
  //   // final response = await http.post(
  //   //   Uri.parse('https://api.paystack.co/transaction/initialize'),
  //   //   headers: {
  //   //     'Content-Type': 'application/json',
  //   //   },
  //   // );
  //   const String url = 'https://api.paystack.co/transaction/initialize';
  //   final data = transactions.toJson();

  //   try{
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(data),
  //     );
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       return PaystackAuthResponse.fromJson(jsonResponse['data']);
  //     } else {
  //       throw ('Failed to initialize transaction: ${response.reasonPhrase}');
  //     }
  //   }
  //   on Exception {
  //     throw ('An error occurred while initializing the transaction');
  //   }
  // }

  Future<PaystackAuthResponse> initializeTransaction({
    required String amount,
    required String email,
    String currency = 'NGN',
    required String reference,
    List<String> channels = const ["card", "bank", "bank_transfer"],
  }) async {
    const String url = 'https://api.paystack.co/transaction/initialize';
    final data = {
      'amount': (double.parse(amount) * 100).toInt(), // Convert to kobo
      'email': email,
      'currency': currency,
      'reference': reference,
      'channels': channels,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': Keys.secretKey,
          'Content-Type': 'application/json',
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

  // Verify the transaction using the reference
  Future verifyTransaction(String reference, Function(Object) onSuccessfulTransaction, Function(Object) onFailedTransaction) async {
    final String url = 'https://api.paystack.co/transaction/verify/$reference';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer YOUR_SECRET_KEY',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['gateway_response'] == 'Successful') {
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