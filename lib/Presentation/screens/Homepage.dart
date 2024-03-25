import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Dummydata.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';
import 'package:tec_admin/Data/Repositories/Dummy.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<PresentVehicle> vehicles = [];
  late String currentTime;
  late String currentDate;
  late Timer _timer;
  bool isLoading = false;
  late MapboxMapController _controller;
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  List<Dummydata> dummyDrivers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize current date and time
    currentTime = DateTimeUtils.getCurrentTime();
    currentDate = DateTimeUtils.getCurrentDate();
    // Update date and time every second
    _fetchDummyData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateTimeUtils.getCurrentTime();
          currentDate = DateTimeUtils.getCurrentDate();
        });
      }
    });
    // _fetchData();
    _searchController.addListener(() {
      _filterVehicles(_searchController.text);
    });
  }

  void _onPreviousPage() {
    setState(() {
      _pageIndex = (_pageIndex - 1).clamp(0, (_calculateTotalPages() - 1));
    });
  }

  void _onNextPage() {
    setState(() {
      _pageIndex = (_pageIndex + 1).clamp(0, (_calculateTotalPages() - 1));
    });
  }

  int _calculateTotalPages() {
    return (vehicles.length / _rowsPerPage).ceil();
  }

  Future<void> _fetchDummyData() async {
    setState(() {
      isLoading = true;
      print("Data Fetched");
    });

    // Fetch dummy drivers using the repository
    dummyDrivers = await DummydataRepository
        .getDummyDrivers(); // Adjust the method according to your repository implementation

    setState(() {
      isLoading = false;
    });
  }

  // Future<void> _fetchData() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     final response = await Dio().get('http://localhost:8081/travelease/ActiveVehicle');
  //
  //     List<PresentVehicle> apiVehicles = (response.data as List<dynamic>).map((vehicleData) {
  //       return PresentVehicle(
  //         vehicleid: vehicleData['vehicle_id'].toString(),
  //         vehiclecapacity: vehicleData['vehicle_capacity'].toString(),
  //         vehiclenumber: vehicleData['vehicle_number'].toString(),
  //         registeded: vehicleData['vehicle_registered'].toString(),
  //       );
  //     }).toList();
  //     print("Fetch Data Successful");
  //     apiVehicles.sort((a, b) => int.parse(a.vehicleid).compareTo(int.parse(b.vehicleid)));
  //
  //     setState(() {
  //       vehicles = apiVehicles;
  //     });
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  void _filterVehicles(String query) {
    setState(() {
      vehicles = _searchVehicles(query);
    });
  }

  List<PresentVehicle> _searchVehicles(String query) {
    return vehicles.where((vehicle) {
      return vehicle.vehiclecapacity
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          vehicle.vehiclenumber.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> _refreshData() async {
    _fetchDummyData();
    // _fetchData();
  }

  @override
  void dispose() {
    // Cancel the timer to prevent calling setState after dispose
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _controller = controller;

    // Wait for a delay to ensure the map is fully loaded before adding the marker
    Future.delayed(const Duration(seconds: 2), () {
      // Add the marker symbol layer
      controller.addSymbol(SymbolOptions(
        geometry: LatLng(1.338170, 103.902300),
        iconImage: 'assets/marker_icon.png',
        textField: 'Sevilai Transport',
        iconSize: 0.3,
        textSize: 16,
        textColor: '#000000',
        textOffset: Offset(0, 2),
      ));

      controller.addSymbol(SymbolOptions(
        geometry: LatLng(1.337840, 103.903170),
        iconImage: 'assets/marker_icon.png',
        textField: 'Alpha Builders',
        iconSize: 0.3,
        textSize: 16,
        textColor: '#000000',
        textOffset: Offset(0, 2),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          backgroundColor: Colours.black,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.white)),
                  Text(
                    "${currentTime}(SGT)",
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  print("refresh button pressed");
                  _refreshData();
                },
                icon: const Icon(Icons.autorenew, color: Colors.white),
              )
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        body: isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colours.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colours.orange),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.49,
                        width: MediaQuery.of(context).size.width * 0.97,
                        child: MapboxMap(
                          onMapCreated: _onMapCreated,
                          styleString: MapboxStyles.LIGHT,
                          accessToken: 'pk.eyJ1IjoiYWJkdWxtYWxpazAyIiwiYSI6ImNsc3k5NndzNzBhbHcyam9ldzMweHp1ZXgifQ.8OJRRvY-p357uGyu6lxheQ',
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(1.338170, 103.902300), // Initial map center position
                            zoom: 17, // Initial zoom level
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 10),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    height: 30,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText:
                                            "Enter Name, Email, phone, Role",
                                        hintStyle: TextStyle(
                                          color: Colours.black,
                                          fontSize: 15,
                                        ),
                                        fillColor: Colors.grey[300],
                                        filled: true,
                                        suffixIcon:
                                            const Icon(Icons.search_rounded),
                                        border: OutlineInputBorder(
                                          // Specify border here
                                          // Adjust border radius as needed
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal:
                                                10.0), // Adjust content padding to ensure text appears inside the border
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: ImageIcon(
                                        AssetImage("assets/orange.png"),
                                        color: Colours.orange,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back_ios),
                                        onPressed: _pageIndex == 0
                                            ? null
                                            : _onPreviousPage,
                                      ),
                                      Text(
                                          '${_pageIndex + 1} of ${_calculateTotalPages()}'),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.arrow_forward_ios),
                                        onPressed: _pageIndex ==
                                                (_calculateTotalPages() - 1)
                                            ? null
                                            : _onNextPage,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                          isLoading
                              ? LinearProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colours.Presentvehicletabletop),
                                )
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(20.0),
                                    child: DataTable(
                                      columnSpacing: 5.0,
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colours
                                                  .Presentvehicletabletop),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            12, // Adjust heading font size
                                      ),
                                      headingRowHeight: 50.0,
                                      dataRowHeight: 50.0,
                                      dividerThickness: 0,
                                      dataTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'S.No',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Online',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Driver Name',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Route ID',
                                            textAlign: TextAlign
                                                .center, // Center align the heading
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Vehicle Capacity',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Vehicle Number',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Start Time',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'End Time',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Updated',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Status',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                      // rows: vehicles
                                      //     .skip(_pageIndex * _rowsPerPage)
                                      //     .take(_rowsPerPage)
                                      //     .toList()
                                      //     .asMap()
                                      //     .entries
                                      //     .map((entry) {
                                      //   final int index = entry.key + (_pageIndex * _rowsPerPage);
                                      //   final PresentVehicle vehicle = entry.value;
                                      //   final Color color = index.isOdd ? Colors.grey[300]! : Colors.grey[100]!;
                                      //   return DataRow(
                                      //     // selected: _selectedRows.contains(user),
                                      //     // onSelectChanged: (isSelected) {
                                      //     //   setState(() {
                                      //     //     if (isSelected ?? false) {
                                      //     //       _selectedRows.add(user);
                                      //     //     } else {
                                      //     //       _selectedRows.remove(user);
                                      //     //     }
                                      //     //   });
                                      //     // },
                                      //     color: MaterialStateProperty.all(color),
                                      //     cells: [
                                      //       DataCell(
                                      //         Text(
                                      //           vehicle.vehicleid,
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      //       DataCell(
                                      //         Text(
                                      //           "Abdul Malik",
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      //       DataCell(
                                      //         Text(
                                      //           "Aaa@gmail.com",
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      //       DataCell(
                                      //         Text(
                                      //           "9087035132",
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      //       DataCell(
                                      //         Text(vehicle.vehiclecapacity),
                                      //       ),
                                      //       DataCell(
                                      //         Text(
                                      //           vehicle.vehiclenumber,
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      //       DataCell(
                                      //         Text(
                                      //           DateFormat('MMM dd, yyyy').format(DateTime.parse(vehicle.registeded)),
                                      //           textAlign: TextAlign.center,
                                      //         ),
                                      //       ),
                                      //       DataCell(
                                      //         IconButton(
                                      //           onPressed: () => _editVehicle(vehicle),
                                      //           icon: const Icon(Icons.edit, color: Colours.Presentvehiclebutton),
                                      //         ),
                                      //       ),
                                      //       DataCell(
                                      //         IconButton(
                                      //           onPressed: () => _toggleAccess(vehicle),
                                      //           icon: const Icon(Icons.remove_circle_outline, color: Colours.Presentvehiclebutton),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   );
                                      // }).toList(),
                                      rows: dummyDrivers.map((driver) {
                                        final Color color =
                                            dummyDrivers.indexOf(driver).isOdd
                                                ? Colors.grey[300]!
                                                : Colors.grey[100]!;
                                        return DataRow(
                                          color:
                                              MaterialStateProperty.all(color),
                                          cells: [
                                            DataCell(
                                              Text(
                                                driver.id.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                driver.online,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                driver.name,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                driver.routeid,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                driver.vehicleCapacity,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                driver.vehicleNumber,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "12:40",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "15:50",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                DateFormat('MMM dd, yyyy')
                                                    .format(driver.createdAt),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Icon(Icons.directions_bus_rounded,
                                                  color: Colours.green),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
