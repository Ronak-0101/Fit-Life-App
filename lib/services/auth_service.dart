import 'dart:convert';

import 'package:fit_life_app_/models/user.dart';
import 'package:fit_life_app_/services/api_service.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:fit_life_app_/utils/storage.dart';
// import 'api_service.dart';

class AuthService {
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
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Save token and user data
        final token = responseData['token'];
        final userData = responseData['user'];

        await StorageService.saveToken(token);
        await StorageService.saveUserData(
          userId: userData['id'],
          email: userData['email'],
          name: userData['name'],
        );

        return {
          'success': true,
          'message': 'Login Successfull',
          'user': User.fromJson(userData)
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
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

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData['success'] == true) {
        return {
          'success': true,
          'message': 'Registration Successfull',
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration Failed',
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
  static Future<void> logout() {
    return StorageService.clearAll();
  }
}
