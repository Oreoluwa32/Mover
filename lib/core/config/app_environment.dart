class AppEnvironment {
  static const String environment = String.fromEnvironment(
    'MOVR_ENVIRONMENT',
    defaultValue: 'development',
  );

  static const String _rawApiBaseUrl = String.fromEnvironment(
    'MOVR_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String _rawWsBaseUrl = String.fromEnvironment(
    'MOVR_WS_BASE_URL',
    defaultValue: 'ws://10.0.2.2:8000',
  );

  static const String _rawPaystackPublicKey = String.fromEnvironment(
    'PAYSTACK_PUBLIC_KEY',
    defaultValue: 'pk_test_your_public_key_here',
  );

  // OAuth 2.0 Web client ID. When set, GoogleSignIn requests an ID token
  // with this client ID as the audience so the Movr backend can verify it
  // via /api/v1/auth/google-signin/.
  static const String _rawGoogleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  static final String apiBaseUrl = _normalizeBaseUrl(_rawApiBaseUrl);

  static final String wsBaseUrl = _normalizeBaseUrl(_rawWsBaseUrl);

  static final String paystackPublicKey = _sanitize(_rawPaystackPublicKey);

  static final String googleServerClientId =
      _sanitize(_rawGoogleServerClientId);

  static String _normalizeBaseUrl(String value) {
    final sanitized = _sanitize(value);
    if (sanitized.isEmpty) {
      return value;
    }
    return sanitized.endsWith('/')
        ? sanitized.substring(0, sanitized.length - 1)
        : sanitized;
  }

  static String _sanitize(String value) {
    final trimmed = value.trim();
    if (trimmed.length >= 2 &&
        ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
            (trimmed.startsWith("'") && trimmed.endsWith("'")))) {
      return trimmed.substring(1, trimmed.length - 1).trim();
    }
    return trimmed;
  }
}
