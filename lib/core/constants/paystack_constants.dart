/// Paystack configuration constants
class PaystackConstants {
  // Public key for Paystack (available in your Paystack dashboard)
  // For production: use pk_live_xxx
  // For testing: use pk_test_xxx
  static const String publicKey = 'pk_test_your_public_key_here';

  // Backend API base URL
  static const String apiBaseUrl = 'http://localhost:8000/api/v1';
  // For production, change to your production server:
  // static const String apiBaseUrl = 'https://your-production-api.com/api/v1';

  // Paystack API endpoints
  static const String paystackApiUrl = 'https://api.paystack.co';

  // Payment-related constants
  static const String currencyCode = 'NGN';

  // Payment channels (payment methods available)
  static const List<String> paymentChannels = [
    'card',
    'bank',
    'bank_transfer',
    'ussd',
    'qr',
    'eft',
  ];

  // Subscription plans
  static const Map<String, dynamic> subscriptionPlans = {
    'basic': {
      'name': 'Basic',
      'amount': 500.0,
      'period': 'monthly',
      'features': ['Access to basic features'],
    },
    'rover': {
      'name': 'Rover',
      'amount': 2500.0,
      'period': 'monthly',
      'features': ['Enhanced features', 'Priority support'],
    },
    'courier': {
      'name': 'Courier',
      'amount': 5000.0,
      'period': 'monthly',
      'features': ['All features', 'Premium support'],
    },
    'courier_plus': {
      'name': 'Courier Plus',
      'amount': 10000.0,
      'period': 'monthly',
      'features': ['All features', '24/7 support', 'Analytics'],
    },
  };

  // Timeout durations (in seconds)
  static const int requestTimeoutSeconds = 30;
  static const int connectionTimeoutSeconds = 10;

  // Storage keys for Flutter Secure Storage
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUserEmail = 'user_email';
  static const String storageKeyWalletBalance = 'wallet_balance';
}