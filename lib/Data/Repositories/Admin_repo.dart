import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/Admin.dart';


class AdminRepository {
  Future<List<Admin>> fetchAdmins() async {
    try {
      final response = await Dio().get('http://localhost:8081/travelease/Admin');

      List<Admin> admins = (response.data as List<dynamic>).map((userData) {
        return Admin(
          firstName: userData['admin_first_name'].toString(),
          lastName: userData['admin_last_name'].toString(),
          admin_name: userData['admin_name'].toString(),
          phoneNumber: userData['admin_phone'].toString(),
          email: userData['admin_email'].toString(),
        );
      }).toList();

      admins.sort((a, b) => a.admin_name.compareTo(b.admin_name));
      return admins;
    } catch (error) {
      print('Error fetching admins: $error');
      return [];
    }
  }

// Add methods for other operations like adding, editing, removing admins, etc.
}
