import 'package:dio/dio.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Removedvehicle.dart';


class RemovedVehicleRepository {
  final Dio _dio = Dio();

  Future<List<RemovedVehicle>> fetchRemovedVehicles() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/InactiveVehicle');

      final List<RemovedVehicle> vehicles = (response.data as List<dynamic>).map((vehicleData) {
        return RemovedVehicle(
          vehicleid: vehicleData['vehicle_id'].toString(),
          vehiclecapacity: vehicleData['vehicle_capacity'].toString(),
          vehiclenumber: vehicleData['vehicle_number'].toString(),
          registered: vehicleData['vehicle_registered'].toString(),
        );
      }).toList();

      return vehicles;
    } catch (error) {
      throw Exception('Failed to fetch removed vehicles: $error');
    }
  }

  Future<void> removeVehicleAccess(String vehiclenumber) async {
    try {
      final response = await _dio.put(
        'http://localhost:8081/travelease/BindVehicle',
        data: vehiclenumber,
      );
      if (response.statusCode == 200) {
        print('Vehicle access removed successfully');
      } else {
        throw Exception('Failed to remove vehicle access');
      }
    } catch (error) {
      throw Exception('Error removing vehicle access: $error');
    }
  }
}
