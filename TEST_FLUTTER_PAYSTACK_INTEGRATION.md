# Flutter Paystack Integration Testing Guide

## Step 1: Install Dependencies

Run this command in your Flutter project directory:

```bash
flutter pub get
```

This will install `flutter_paystack` and all other dependencies.

---

## Step 2: Update Your Paystack Public Key

Edit `lib/core/constants/paystack_constants.dart` and replace the public key:

```dart
static const String publicKey = 'pk_test_your_actual_key_here';
```

Get your key from: https://dashboard.paystack.com → Settings → API Keys

---

## Step 3: Update Backend API URL

If you're testing with a real backend, update:

```dart
static const String apiBaseUrl = 'http://localhost:8000/api/v1';
// Or for production:
// static const String apiBaseUrl = 'https://your-api-domain.com/api/v1';
```

---

## Step 4: Test Wallet Balance (Simple Widget)

Create a simple test widget to fetch wallet balance:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_project/presentation/wallet/notifier/wallet_notifier.dart';

class WalletTestWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Wallet Balance')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (walletState.isLoading)
              CircularProgressIndicator()
            else if (walletState.error != null)
              Text(
                'Error: ${walletState.error}',
                style: TextStyle(color: Colors.red),
              )
            else
              Column(
                children: [
                  Text(
                    '₦${walletState.balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(walletNotifierProvider.notifier)
                          .fetchWalletBalance();
                    },
                    child: Text('Refresh Balance'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## Step 5: Test Payment Flow (Complete Example)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_project/presentation/wallet/notifier/payment_notifier.dart';

class PaymentTestWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<PaymentTestWidget> createState() => _PaymentTestWidgetState();
}

class _PaymentTestWidgetState extends ConsumerState<PaymentTestWidget> {
  final amountController = TextEditingController(text: '500');

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _testPaymentFlow() async {
    final notifier = ref.read(paymentNotifierProvider.notifier);
    final amount = double.tryParse(amountController.text) ?? 500.0;

    // Step 1: Initialize payment
    final initialized = await notifier.initializePayment(
      amount: amount,
      description: 'Test Payment',
      relatedType: 'test',
    );

    if (!initialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize payment')),
      );
      return;
    }

    final state = ref.read(paymentNotifierProvider);

    if (state.authorizationUrl != null) {
      // Step 2: Open payment URL
      try {
        await launchUrl(Uri.parse(state.authorizationUrl!));

        // Step 3: After user completes payment, verify it
        await Future.delayed(Duration(seconds: 3));
        if (state.reference != null) {
          await notifier.verifyPayment(reference: state.reference!);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Test Payment')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (NGN)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            if (paymentState.isInitializing)
              CircularProgressIndicator()
            else if (paymentState.error != null)
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Error: ${paymentState.error}',
                  style: TextStyle(color: Colors.red),
                ),
              )
            else if (paymentState.isPaymentSuccessful)
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  '✓ Payment Successful!',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              )
            else
              ElevatedButton(
                onPressed: _testPaymentFlow,
                child: Text('Test Payment'),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## Step 6: Add Test Routes to Your App

Add these to your main navigation for testing:

```dart
// In your main.dart or routes
import 'package:new_project/test_wallet_widget.dart';
import 'package:new_project/test_payment_widget.dart';

// Then in your route handler or navigation:
route('/test/wallet', (_) => WalletTestWidget()),
route('/test/payment', (_) => PaymentTestWidget()),
```

---

## Step 7: Integration Test Checklist

Run through these tests in order:

### 7.1 Test Backend Connection
- [ ] Start backend: `uvicorn app.main:app --reload`
- [ ] Check API is running on `http://localhost:8000`
- [ ] Test endpoint: `GET /api/v1/payments/wallet/balance`

### 7.2 Test Flutter Package Setup
- [ ] Run `flutter pub get` successfully
- [ ] No import errors in IDE
- [ ] paystack_constants.dart compiles
- [ ] paystack_api_service.dart compiles

### 7.3 Test Wallet Display
- [ ] Navigate to wallet test screen
- [ ] If loading shows, backend might be down
- [ ] If error shows, check API token/authentication
- [ ] If balance shows (even 0), ✅ Successful!

### 7.4 Test Payment Initialization
- [ ] Click "Test Payment" button
- [ ] Should show loading
- [ ] If payment URL opens, initialization worked ✅
- [ ] If error, check backend logs

### 7.5 Test Complete Payment Flow
- [ ] Use test card: `4111 1111 1111 1111`
- [ ] Expiry: `12/25`
- [ ] CVV: `123`
- [ ] Complete payment
- [ ] Check if verification message shows

---

## Step 8: Update Deposit Screen (Real Implementation)

Once testing passes, update your existing deposit screen:

```dart
// In your deposit_screen.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_project/presentation/wallet/notifier/payment_notifier.dart';

class DepositScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  Future<void> _makeDeposit(double amount) async {
    final notifier = ref.read(paymentNotifierProvider.notifier);
    
    final success = await notifier.initializePayment(
      amount: amount,
      description: 'Wallet Deposit',
      relatedType: 'deposit',
    );

    if (success) {
      final state = ref.read(paymentNotifierProvider);
      // Navigate to payment URL or show Paystack UI
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your deposit UI here
    return Scaffold();
  }
}
```

---

## Troubleshooting

### "ModuleNotFoundError: No module named 'flutter_paystack'"
- Run `flutter pub get`
- Make sure pubspec.yaml has the dependency

### "Connection refused" error
- Make sure backend is running
- Check API URL in constants

### "Unauthorized" (401) error
- User might not be logged in
- Token might be expired
- Check secure storage has valid token

### "PAYSTACK_PUBLIC_KEY not configured"
- Update the public key in `paystack_constants.dart`
- Get key from Paystack dashboard

---

## Next Steps

1. ✅ Complete all test checklist items
2. → Integrate with existing deposit/plan screens
3. → Test on real device
4. → Deploy to production with live keys

---

## Useful Links

- **Flutter Paystack Docs**: https://pub.dev/packages/flutter_paystack
- **Paystack Dashboard**: https://dashboard.paystack.com
- **Test Cards**: https://paystack.com/docs/payments/test-transactions/
- **Dio Documentation**: https://pub.dev/packages/dio
- **Riverpod Documentation**: https://riverpod.dev