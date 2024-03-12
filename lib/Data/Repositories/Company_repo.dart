import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/Companymodel.dart';

class CompanyRepository {
  Future<List<Companymodel>> fetchVehicles() async {
    try {
      final response = await Dio().get('http://localhost:8081/travelease/Company');
      List<Companymodel> company = (response.data as List<dynamic>).map((companyData) {
        return Companymodel(
          Companyid: companyData['company_id'].toString(),
          Companyname: companyData['company_name'].toString(),
          Companyemail: companyData['company_email'].toString(),
          Companyphone: companyData['company_phone'].toString(),
          Companystart: companyData['company_start_date'].toString(),
          Companyend: companyData['company_end_date'].toString(),
          Companypoc: companyData['company_poc'].toString(),
          Companycreatedat: companyData['company_created_at'].toString(),
          status: companyData['company_is_active'],

        );
      }).toList();

      // Sort the list by vehicle id in ascending order
      company.sort((a, b) => int.parse(a.Companyid).compareTo(int.parse(b.Companyid)));

      return company;
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }

  // Future<void> removeVehicleAccess(String vehicleNumber) async {
  //   try {
  //     await Dio().delete(
  //       'http://localhost:8081/travelease/Vehicle',
  //       data: vehicleNumber,
  //     );
  //   } catch (error) {
  //     print('Error removing vehicle access: $error');
  //   }
  // }
}
