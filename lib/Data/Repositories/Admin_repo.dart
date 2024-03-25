import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Admin.dart';


class AdminRepository {
  Future<List<Admin>> fetchAdmins() async {
    try {
      final response = await Dio().get('${ApiConstants.baseUrl}/Admin');

      List<Admin> admins = (response.data as List<dynamic>).map((userData) {
        return Admin(
          adminid: userData['admin_id'].toString(),
          admin_name: userData['admin_name'].toString(),
          phoneNumber: userData['admin_phone'].toString(),
          email: userData['admin_email'].toString(),
          status: userData['admin_is_active']
        );
      }).toList();

      admins.sort((a, b) => a.adminid.compareTo(b.adminid));
      return admins;
    } catch (error) {
      print('Error fetching admins: $error');
      return [];
    }
  }
}
