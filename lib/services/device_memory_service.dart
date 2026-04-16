import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service to manage device memory (storing login state and user data)
class DeviceMemoryService {
  static const String _deviceRememberedKey = 'device_remembered';
  static const String _userEmailKey = 'user_email';
  static const String _lastLoginTimeKey = 'last_login_time';

  static final DeviceMemoryService _instance = DeviceMemoryService._internal();

  factory DeviceMemoryService() {
    return _instance;
  }

  DeviceMemoryService._internal();

  late SharedPreferences _prefs;
  final _secureStorage = const FlutterSecureStorage();

  /// Initialize the service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Mark device as remembered after successful login
  /// This stores:
  /// - Device remembered flag
  /// - User email
  /// - Last login time
  Future<void> rememberDevice({
    required String userEmail,
  }) async {
    await _prefs.setBool(_deviceRememberedKey, true);
    await _prefs.setString(_userEmailKey, userEmail);
    await _prefs.setString(
      _lastLoginTimeKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// Check if device is remembered and user has valid token
  Future<bool> isDeviceRemembered() async {
    final isRemembered = _prefs.getBool(_deviceRememberedKey) ?? false;
    if (!isRemembered) return false;

    return hasAuthToken();
  }

  /// Strict auth guard for the app.
  /// If the token is gone, clear any remembered-device flags so startup
  /// never treats the user as still logged in.
  Future<bool> syncSessionState() async {
    final hasToken = await hasAuthToken();
    if (!hasToken) {
      await _prefs.remove(_deviceRememberedKey);
      await _prefs.remove(_userEmailKey);
      await _prefs.remove(_lastLoginTimeKey);
    }
    return hasToken;
  }

  Future<bool> hasAuthToken() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }

  /// Get remembered user email
  Future<String?> getRememberedUserEmail() async {
    return _prefs.getString(_userEmailKey);
  }

  /// Get last login time
  Future<DateTime?> getLastLoginTime() async {
    final timeString = _prefs.getString(_lastLoginTimeKey);
    if (timeString == null) return null;
    return DateTime.tryParse(timeString);
  }

  /// Forget device (logout)
  /// This clears all stored device memory and token
  Future<void> forgetDevice() async {
    await _prefs.remove(_deviceRememberedKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_lastLoginTimeKey);
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  /// Clear all device memory
  Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }

  /// Check if session is still valid (optional: can add session timeout logic)
  /// For now, as long as token exists, session is valid
  Future<bool> isSessionValid() async {
    return hasAuthToken();
  }
}
