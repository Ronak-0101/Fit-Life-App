import 'dart:convert';

import 'package:fit_life_app_/models/user.dart';
import 'package:fit_life_app_/services/api_service.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:fit_life_app_/utils/storage.dart';
// import 'api_service.dart';

class AuthService {
  static Map<String, dynamic> _parseResponseBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    } catch (_) {
      return {'raw': body};
    }
  }

  static String? _findString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      return _findString(nestedData, keys);
    }

    return null;
  }

  static Map<String, dynamic>? _findUserData(Map<String, dynamic> data) {
    final user = data['user'];
    if (user is Map<String, dynamic>) {
      return user;
    }

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      final nestedUser = nestedData['user'];
      if (nestedUser is Map<String, dynamic>) {
        return nestedUser;
      }

      if (nestedData.containsKey('email') || nestedData.containsKey('name')) {
        return nestedData;
      }
    }

    return null;
  }

  // Login User
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        AppConstants.loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );
      // final responseData = jsonDecode(response.body);
      final responseData = _parseResponseBody(response.body);

      final isSuccessStatus =
          response.statusCode >= 200 && response.statusCode < 300;
      final isSuccessFlag = responseData['success'] != false;

      if (isSuccessStatus && isSuccessFlag) {
        // Save token and user data
        final token = _findString(
          responseData,
          ['token', 'accessToken', 'access_token', 'jwt'],
        );
        final userData = _findUserData(responseData);

        if (token == null) {
          return {
            'success': false,
            'message': 'Login succeeded but no auth token was returned',
          };
        }

        await StorageService.saveToken(token);

        if (userData != null) {
          await StorageService.saveUserData(
            userId: (userData['_id'] ?? userData['id'] ?? '').toString(),
            email: (userData['email'] ?? email).toString(),
            name: (userData['name'] ?? '').toString(),
          );
        }

        return {
          'success': true,
          'message': responseData['message'] ?? 'Login successful',
          'user': userData == null ? null : User.fromJson(userData),
        };
      } else {
        final fallback = responseData['raw']?.toString();
        return {
          'success': false,
          'message': responseData['message'] ?? fallback ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Register user
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await ApiService.post(
        AppConstants.registerEndpoint,
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
        includeAuth: false,
      );

      // final responseData = jsonDecode(response.body);
      final responseData = _parseResponseBody(response.body);
      final isSuccessStatus =
          response.statusCode >= 200 && response.statusCode < 300;
      final isSuccessFlag = responseData['success'] != false;

      if (isSuccessStatus && isSuccessFlag) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration Successfull',
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        final fallback = responseData['raw']?.toString();
        return {
          'success': false,
          'message':
              responseData['message'] ?? fallback ?? 'Registration Failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network Error : ${e.toString()}',
      };
    }
  }

  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await ApiService.get(AppConstants.currentUserEndpoint);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'user': User.fromJson(responseData['user']),
        };
      } else {
        return {'success': false, 'message': 'Failed to fetch user'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network Error ${e.toString()}',
      };
    }
  }

  // Check is user is logged in
  static bool isLoggedIn() {
    return StorageService.isLoggedIn();
  }

  // Logout
  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await ApiService.post(
        AppConstants.logoutEndpoint,
        includeAuth: true,
      );

      final responseData = _parseResponseBody(response.body);
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      await StorageService.clearAll();

      return {
        'success': isSuccess,
        'message': responseData['message'] ?? 'Logged out successfully',
      };
    } catch (e) {
      await StorageService.clearAll();
      return {
        'success': false,
        'message': 'Logged out locally. Network error: ${e.toString()}',
      };
    }
  }
}
