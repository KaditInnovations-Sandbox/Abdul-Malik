import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/AddaDmin_model.dart';


class AdminRepository {
  final Dio _dio = Dio();

  Future<void> addAdmin(AdminModel admin) async {
    try {
      const String apiUrl = 'http://localhost:8081/travelease/Admin';
      final Map<String, dynamic> adminData = {
        'admin_name': admin.adminName,
        'admin_password': admin.password,
        'admin_email': admin.email,
        'admin_phone': admin.phoneNumber,
        'admin_first_name': admin.firstName,
        'admin_last_name': admin.lastName,
      };
      final Map<String, dynamic> requestBody = {
        'admin': adminData,
        'roleName': admin.rolename,
      };

      final Response response = await _dio.post(
        apiUrl,
        data: requestBody,
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
