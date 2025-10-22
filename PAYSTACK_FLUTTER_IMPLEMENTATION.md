# Paystack Flutter Implementation Guide

## Overview
This guide provides step-by-step instructions for integrating Paystack payments in the Movr Flutter app.

---

## 1. Update Dependencies

### Step 1.1: Update pubspec.yaml

Add the Paystack Flutter package:

```yaml
dependencies:
  flutter_paystack: ^1.5.1
  dio: ^5.8.0
  flutter_riverpod: ^2.5.1
```

Then run:
```bash
flutter pub get
```

---

## 2. Configuration

### Step 2.1: Create Paystack Constants

**File**: `lib/core/constants/paystack_constants.dart` (NEW)

```dart
class PaystackConstants {
  // Use your actual public key from https://dashboard.paystack.com
  static const String publicKey = 'pk_test_your_key_here';
  
  // Test keys for development
  static const String testPublicKey = 'pk_test_your_test_key';
  
  // API endpoints
  static const String apiBaseUrl = 'https://your-backend-url/api/v1';
  
  // Paystack API
  static const String paystackApiUrl = 'https://api.paystack.co';
}
```

### Step 2.2: Create API Configuration

**File**: `lib/data/services/paystack_api_service.dart` (NEW)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaystackApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final String baseUrl;

  PaystackApiService({
    required this.baseUrl,
  })  : _dio = Dio(),
        _storage = const FlutterSecureStorage();

  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Initialize a payment
  Future<Map<String, dynamic>> initializePayment({
    required double amount,
    required String description,
    required String relatedType,
  }) async {
    try {
      final token = await _getAuthToken();
      final response = await _dio.post(
        '$baseUrl/payments/initialize',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
        data: {
          'amount': amount,
          'description': description,
          'related_type': relatedType,
        },
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Verify a payment
  Future<Map<String, dynamic>> verifyPayment({
    required String reference,
  }) async {
    try {
      final token = await _getAuthToken();
      final response = await _dio.post(
        '$baseUrl/payments/verify',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
        data: {
          'reference': reference,
        },
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get wallet balance
  Future<Map<String, dynamic>> getWalletBalance() async {
    try {
      final token = await _getAuthToken();
      final response = await _dio.get(
        '$baseUrl/payments/wallet/balance',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get transaction history
  Future<Map<String, dynamic>> getTransactionHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final token = await _getAuthToken();
      final response = await _dio.get(
        '$baseUrl/payments/transactions',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
```

---

## 3. Enhanced Paystack Service

### Step 3.1: Update Paystack Services

**File**: `lib/services/paystack_services.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_paystack/flutter_paystack.dart';
import '../core/utils/keys.dart';

class PaystackServices {
  static final PaystackPlugin _paystackPlugin = PaystackPlugin();
  static const String _publicKey = 'pk_test_your_key_here';

  /// Initialize Paystack
  static Future<void> initialize() async {
    _paystackPlugin.initialize(publicKey: _publicKey);
  }

  /// Charge card with access code
  static Future<ChargeResponse?> chargeCard({
    required String accessCode,
    required String email,
    required String amount,
    Map<String, String>? metadata,
  }) async {
    try {
      final charge = Charge()
        ..accessCode = accessCode
        ..reference = _generateReference()
        ..email = email
        ..amount = (double.parse(amount) * 100).toInt();

      if (metadata != null) {
        charge.metadata = metadata;
      }

      final response = await _paystackPlugin.chargeCard(
        context: null, // Context handled differently
        charge: charge,
      );

      return response;
    } catch (e) {
      print('Error charging card: $e');
      return null;
    }
  }

  /// Verify transaction
  static Future<Map<String, dynamic>> verifyTransaction(
    String reference,
  ) async {
    const String url = 'https://api.paystack.co/transaction/verify';

    try {
      final response = await http.get(
        Uri.parse('$url/$reference'),
        headers: {
          'Authorization': 'Bearer ${Keys.secretKey}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to verify transaction: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Verification error: $e');
      rethrow;
    }
  }

  /// Generate unique reference
  static String _generateReference() {
    return 'movr_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Format amount for display
  static String formatAmount(double amount) {
    return '₦${amount.toStringAsFixed(2)}';
  }
}
```

---

## 4. Riverpod State Management

### Step 4.1: Create Wallet State Notifier

**File**: `lib/presentation/wallet/notifier/wallet_notifier.dart` (NEW)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/paystack_api_service.dart';

class WalletState {
  final double balance;
  final bool isLoading;
  final String? error;

  WalletState({
    this.balance = 0.0,
    this.isLoading = false,
    this.error,
  });

  WalletState copyWith({
    double? balance,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final PaystackApiService apiService;

  WalletNotifier({required this.apiService})
      : super(const WalletState());

  Future<void> fetchWalletBalance() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.getWalletBalance();
      final balance = (response['balance'] as num).toDouble();

      state = state.copyWith(balance: balance, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshBalance() async {
    await fetchWalletBalance();
  }
}

final walletNotifierProvider =
    StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final apiService = ref.watch(paystackApiServiceProvider);
  return WalletNotifier(apiService: apiService);
});

final paystackApiServiceProvider = Provider<PaystackApiService>((ref) {
  return PaystackApiService(
    baseUrl: 'https://your-backend-url/api/v1',
  );
});
```

### Step 4.2: Create Payment State Notifier

**File**: `lib/presentation/wallet/notifier/payment_notifier.dart` (NEW)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/paystack_api_service.dart';

class PaymentState {
  final String? reference;
  final String? authorizationUrl;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  PaymentState({
    this.reference,
    this.authorizationUrl,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  PaymentState copyWith({
    String? reference,
    String? authorizationUrl,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return PaymentState(
      reference: reference ?? this.reference,
      authorizationUrl: authorizationUrl ?? this.authorizationUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaystackApiService apiService;

  PaymentNotifier({required this.apiService})
      : super(const PaymentState());

  Future<bool> initializePayment({
    required double amount,
    required String description,
    required String relatedType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.initializePayment(
        amount: amount,
        description: description,
        relatedType: relatedType,
      );

      if (response['status'] == true) {
        final data = response['data'] ?? {};
        state = state.copyWith(
          reference: data['reference'],
          authorizationUrl: data['authorization_url'],
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Failed to initialize payment',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> verifyPayment(String reference) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.verifyPayment(reference: reference);

      if (response['status'] == true &&
          response['data']?['status'] == 'success') {
        state = state.copyWith(
          isLoading: false,
          successMessage:
              '₦${response['data']?['amount']} added to your wallet',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Payment verification failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void clearState() {
    state = const PaymentState();
  }
}

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final apiService = ref.watch(paystackApiServiceProvider);
  return PaymentNotifier(apiService: apiService);
});
```

---

## 5. Update Deposit Screen

### Step 5.1: Update Deposit Bottom Sheet

**File**: `lib/presentation/deposit_bottomsheet/deposit_bottomsheet.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/app_export.dart';
import '../wallet/notifier/payment_notifier.dart';

class DepositBottomsheet extends ConsumerStatefulWidget {
  final double amount;

  const DepositBottomsheet({
    Key? key,
    this.amount = 5000,
  }) : super(key: key);

  @override
  ConsumerState<DepositBottomsheet> createState() =>
      _DepositBottomsheetState();
}

class _DepositBottomsheetState extends ConsumerState<DepositBottomsheet> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    final notifier = ref.read(paymentNotifierProvider.notifier);
    final success = await notifier.initializePayment(
      amount: widget.amount,
      description: 'Wallet Funding',
      relatedType: 'wallet',
    );

    if (success) {
      final state = ref.read(paymentNotifierProvider);
      _loadPaymentUrl(state.authorizationUrl ?? '');
    }
  }

  void _loadPaymentUrl(String url) {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains('reference=')) {
              _handlePaymentCallback(url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void _handlePaymentCallback(String url) async {
    final uri = Uri.parse(url);
    final reference = uri.queryParameters['reference'];

    if (reference != null) {
      final notifier = ref.read(paymentNotifierProvider.notifier);
      final verified = await notifier.verifyPayment(reference);

      if (verified) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('Payment verification failed');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your wallet has been funded successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottomsheet
              // Refresh wallet balance
              ref.refresh(walletNotifierProvider);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Complete Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: paymentState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : paymentState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(paymentState.error!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _initializePayment,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : paymentState.authorizationUrl != null
                        ? WebViewWidget(
                            controller: _webViewController,
                          )
                        : const Center(
                            child: Text('Initializing payment...'),
                          ),
          ),
        ],
      ),
    );
  }
}
```

---

## 6. Update Select Plan Screen

### Step 6.1: Add Payment Integration

**File**: `lib/presentation/select_plan_screen/select_plan_screen.dart`

Key changes:
- Add Paystack integration on plan selection
- Show payment loading state
- Handle payment verification

```dart
// Add this to handle plan payment
Future<void> _selectPlan(int planIndex) async {
  final notifier = ref.read(paymentNotifierProvider.notifier);
  
  final planPrices = [500, 2500, 5000, 10000]; // Prices in NGN
  final planNames = ['Basic', 'Rover', 'Courier', 'Courier Plus'];
  
  final success = await notifier.initializePayment(
    amount: planPrices[planIndex].toDouble(),
    description: 'Subscription: ${planNames[planIndex]} Plan',
    relatedType: 'subscription',
  );

  if (success && mounted) {
    // Show payment dialog
    _showPaymentDialog(ref, planNames[planIndex]);
  }
}
```

---

## 7. Testing

### Step 7.1: Test Paystack Transactions

Use these test credentials:

**Test Card**: 4111111111111111
**Expiry**: Any future date (e.g., 12/25)
**CVV**: 123
**OTP**: 123456

### Step 7.2: Test Scenarios

1. **Successful Payment**:
   - Use test card above
   - Complete OTP verification
   - Verify wallet is credited

2. **Failed Payment**:
   - Use invalid card details
   - Verify error message is shown

3. **Wallet Verification**:
   - Check wallet balance after successful payment
   - Verify transaction history is updated

---

## 8. Production Checklist

- [ ] Update to Paystack LIVE keys (pk_live_..., sk_live_...)
- [ ] Update backend URL to production
- [ ] Test end-to-end payment flow
- [ ] Configure webhook URL in Paystack dashboard
- [ ] Enable SSL certificate pinning (optional, for security)
- [ ] Test all payment scenarios in staging
- [ ] Monitor Paystack dashboard for transactions
- [ ] Set up error tracking (Sentry, etc.)

---

## 9. Common Issues & Solutions

### Issue: "Invalid Public Key"
**Solution**: Ensure you're using the correct test key from Paystack dashboard

### Issue: Payment redirect loop
**Solution**: Check that your backend API is correctly configured and accessible

### Issue: Wallet not updating
**Solution**: Verify webhook is configured and backend is processing verification

---

## 10. Useful Links

- **Paystack Dashboard**: https://dashboard.paystack.com
- **Paystack API Docs**: https://paystack.com/docs/api/
- **Flutter Paystack Package**: https://pub.dev/packages/flutter_paystack
- **WebView Widget**: https://pub.dev/packages/webview_flutter