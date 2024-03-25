import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Contract_Driver_Model.dart';


class ContractDriverRepository {
  var dio = Dio();

  Future<List<ContractDriver>> fetchContractDrivers() async {
    try {
      var headers = {
        'DriverType': 'Contract',
        'Content-Type': 'application/json'
      };

      var response = await dio.request(
        '${ApiConstants.baseUrl}/GetDriver/Type/{DriverType}',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      List<ContractDriver> ContractDrivers = (response.data as List<dynamic>).map((userData) {
        return ContractDriver(
            ContractDriverid: userData['driver_id'].toString(),
            ContractDriver_name: userData['driver_name'].toString(),
            ContractDriver_email: userData['driver_email'].toString(),
            phoneNumber: userData['driver_phone_number'].toString(),
            created: userData['driver_created_at'].toString(),
            status: userData['driver_is_active']
        );
      }).toList();

      ContractDrivers.sort((a, b) => a.ContractDriverid.compareTo(b.ContractDriverid));
      return ContractDrivers;
    } catch (error) {
      print('Error fetching ContractDrivers: $error');
      return [];
    }
  }
}
