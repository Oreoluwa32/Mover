class Constants {
  // Paystack API Endpoints - Customers
  static const String createCustomer = 'https://api.paystack.co/customer';
  static const String listCustomers = 'https://api.paystack.co/customer';
  static String fetchCustomer(String emailOrCode) => 'https://api.paystack.co/customer/$emailOrCode';
  static String updateCustomer(String code) => 'https://api.paystack.co/customer/$code';

  // Paystack API Endpoints - Transactions
  static const initTransactions = 'https://api.paystack.co/transaction/initialize';
  static String verifyTransaction(String reference) => 'https://api.paystack.co/transaction/verify/$reference';
  static const listTransactions = 'https://api.paystack.co/transaction';

  // default values
  static const String currentCustomer = 'current_customer';
  static const String transaction = 'transaction';

  // Google Maps and Places API Keys
  // These should be provided via --dart-define or --dart-define-from-file
  // See: https://developer.android.com/studio/build/secrets-gradle-plugin
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static const String googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY',
    defaultValue: String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: ''),
  );
}