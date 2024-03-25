import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';

import 'package:tec_admin/Data/Models/Passenger_model.dart';


class PassengerRepository {

  Future<List<Passenger>> fetchPassengers(String companyid) async {
    try {
      final response = await Dio().get('${ApiConstants.baseUrl}/CompanyBasedPassenger?companyid=$companyid');

      List<Passenger> Passengers = (response.data as List<dynamic>).map((userData) {
        return Passenger(
            passengerid: userData['passenger_id'].toString(),
            passenger_name: userData['passenger_name'].toString(),
            passenger_email: userData['passenger_email'].toString(),
            phoneNumber: userData['passenger_phone'].toString(),
            passenger_location: userData['passenger_location'].toString(),
            created: userData['passenger_created_at'].toString(),
            status: userData['passenger_is_active']
        );
      }).toList();

      Passengers.sort((a, b) => a.passengerid.compareTo(b.passengerid));
      return Passengers;
    } catch (error) {
      print('Error fetching Passengers: $error');
      return [];
    }
  }
}