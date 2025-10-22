# WebView Paystack Integration Guide

## Overview
WebView-based Paystack payment integration has been implemented for the Movr Flutter application. This approach uses the Paystack API directly with a secure backend and displays the payment page in a WebView widget.

## Architecture

### Flow
```
Transaction History Screen (Wallet)
        ↓
  Click "Deposit" button
        ↓
Deposit Screen (Plan Selection)
        ↓
Deposit Screen Two (Amount & Email Input)
        ↓
Click "Deposit" button
        ↓
Paystack Payment Screen (WebView)
        ↓
  Payment Completion
        ↓
Back to previous screen
```

## Components Implemented

### 1. **pubspec.yaml**
- Added `webview_flutter: ^4.8.0` for WebView support
- Removed outdated `flutter_paystack` package dependency

### 2. **Payment Screen** (`lib/presentation/paystack_payment_screen/`)
Main WebView payment interface.

**Files:**
- `paystack_payment_screen.dart` - Main screen with WebView widget
- `notifier/paystack_payment_notifier.dart` - State management for payment status
- `notifier/paystack_payment_state.dart` - State class definition

**Key Features:**
- Initializes payment through Paystack API
- Displays payment URL in WebView
- Handles payment success/failure navigation
- Shows loading state during payment initialization
- Displays errors gracefully with retry option

### 3. **Payment Services** (`lib/services/paystack_services.dart`)
Enhanced with new methods:

```dart
// New method for WebView integration
Future<String> getPaymentUrl({
  required String amount,
  required String email,
  String currency = 'NGN',
  required String reference,
  List<String> channels = const ["card", "bank", "bank_transfer"],
}) async
```

### 4. **Deposit Screen Two** (`lib/presentation/deposit_screen_two/`)
Updated to handle payment initiation:

- Collects amount and email from user
- Validates input data
- Generates transaction reference
- Navigates to PaystackPaymentScreen with parameters

### 5. **Routing** (`lib/routes/app_routes.dart`)
- Added `paystackPaymentScreen` route constant
- Implemented `onGenerateRoute()` for handling parameterized routes
- Routes require: `amount`, `email`, `reference`

### 6. **Main Application** (`lib/main.dart`)
- Added `onGenerateRoute` callback to MaterialApp for dynamic route handling

## How It Works

### Step 1: User Initiates Deposit
User clicks "Deposit" button on Transaction History Screen → navigates to Deposit Screen

### Step 2: User Selects Plan and Enters Details
User enters amount and email on Deposit Screen Two

### Step 3: Payment Initialization
When "Deposit" button is pressed:
```dart
1. Validates amount (not empty, valid number)
2. Validates email (not empty, valid format)
3. Generates transaction reference (if not provided)
4. Navigates to PaystackPaymentScreen with:
   - amount: Transaction amount in NGN
   - email: Customer email
   - reference: Unique transaction reference
```

### Step 4: WebView Payment Processing
PaystackPaymentScreen:
```dart
1. Initializes payment via PaystackServices.getPaymentUrl()
2. Shows loading indicator while API call completes
3. Receives authorization URL from Paystack API
4. Loads URL in WebView
5. Monitors URL changes for success/failure
6. Handles payment completion
```

### Step 5: Payment Verification
```dart
// PaystackServices handles verification
Future<String> verifyTransaction(String reference, ...)
```

## Configuration Required

### 1. Paystack API Key
Update `lib/core/utils/keys.dart`:
```dart
class Keys {
  static const String secretKey = 'sk_live_YOUR_LIVE_SECRET_KEY'; // Production
  // For testing: use sk_test_* key
}
```

### 2. Backend Webhook Handler
Ensure your backend is configured to:
- Listen for Paystack webhooks
- Verify transaction status
- Update user wallet balance
- Return success/failure responses

## Usage Flow

### Navigating to Payment Screen
```dart
NavigatorService.pushNamed(
  AppRoutes.paystackPaymentScreen,
  arguments: {
    'amount': '50000', // NGN amount
    'email': 'user@example.com',
    'reference': 'TXN-1234567890',
  },
);
```

### Using PaystackServices
```dart
final paystackServices = PaystackServices();

// Get payment URL for WebView
final paymentUrl = await paystackServices.getPaymentUrl(
  amount: '50000',
  email: 'user@example.com',
  reference: 'TXN-1234567890',
);

// Verify transaction after payment
await paystackServices.verifyTransaction(
  'TXN-1234567890',
  onSuccessfulTransaction: (result) { /* handle success */ },
  onFailedTransaction: (error) { /* handle error */ },
);
```

## State Management

### PaystackPaymentNotifier
Manages payment screen state:
```dart
- paymentUrl: String (Paystack authorization URL)
- isLoading: bool (loading indicator)
- error: String (error message if any)
- paymentSuccessful: bool (payment status)
- reference: String (transaction reference)
```

### Methods:
- `setPaymentUrl(url)` - Set payment URL
- `setLoading(bool)` - Set loading state
- `setError(error)` - Set error message
- `setPaymentSuccessful(successful, reference)` - Mark payment complete
- `resetState()` - Reset all state to initial

## Error Handling

### Validation Errors
- Empty amount → Toast: "Please enter an amount"
- Empty email → Toast: "Please enter your email"
- Invalid email format → Toast: "Please enter a valid email"

### Payment Errors
- API initialization failure → Shows error message with retry button
- WebView loading error → Toast notification with error description
- Network issues → Handled by WebView widget

## Success Handling

1. User completes payment in WebView
2. Paystack redirects to success URL
3. PaystackPaymentScreen detects success
4. Toast notification: "Payment successful!"
5. Auto-navigates back after 1 second
6. Parent screen handles transaction confirmation

## Debugging

### Enable Debug Logging
Add to PaystackPaymentScreen initState:
```dart
// Enable verbose logging
WebViewController.enableDebugging(true);
```

### Test Payment Cards (Paystack Test Mode)
- Card: `4111 1111 1111 1111`
- Expiry: Any future date
- CVV: Any 3 digits
- OTP: `123456`

### Common Issues

| Issue | Solution |
|-------|----------|
| "Failed to initialize payment" | Check API key in Keys class |
| WebView shows blank page | Verify internet connectivity |
| Payment not reflecting | Check backend webhook configuration |
| Reference not generating | Ensure DateTime package is imported |

## Future Enhancements

1. **Payment History Tracking**
   - Store transaction records in local database
   - Sync with backend periodically

2. **Offline Mode**
   - Cache payment URLs temporarily
   - Retry failed payments when online

3. **Multiple Payment Methods**
   - Add more channels (crypto, mobile money)
   - Support installment payments

4. **Analytics Integration**
   - Track payment funnel
   - Monitor conversion rates
   - Log payment events

## Testing Checklist

- [ ] Deposit button navigates to deposit screen
- [ ] Amount and email validation works
- [ ] Invalid email shows error toast
- [ ] Valid inputs navigate to payment screen
- [ ] WebView loads Paystack payment page
- [ ] Test payment completes successfully
- [ ] Success toast appears
- [ ] Navigation back works
- [ ] Error handling displays properly
- [ ] Loading state shows during initialization

## File Structure
```
lib/
├── presentation/
│   ├── paystack_payment_screen/
│   │   ├── notifier/
│   │   │   ├── paystack_payment_notifier.dart
│   │   │   └── paystack_payment_state.dart
│   │   └── paystack_payment_screen.dart
│   ├── deposit_screen_two/
│   │   └── deposit_screen_two.dart (updated)
│   └── transaction_history_screen/
│       └── transaction_history_screen.dart
├── services/
│   └── paystack_services.dart (updated)
├── routes/
│   └── app_routes.dart (updated)
├── main.dart (updated)
└── pubspec.yaml (updated)
```

## API Response Structure
Paystack returns transaction data:
```json
{
  "status": true,
  "message": "Authorization URL created",
  "data": {
    "authorization_url": "https://checkout.paystack.com/...",
    "access_code": "123456",
    "reference": "TXN-1234567890"
  }
}
```

## Security Notes

1. **Secret Key Protection**: Never expose Paystack secret key in frontend code
2. **Backend Verification**: Always verify payment on backend using secret key
3. **HTTPS Only**: Ensure all API calls use HTTPS
4. **Webhook Validation**: Verify webhook signature using Paystack's validation method
5. **PCI Compliance**: Never store full card details in app

## Support & Resources

- [Paystack Documentation](https://paystack.com/docs)
- [Flutter WebView Documentation](https://pub.dev/packages/webview_flutter)
- [Paystack API Reference](https://paystack.com/docs/api)