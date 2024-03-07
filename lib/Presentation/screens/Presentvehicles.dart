import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';
import 'package:tec_admin/Data/Repositories/Present_vehcile_repositories.dart';
import 'package:tec_admin/Presentation/widgets/AddVehicle.dart';
import 'package:tec_admin/Presentation/widgets/Editvehicle.dart';

import 'package:dio/dio.dart';

class PresentVehicleScreen extends StatefulWidget {
  const PresentVehicleScreen({Key? key}) : super(key: key);

  @override
  _VehicleManagementPageState createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<PresentVehicleScreen> {
  final PresentVehicleRepository _repository = PresentVehicleRepository();
  List<PresentVehicle> _vehicles = [];
  bool isLoading = false;
  late String currentTime;
  late String currentDate;
  final bool _isSelectedAll = false;
  final List<PresentVehicle> _selectedRows = [];
  late Timer _timer;
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    updateTime();
    updateDate();
    // Update date and time every second
    _timer = Timer.periodic(const Duration(seconds: 0), (timer) {
      setState(() {
        updateTime();
        updateDate();
      });
    });
    _fetchData();
    _searchController.addListener(() {
      _filterVehicles(_searchController.text);
    });
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void updateTime() {
    final now = DateTime.now();
    currentTime = DateFormat('hh:mm a').format(now);
  }

  void updateDate() {
    final now = DateTime.now();
    currentDate = DateFormat('MMM dd, yyyy').format(now);
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
    return (_vehicles.length / _rowsPerPage).ceil();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final vehicles = await _repository.fetchVehicles();
      setState(() {
        _vehicles = vehicles;
      });
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _editVehicle(PresentVehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditVehicleDialog(
          vehicleId: vehicle.vehicleid,
          vehicleCapacity: vehicle.vehiclecapacity,
          vehicleNumber: vehicle.vehiclenumber,
        );
      },
    );
  }

  void _toggleAccess(PresentVehicle vehicle) async {
    try {
      final response = await Dio().delete(
        'http://localhost:8081/travelease/Vehicle',
        data: vehicle.vehiclenumber,
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        print('Vehicle access removed successfully');
      } else {
        // Handle error or failure response
        print('Failed to remove vehicle access');
      }
    } catch (error) {
      // Handle Dio error
      print('Error removing vehicle access: $error');
    }
  }

  void _filterVehicles(String query) {
    setState(() {
      _vehicles = _searchVehicles(query);
    });
  }

  List<PresentVehicle> _searchVehicles(String query) {
    return _vehicles.where((vehicle) {
      return vehicle.vehiclecapacity.toLowerCase().contains(query.toLowerCase()) ||
          vehicle.vehiclenumber.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _addVehicle() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddVehicleDialog();
      },
    );
  }

  Future<void> _refreshData() async {
    _fetchData();
  }
  Future<void> _downloaddata() async {
    await _fetchData(); // Fetch data from the server

    // Generate CSV data
    String csvData = _generateCsvData(_vehicles);

    // Initiate download
    _downloadCsv(csvData);

  }

  String _generateCsvData(List<PresentVehicle> users) {
    String csvData = 'Vehicle ID,Vehicle Capacity,Vehicle Number,Registered At\n';
    for (var vehicle in _vehicles) {
      csvData += '${vehicle.vehicleid},${vehicle.vehiclecapacity},${vehicle.vehiclenumber},${vehicle.registered}\n';
    }
    return csvData;
  }

  void _downloadCsv(String csvData) {
    // Create a Blob containing the CSV data
    Blob blob = Blob([csvData], 'text/csv');

    // Create a URL for the Blob
    String url = Url.createObjectUrlFromBlob(blob);

    // Create a link element
    AnchorElement anchor = AnchorElement(href: url)
      ..setAttribute('download', 'admin_data.csv');

    // Simulate a click to initiate the download
    anchor.click();

    // Revoke the URL to free up memory
    Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? LinearProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: const AlwaysStoppedAnimation<Color>(Colours.Presentvehicletabletop),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _refreshData();
                      },
                      icon: const Icon(Icons.refresh)),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Enter Vehicle Capacity,Vehicle Number",
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.withOpacity(0.5),
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              _searchVehicles(_searchController.text);
                            },
                            icon: const Icon(Icons.search_rounded)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: _pageIndex == 0 ? null : _onPreviousPage,
                      ),
                      Text('${_pageIndex + 1} of ${_calculateTotalPages()}'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: _pageIndex == (_calculateTotalPages() - 1)
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: DataTable(
                      columnSpacing: 5.0,
                      headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => Colours.Presentvehicletabletop),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Adjust heading font size
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
                            'Vehicle ID',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Vehicle Capacity',
                            textAlign: TextAlign.center, // Center align the heading
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
                            'Created at',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Edit',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Remove Access',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: _vehicles
                          .skip(_pageIndex * _rowsPerPage)
                          .take(_rowsPerPage)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final int index = entry.key + (_pageIndex * _rowsPerPage);
                        final PresentVehicle vehicle = entry.value;
                        final Color color = index.isOdd ? Colors.grey[300]! : Colors.grey[100]!;
                        return DataRow(
                          // selected: _selectedRows.contains(user),
                          // onSelectChanged: (isSelected) {
                          //   setState(() {
                          //     if (isSelected ?? false) {
                          //       _selectedRows.add(user);
                          //     } else {
                          //       _selectedRows.remove(user);
                          //     }
                          //   });
                          // },
                          color: MaterialStateProperty.all(color),
                          cells: [
                            DataCell(
                              Text(
                                vehicle.vehicleid,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(vehicle.vehiclecapacity),
                            ),
                            DataCell(
                              Text(
                                vehicle.vehiclenumber,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                DateFormat('MMM dd, yyyy').format(DateTime.parse(vehicle.registered)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () => _editVehicle(vehicle),
                                icon: const Icon(Icons.edit, color: Colours.Presentvehiclebutton),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () => _toggleAccess(vehicle),
                                icon: const Icon(Icons.remove_circle_outline, color: Colours.Presentvehiclebutton),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
