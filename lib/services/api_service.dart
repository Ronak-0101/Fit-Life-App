import 'dart:convert';

import 'package:fit_life_app_/utils/constants.dart';
import 'package:fit_life_app_/utils/storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base header for all request
  static Map<String, String> getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type' : 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // Make GET request
  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool includeAuth = true, 
    }) async {
      try {
        Uri uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
        if(queryParams != null ) {
          uri = uri.replace(queryParameters: queryParams);
        }

        return await http.get(
          uri,
          headers: getHeaders(includeAuth: includeAuth)
        );
      } catch(e) {
        rethrow;
      }
    }

  // Make POST request
  static Future<http.Response> post (
    String endpint, {
      dynamic body,
      bool includeAuth = true,
    }) async {
      try {
        return await http.post(
          Uri.parse('${AppConstants.baseUrl}$endpint'),
          headers: getHeaders(includeAuth: includeAuth),
          body: body != null ? jsonEncode(body) : null,
        );
      } catch(r) {
        rethrow;
      }
    }


  // Make PUT request
  static Future<http.Response> put(
    String endpoint, {
      dynamic body,
      bool includeAuth = true,
    }) async {
      try{
        return await http.put(
          Uri.parse('${AppConstants.baseUrl}$endpoint'),
          headers: getHeaders(includeAuth: includeAuth),
          body: body != null ? jsonEncode(body) : null,
        );
      } catch (e) {
        rethrow;
      }
    }

  // Make a DELETE request 
  static Future<http.Response> delete(
    String endpoint, {
      bool includeAuth = true,
    }) async {
      try{
        return await http.delete(
          Uri.parse('${AppConstants.baseUrl}$endpoint'),
          headers: getHeaders(includeAuth: includeAuth),
        );
      } catch (e) {
        rethrow;
      }
    }

  // Health check
  static Future<bool> healthcheck() async{
    try {
      final response = await get(AppConstants.healthEndpoint,
      includeAuth: false
      );
      return response.statusCode == 200;
    }catch(e) {
      return false;
    }
  }
}