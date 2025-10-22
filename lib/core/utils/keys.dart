class Keys {
  // ✅ PUBLIC KEY ONLY - Safe to expose in frontend
  // Get your public key from: https://dashboard.paystack.com/#/settings/developer
  static const String paystackPublicKey = 'pk_test_YOUR_PAYSTACK_PUBLIC_KEY';
  
  // 🔒 BACKEND API - Backend has the SECRET KEY in its .env file
  // Update this with your actual backend URL:
  // - Development: http://localhost:3000
  // - Production: https://your-api.com
  static const String backendBaseUrl = 'http://localhost:3000'; // Change to your backend URL
  
  // NOTE: NEVER add secret keys here! Secret keys stay in backend .env only
}