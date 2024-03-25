import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Sevilai_Driver_Model.dart';


class SevilaiDriverRepository {
  var dio = Dio();

  Future<List<SevilaiDriver>> fetchSevilaiDrivers() async {
    try {
      var headers = {
        'DriverType': 'Sevilai',
        'Content-Type': 'application/json'
      };

      var response = await dio.request(
        '${ApiConstants.baseUrl}/GetDriver/Type/{DriverType}',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      List<SevilaiDriver> SevilaiDrivers = (response.data as List<dynamic>).map((userData) {
        return SevilaiDriver(
            SevilaiDriverid: userData['driver_id'].toString(),
            SevilaiDriver_name: userData['driver_name'].toString(),
            SevilaiDriver_email: userData['driver_email'].toString(),
            phoneNumber: userData['driver_phone_number'].toString(),
            created: userData['driver_created_at'].toString(),
            status: userData['driver_is_active']
        );
      }).toList();

      SevilaiDrivers.sort((a, b) => a.SevilaiDriverid.compareTo(b.SevilaiDriverid));
      return SevilaiDrivers;
    } catch (error) {
      print('Error fetching SevilaiDrivers: $error');
      return [];
    }
  }
}
