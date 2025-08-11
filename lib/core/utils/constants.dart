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

  // Google Maps API Key
  static const String GOOGLE_MAPS_API_KEY = 'AIzaSyAjeXxdRtBbs59HGHsjRko3xr1PQivmMVo';
}