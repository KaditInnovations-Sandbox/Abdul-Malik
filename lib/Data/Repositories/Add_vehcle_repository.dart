// lib/data/repositories/vehicle_repository.dart

import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/AddVehicle.dart';


class VehicleRepository {
  final Dio _dio = Dio();

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      const String apiUrl = 'http://localhost:8081/travelease/Vehicle';
      final Map<String, dynamic> data = {
        'vehicle_capacity': vehicle.capacity,
        'vehicle_number': vehicle.number,
      };
      await _dio.post(apiUrl, data: data);
    } catch (e) {
      print('Error adding vehicle: $e');
      rethrow;
    }
  }
}
