import 'dart:html';
import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Loginmodel.dart';

class UserRepository {
  final Dio _dio = Dio();
  static const String tokenKey = 'auth_token'; // Define the key for the token in local storage
  static const String roleKey = 'user_role'; // Define the key for the user role in local storage

  // Function to save the token and role in local storage
  static void saveTokenAndRoleToLocalStorage(String token, String role) {
    window.localStorage[tokenKey] = token; // Save the token in local storage
    window.localStorage[roleKey] = role; // Save the role in local storage
  }

  // Function to retrieve the token from local storage
  static String? getTokenFromLocalStorage() {
    return window.localStorage[tokenKey];
  }

  // Function to retrieve the user role from local storage
  static String? getRoleFromLocalStorage() {
    return window.localStorage[roleKey];
  }

  Future<bool> login(UserModel user) async {
    try {
      const String apiUrl = '${ApiConstants.baseUrl}/AdminLogin';

      final response = await _dio.post(
        apiUrl,
        data: {
          "email": user.username,
          "password": user.password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final role = response.data['role'];
        if (token != null && token.isNotEmpty && role != null && role.isNotEmpty) {
          saveTokenAndRoleToLocalStorage(token, role); // Save the token and role in local storage
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
