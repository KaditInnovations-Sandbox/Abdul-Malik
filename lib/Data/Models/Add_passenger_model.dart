class Passenger {
  final String Passengername;
  final String Passengeremail;
  final String Passengerphone;
  final String Passengerlocation;

  Passenger({
    required this.Passengername,
    required this.Passengeremail,
    required this.Passengerphone,
    required this.Passengerlocation,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      Passengername: json['passenger_name'],
      Passengeremail: json['passenger_email'],
      Passengerphone: json['passenger_phone'],
      Passengerlocation: json['passenger_location'],
    );
  }
}