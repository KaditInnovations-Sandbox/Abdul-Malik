import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Dummydata.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';
import 'package:tec_admin/Data/Models/Sevilai_Driver_Model.dart';
import 'package:tec_admin/Data/Repositories/Dummy.dart';
import 'package:tec_admin/Data/Repositories/Sevilai_Driver_repo.dart';
import 'package:tec_admin/Presentation/widgets/AddVehicle.dart';
import 'package:tec_admin/Presentation/widgets/Editvehicle.dart';
import 'package:dio/dio.dart';

enum FilterOption {
  all,
  active,
  inactive,
}

class Sevilaidrivers extends StatefulWidget {
  const Sevilaidrivers({Key? key}) : super(key: key);

  @override
  _VehicleManagementPageState createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<Sevilaidrivers> {
  bool isLoading = false;
  late String currentTime;
  late String currentDate;
  List<SevilaiDriver> users = [];

  late Timer _timer;
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late String _userRole;

  @override
  void initState() {
    super.initState();
    _userRole = _getUserRole() ?? '';
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
      // _filterVehicles(_searchController.text);
    });
  }

  String? _getUserRole() {
    return window.localStorage['user_role']; // Retrieve user role from local storage
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
    return (users.length / _rowsPerPage).ceil();
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

  Future<void> _fetchData() async {
    setState(() {

      isLoading = true; // Set isLoading to true while fetching data
    });
    try {
      final repository = SevilaiDriverRepository();
      List<SevilaiDriver> fetchedUsers = await repository.fetchSevilaiDrivers();
      setState(() {
        users = fetchedUsers;
        isLoading = false; // Set isLoading back to false after fetching data successfully
      });
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error by showing an error message or performing any necessary actions

      setState(() {
        isLoading = true; // Set isLoading to false if there's an error
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
        '${ApiConstants.baseUrl}/Vehicle',
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

  // void _filterVehicles(String query) {
  //   setState(() {
  //     users = _searchVehicles(query);
  //   });
  // }
  //
  // List<PresentVehicle> _searchVehicles(String query) {
  //   return users.where((vehicle) {
  //     return vehicle.vehiclecapacity
  //             .toLowerCase()
  //             .contains(query.toLowerCase()) ||
  //         vehicle.vehiclenumber.toLowerCase().contains(query.toLowerCase());
  //   }).toList();
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? _buildErrorWidget()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Tooltip(
                          message:
                              'Refresh', // Tooltip message to display when hovering
                          child: IconButton(
                            onPressed: () => _refreshData(),
                            icon: const Icon(Icons.refresh),
                          ),
                        ),
                        Tooltip(
                          message: 'Search Vehicle',
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: 30,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Enter Name, Email, phone, Role",
                                hintStyle: TextStyle(
                                  color: Colours.black,
                                  fontSize: 15,
                                ),
                                fillColor: Colors.grey[300],
                                filled: true,
                                suffixIcon: const Icon(Icons.search_rounded),
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
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        PopupMenuButton<FilterOption>(
                          onSelected: (FilterOption result) {
                            setState(() {
                              _filter_company(result);
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<FilterOption>>[
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
                          icon: const Icon(
                            Icons.filter_alt,
                            color: Colours.orange,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Tooltip(
                              message: "Previous Page",
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed:
                                    _pageIndex == 0 ? null : _onPreviousPage,
                              ),
                            ),
                            Tooltip(
                                message:
                                    "${_pageIndex + 1} of ${_calculateTotalPages()}",
                                child: Text(
                                    '${_pageIndex + 1} of ${_calculateTotalPages()}')),
                            Tooltip(
                              message: "Next Page",
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed:
                                    _pageIndex == (_calculateTotalPages() - 1)
                                        ? null
                                        : _onNextPage,
                              ),
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
                            columns:[
                              DataColumn(
                                label: Text(
                                  'S.No',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Phone Number',
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
                              if(_userRole == 'SUPER_ADMIN')
                                DataColumn(
                                  label: Text(
                                    'Remove Access',
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                            ],
                            rows: users
                                .skip(_pageIndex * _rowsPerPage)
                                .take(_rowsPerPage)
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                              final int index = entry.key + (_pageIndex * _rowsPerPage);
                              final SevilaiDriver drivers = entry.value;
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
                                      drivers.SevilaiDriverid,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      drivers.SevilaiDriver_name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      drivers.SevilaiDriver_email,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      drivers.phoneNumber,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text("vehicle.vehiclecapacity"),
                                  ),
                                  DataCell(
                                    Text(
                                      "vehicle.vehiclenumber",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(DateTime.parse(drivers.created)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.edit, color: Colours.Presentvehiclebutton),
                                    ),
                                  ),
                                  if(_userRole == 'SUPER_ADMIN')
                                    DataCell(
                                      IconButton(
                                        onPressed: () {},
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
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/error.png', // Replace 'error_image.png' with your error illustration image path
            height: 200,
            width: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            'Oops! Something went wrong.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _refreshData, // Call your refresh data method
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
