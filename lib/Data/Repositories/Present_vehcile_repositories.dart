import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';


class PresentVehicleRepository {
  Future<List<PresentVehicle>> fetchVehicles() async {
    try {
      final response = await Dio().get('http://localhost:8081/travelease/ActiveVehicle');
      return (response.data as List<dynamic>).map((vehicleData) {
        return PresentVehicle(
          vehicleid: vehicleData['vehicle_id'].toString(),
          vehiclecapacity: vehicleData['vehicle_capacity'].toString(),
          vehiclenumber: vehicleData['vehicle_number'].toString(),
          registeded: vehicleData['vehicle_registered'].toString(),
        );
      }).toList();
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }

  Future<void> removeVehicleAccess(String vehicleNumber) async {
    try {
      await Dio().delete(
        'http://localhost:8081/travelease/Vehicle',
        data: vehicleNumber,
      );
    } catch (error) {
      print('Error removing vehicle access: $error');
    }
  }
}
