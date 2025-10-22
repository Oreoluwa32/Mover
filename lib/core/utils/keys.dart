class Keys {
  // ✅ PUBLIC KEY ONLY - Safe to expose in frontend
  // Get your public key from: https://dashboard.paystack.com/#/settings/developer
  static const String paystackPublicKey = 'pk_test_66ad6e65718f66ad859ccb4155fb499eb07f3c36';
  
  // 🔒 BACKEND API - Backend has the SECRET KEY in its .env file
  // Production deployment on Render
  static const String backendBaseUrl = 'https://movr-api.onrender.com';
  
  // NOTE: NEVER add secret keys here! Secret keys stay in backend .env only
}