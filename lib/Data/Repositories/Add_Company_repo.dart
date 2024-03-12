import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/AddCompany.dart';


class CompanyRepository {
  final Dio _dio = Dio();

  Future<void> addCompany(Company Company) async {
    try {
      const String apiUrl = 'http://localhost:8081/travelease/Company';
      final Map<String, dynamic> data = {
        'company_name': Company.Companyname,
        'company_email': Company.Companyemail,
        'company_phone':Company.Companyphone,
        'company_poc':Company.Companypoc,
        'company_start_date':Company.Companystart,
        'company_end_date':Company.Companyend,

      };
      await _dio.post(apiUrl, data: data);
    } catch (e) {
      print('Error adding Company: $e');
      rethrow;
    }
  }
}