import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Addadmin_model.dart';

class AdminRepository {
  final Dio _dio = Dio();

  Future<void> addAdmin(AddAdminModel admin) async {
    try {
      const String apiUrl = '${ApiConstants.baseUrl}/Admin';
      final Response response = await _dio.post(
        apiUrl,
        data: admin.toJson(),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
