class AppEnvironment {
  static const String environment = String.fromEnvironment(
    'MOVR_ENVIRONMENT',
    defaultValue: 'development',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'MOVR_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'MOVR_WS_BASE_URL',
    defaultValue: 'ws://10.0.2.2:8000',
  );

  static const String paystackPublicKey = String.fromEnvironment(
    'PAYSTACK_PUBLIC_KEY',
    defaultValue: 'pk_test_your_public_key_here',
  );
}
