import 'package:shared_preferences/shared_preferences.dart';

// ignore for file: must  be immutable
class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  // Will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try{
      return _sharedPreferences!.getString('themeData')!;
    }
    catch(e) {
      return 'primary';
    }
  }

  // Profile image path storage methods
  Future<void> setProfileImagePath(String path) {
    return _sharedPreferences!.setString('profileImagePath', path);
  }

  Future<String?> getProfileImagePath() async {
    try {
      return _sharedPreferences!.getString('profileImagePath');
    } catch (e) {
      return null;
    }
  }

  Future<void> clearProfileImagePath() {
    return _sharedPreferences!.remove('profileImagePath');
  }

  Future<void> setOnboardingCompleted(bool completed) {
    return _sharedPreferences!.setBool('onboardingCompleted', completed);
  }

  Future<bool> getOnboardingCompleted() async {
    try {
      return _sharedPreferences!.getBool('onboardingCompleted') ?? false;
    } catch (e) {
      return false;
    }
  }
}