import 'package:dio/dio.dart';
import 'package:testapp/Data/Models/Removedvehicle.dart';


class RemovedVehicleRepository {
  final Dio _dio = Dio();

  Future<List<RemovedVehicle>> fetchRemovedVehicles() async {
    try {
      final response = await _dio.get('http://localhost:8081/travelease/InactiveVehicle');

      final List<RemovedVehicle> vehicles = (response.data as List<dynamic>).map((vehicleData) {
        return RemovedVehicle(
          vehicleId: vehicleData['vehicle_id'].toString(),
          vehicleCapacity: vehicleData['vehicle_capacity'].toString(),
          vehicleNumber: vehicleData['vehicle_number'].toString(),
          registered: vehicleData['vehicle_registered'].toString(),
        );
      }).toList();

      return vehicles;
    } catch (error) {
      throw Exception('Failed to fetch removed vehicles: $error');
    }
  }

  Future<void> removeVehicleAccess(String vehicleNumber) async {
    try {
      final response = await _dio.put(
        'http://localhost:8081/travelease/BindVehicle',
        data: vehicleNumber,
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
