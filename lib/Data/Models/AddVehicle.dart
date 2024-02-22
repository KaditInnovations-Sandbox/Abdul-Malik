// lib/data/models/vehicle.dart

class Vehicle {
  final String capacity;
  final String number;

  Vehicle({required this.capacity, required this.number});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      capacity: json['vehicle_capacity'],
      number: json['vehicle_number'],
    );
  }
}
