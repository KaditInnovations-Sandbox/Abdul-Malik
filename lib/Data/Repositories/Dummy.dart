import 'package:tec_admin/Data/Models/Dummydata.dart';

class DummydataRepository {
  static List<Dummydata> getDummyDrivers() {
    return [
      Dummydata(
        id: 1,
        online: "2:30",
        name: 'Abdul Malik',
        routeid: 'RD101',
        email: 'abdul.malik@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "CAR6",
        vehicleNumber: 'ABC123',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 2,
        online: "3:30",
        name: 'Samynathan',
        routeid: 'RD102',
        email: 'samynatha.s@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "BUS50",
        vehicleNumber: 'ABC456',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 3,
        online: "4:30",
        name: 'Boopathy',
        routeid: 'RD201',
        email: 'boopathy@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "VAN30",
        vehicleNumber: 'ABC789',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 4,
        online: "5:30",
        name: 'Sudalaimani',
        routeid: 'RD202',

        email: 'sudalai.mani@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "VAN25",
        vehicleNumber: 'ABC110',
        createdAt: DateTime.now(),
      ),
      Dummydata(
        id: 5,
        online: "6:30",
        name: 'Masood',
        routeid: 'RD301',

        email: 'masood@kaditinnovations.com',
        phoneNumber: '123-456-7890',
        vehicleCapacity: "CAR8",
        vehicleNumber: 'ABC120',
        createdAt: DateTime.now(),
      ),
    ];
  }
}
