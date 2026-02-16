import 'package:fit_life_app_/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  static Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.authTokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(AppConstants.authTokenKey);
  }

  static Future<void> clearToken() async {
    await _prefs.remove(AppConstants.authTokenKey);
  }

  //User Data
  static Future<void> saveUserData({
    required String userId,
    required String email,
    required String name,
  }) async {
    await _prefs.setString(AppConstants.userIdKey, userId);
    await _prefs.setString(AppConstants.userEmailKey, email);
    await _prefs.setString(AppConstants.userNameKey, name);
  }

  static Map<String, String> getUserData() {
    return {
      'userId': _prefs.getString(AppConstants.userIdKey) ?? '',
      'email': _prefs.getString(AppConstants.userEmailKey) ?? '',
      'name': _prefs.getString(AppConstants.userNameKey) ?? '',
    };
  }

  // Check if logged in
  static bool isLoggedIn() {
    return getToken() != null && getToken()!.isNotEmpty;
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
