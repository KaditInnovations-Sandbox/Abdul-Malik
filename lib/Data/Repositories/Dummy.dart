import 'package:tec_admin/Data/Models/Dummydata.dart';

class DummydataRepository {
  static List<Dummydata> getDummyDrivers() {
    return [
      Dummydata(
        id: 1,
        name: 'Abdul Malik',
        email: 'abdul.malik@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "CAR6",
        vehicleNumber: 'ABC123',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 2,
        name: 'Samynathan',
        email: 'samynatha.s@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "BUS50",
        vehicleNumber: 'ABC456',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 3,
        name: 'Boopathy',
        email: 'boopathy@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "VAN30",
        vehicleNumber: 'ABC789',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 4,
        name: 'Sudalaimani',
        email: 'sudalai.mani@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "VAN25",
        vehicleNumber: 'ABC110',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 5,
        name: 'Masood',
        email: 'masood@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "CAR8",
        vehicleNumber: 'ABC120',
        createdAt: DateTime.now(),
      ),
    ];
  }
}
