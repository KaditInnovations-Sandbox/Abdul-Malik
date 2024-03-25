import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/AddCompany.dart';
import 'package:universal_html/html.dart' as html;

class CompanyRepository {
  final Dio _dio = Dio();

  Future<void> addCompany(Company company) async {
    try {
      const String apiUrl = '${ApiConstants.baseUrl}/Company';
      final Map<String, dynamic> data = {
        'company_name': company.Companyname,
        'company_email': company.Companyemail,
        'company_phone': company.Companyphone,
        'company_poc': company.Companypoc,
        'company_start_date': company.Companystart,
        'company_end_date': company.Companyend,
      };
      await _dio.post(apiUrl, data: data);
    } catch (e) {
      print('Error adding Company: $e');
      rethrow;
    }
  }

  // Future<void> uploadFile(html.File file) async {
  //   try {
  //     if (file != null) {
  //       final reader = html.FileReader();
  //       reader.readAsArrayBuffer(file);
  //
  //       reader.onLoadEnd.listen((event) async {
  //         final arrayBuffer = reader.result as html.ArrayBuffer;
  //         final formData = FormData.fromMap({
  //           'file': MultipartFile.fromBytes(
  //             arrayBuffer.asUint8List(),
  //             filename: file.name,
  //           ),
  //         });
  //
  //         const String fileUploadUrl = '${ApiConstants.baseUrl}/uploadFile';
  //         await _dio.post(fileUploadUrl, data: formData);
  //       });
  //     }
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //     rethrow;
  //   }
  // }
}
