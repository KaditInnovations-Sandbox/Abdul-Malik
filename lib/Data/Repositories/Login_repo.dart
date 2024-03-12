import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/Loginmodel.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<bool> login(UserModel user) async {
    try {
      const String apiUrl = 'http://localhost:8081/travelease/AdminLogin';

      final response = await _dio.post(
        apiUrl,
        data: {
          "token":"eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJhYmR1bC5tYWxpa0BrYWRpdGlubm92YXRpb25zLmNvbSIsImlhdCI6MTcxMDIyODQzOSwiZXhwIjoxNzEyODIwNDM5fQ.vhqAma5LXfsKN9cK9S--deSTAwGI9JflS1ILBS3e6NuVxywraQm9UL1LWqIz3eHe6xZTSM1A8-LL5X4md7sTZg",
          "email": user.username,
          "password": user.password,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
