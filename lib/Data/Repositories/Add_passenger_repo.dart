import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Add_passenger_model.dart';

class PassengerRepository {
  final Dio _dio = Dio();
  final apiurl ='${ApiConstants.baseUrl}/{companyname}/Passenger';

  Future<void> addPassenger(String companyName, Passenger passenger,) async {
    try {
      var headers = {
        'companyname': companyName,
        'Content-Type': 'application/json',
      };

      var data = {
        "passenger_name": passenger.Passengername,
        "passenger_email": passenger.Passengeremail,
        "passenger_phone": passenger.Passengerphone,
        "passenger_location": passenger.Passengerlocation,
      };

      Response response = await _dio.post(
        '${ApiConstants.baseUrl}/$companyName/Passenger',
        data: data,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 201) {
        print('Passenger added successfully');
      } else {
        print('Failed to add passenger: ${response.statusMessage}');
        print('${companyName}');
        print(data);
        print(apiurl);
      }
    } catch (e) {
      print('Company Name  : ${companyName}');
      print('Error adding Passenger: $e');
      print(apiurl);
      rethrow;
    }
  }
}
