import 'dart:async';
import 'dart:html';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Removedvehicle.dart';
import 'package:tec_admin/Data/Repositories/Present_vehcile_repositories.dart';
import 'package:tec_admin/Data/Repositories/Removed_vehilce_repository.dart';
import 'package:tec_admin/Presentation/screens/Presentvehicles.dart';
import 'package:tec_admin/Presentation/screens/Removedvehicles.dart';
import 'package:tec_admin/Presentation/widgets/AddVehicle.dart';
import 'package:tec_admin/Presentation/widgets/Editvehicle.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';
import '../../Data/Models/Presentvehicle.dart';

enum FilterOption {
  all,
  active,
  inactive,
}

class VehilceScreen extends StatefulWidget {
  const VehilceScreen({Key? key}) : super(key: key);

  @override
  _VehilceScreenState createState() => _VehilceScreenState();
}

class _VehilceScreenState extends State<VehilceScreen> {
  final PresentVehicleRepository _repository = PresentVehicleRepository();
  List<PresentVehicle> _vehicles = [];
  final RemovedVehicleRepository _repository2 = RemovedVehicleRepository();
  List<RemovedVehicle> _vehicles2 = [];
  final bool _isSelectedAll = false;
  bool isLoading = false;
  final List<PresentVehicle> _selectedRows = [];
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  late String currentTime;
  late String currentDate;
  late Timer _timer;
  late int _currentTabIndex;
  late String filename;// Track the current active tab index

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    currentTime = DateTimeUtils.getCurrentTime();
    currentDate = DateTimeUtils.getCurrentDate();
    _currentTabIndex = 0; // Initialize to the first tab
    // Update date and time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateTimeUtils.getCurrentTime();
          currentDate = DateTimeUtils.getCurrentDate();
        });
      }

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
      setState(() {
        isLoading = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddVehicleDialog();
      },
    );
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
        data: {
          "vehicle_number" : vehicle.vehiclenumber
        },
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

  void _grandAccess(PresentVehicle vehicle) async {
    try {
      final response = await Dio().put(
        'http://localhost:8081/travelease/BindVehicle',
        data: {
          "vehicle_number" : vehicle.vehiclenumber
        },
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        print('Vehicle access grand successfully');
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


  Future<void> _refreshData() async {
    _fetchData();
  }

  Future<void> _downloaddata() async {
    await _fetchData();
    String csvData = _generateCsvData(_vehicles, 'vehicles.csv');
    _downloadCsv(csvData);
  }

  String _generateCsvData(List<dynamic> vehicles, String fileName) {
    String csvData = 'Vehicle ID,Vehicle Capacity,Vehicle Number,Registered At\n';
    for (var vehicle in vehicles) {
      csvData +=
      '${vehicle.vehicleid},${vehicle.vehiclecapacity},${vehicle.vehiclenumber},${vehicle.registered}\n';
    }
    return csvData;
  }

  void _filter_company(FilterOption filterOption) {
    setState(() {
      switch (filterOption) {
        case FilterOption.all:
        // Show all _company
        // No need to modify the '_company' list here
          break;
        case FilterOption.active:
        // Show active _company

          break;
        case FilterOption.inactive:
        // Show inactive _company
          break;
      }
    });
  }

  void _downloadCsv(String csvData) {
    // Create a Blob containing the CSV data
    Blob blob = Blob([csvData], 'text/csv:charset=utf-8');

    // Create a URL for the Blob
    String url = Url.createObjectUrlFromBlob(blob);

    // Create a link element
    AnchorElement anchor = AnchorElement(href: url)
      ..setAttribute('download', 'vehicles.csv' );


    // Simulate a click to initiate the download
    anchor.click();

    // Revoke the URL to free up memory
    Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colours.appBarBackground,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate,
                      style: const TextStyle(
                          fontSize: 15, color: Colours.textColor)),
                  Text(
                    "${currentTime}(SGT)",
                    style: const TextStyle(
                        fontSize: 15, color: Colours.textColor),
                  ),
                ],
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 130,
                ),
                IconButton(
                  onPressed: () {
                    _downloaddata();
                  },
                  icon: ImageIcon(
                    AssetImage("assets/orange.png"),
                    color: Colours.white,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _addUser(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.buttonBackground,
                    foregroundColor: Colours.textColor,
                  ),
                  child: const Text("Add"),
                ),
                const SizedBox(width: 26),
              ],
            ),
          ],
        ),
        body: isLoading
            ? Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colours.Presentvehicletabletop,
          child: Container(
            height: 4.0, // Adjust the height of the shimmer effect
            color: Colors.white,
          ),
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
                      width: MediaQuery.of(context).size.width * 0.28,
                      height: 30,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Enter Name, Email, phone, Role",
                          hintStyle: TextStyle(color: Colours.black,fontSize: 15,),
                          fillColor: Colors.grey[300],
                          filled: true,
                          suffixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder( // Specify border here
                            // Adjust border radius as needed
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust content padding to ensure text appears inside the border
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    PopupMenuButton<FilterOption>(
                      onSelected: (FilterOption result) {
                        setState(() {
                          _filter_company(result);
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterOption>>[
                        const PopupMenuItem<FilterOption>(
                          value: FilterOption.all,
                          child: Text('All'),
                        ),
                        const PopupMenuItem<FilterOption>(
                          value: FilterOption.active,
                          child: Text('Active'),
                        ),
                        const PopupMenuItem<FilterOption>(
                          value: FilterOption.inactive,
                          child: Text('Inactive'),
                        ),
                      ],
                      icon: const Icon(Icons.view_column_outlined,color: Colours.orange,),
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
                              'Status',
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
                                    vehicle.status ? 'Active' : 'Inactive',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: vehicle.status ? Colors.green : Colors.red,
                                    )
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
                                  onPressed: vehicle.status
                                      ? () => _editVehicle(vehicle)
                                      : null,
                                  icon: const Icon(Icons.edit),
                                  color: vehicle.status ? Colours.orange : Colours.grey,
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    if (vehicle.status) {
                                      _toggleAccess(vehicle);
                                    } else {
                                      _grandAccess(vehicle);
                                    }
                                  },
                                  icon: Icon(
                                    vehicle.status
                                        ? Icons.remove_circle_outline
                                        : Icons.add_circle_outline,
                                    color: Colours.orange,
                                  ),
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
      ),
    );
  }
}
