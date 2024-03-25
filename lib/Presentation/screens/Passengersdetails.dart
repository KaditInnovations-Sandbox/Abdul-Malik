import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:intl/intl.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Admin.dart';
import 'package:tec_admin/Data/Models/Passenger_model.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';
import 'package:tec_admin/Data/Repositories/Admin_repo.dart';
import 'package:tec_admin/Data/Repositories/Passenger_repo.dart';
import 'package:tec_admin/Presentation/widgets/Add_passenger.dart';
import 'package:tec_admin/Presentation/widgets/EditPassenger.dart';
import 'package:tec_admin/Presentation/widgets/Editvehicle.dart';

class Passengerspage extends StatefulWidget {
  final String companyid;
  final String companyName;
  const Passengerspage({super.key, required this.companyid,required this.companyName});

  @override
  State<Passengerspage> createState() => _PassengerspageState();
}

class _PassengerspageState extends State<Passengerspage> {
  List<Passenger> users = [];
  bool isLoading = false;
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  late String _userRole;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userRole = _getUserRole() ?? '';
    // Initialize current date and time
    _fetchData();
    _searchController.addListener(() {
      _filterVehicles(_searchController.text);
    });
  }

  String? _getUserRole() {
    return window.localStorage['user_role']; // Retrieve user role from local storage
  }

  Future<void> _toggleAccess(Passenger passenger) async {
    try {
      final response = await Dio().delete(
        '${ApiConstants.baseUrl}/Passenger',
        data: {
          "passenger_phone" : '${passenger.phoneNumber}'
        },
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        _refreshData();
        print('Company access removed successfully');
      } else {
        // Handle error or failure response
        print('Failed to remove vehicle access');
      }
    } catch (error) {
      // Handle Dio error
      print('Error removing vehicle access: $error');
    }
  }

  Future<void> _grandAccess(Passenger passenger) async {
    try {
      final response = await Dio().put(
        '${ApiConstants.baseUrl}/BindPassenger',
        data: {
          "passenger_phone" : '${passenger.phoneNumber}'
        },
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        _refreshData();
        print('Company access granted successfully');
      } else {
        // Handle error or failure response
        print('Failed to grant vehicle access');
      }
    } catch (error) {
      // Handle Dio error
      print('Error granting vehicle access: $error');
    }
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _searchController.dispose();
    super.dispose();
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

  Future<void> _fetchData() async {
    final repository = PassengerRepository();
    List<Passenger> fetchedUsers = await repository.fetchPassengers(widget.companyid);

    setState(() {
      users = fetchedUsers;
      isLoading = false;
    });
  }

  void _filterVehicles(String query) {
    setState(() {});
  }



  Future<void> _refreshData() async {
    _fetchData();
  }

  void _addPassenger() {
    print("Company name : ${widget.companyName}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPassengerDialog(companyname: "${widget.companyName}",);
      },
    );
  }

  void _editPassenger(Passenger passenger) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPassengerDialog(
          passengerId: passenger.passengerid,
          passengername: passenger.passenger_name,
          passengeremail: passenger.passenger_email,
          passengerphone: passenger.phoneNumber,
          location: passenger.passenger_location ,
        );
      },
    );
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
                        IconButton(
                            onPressed: () {
                              _refreshData();
                            },
                            icon: const Icon(Icons.refresh)),
                        Tooltip(
                          message: "Search Schedules",
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: 30,
                            child: TextField(
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
                        ElevatedButton.icon(
                          onPressed: () => _addPassenger(),
                          icon: const Icon(Icons.add),
                          label: const Text("Add"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Adjust the border radius for a square button
                            ),
                            primary: Colours.orange,
                            onPrimary: Colours.white,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed:
                                  _pageIndex == 0 ? null : _onPreviousPage,
                            ),
                            Text(
                                '${_pageIndex + 1} of ${_calculateTotalPages()}'),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed:
                                  _pageIndex == (_calculateTotalPages() - 1)
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
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Passenger ID',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Pass_Name',
                                  textAlign: TextAlign
                                      .center, // Center align the heading
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
                                  'Phone',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Location',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Stop ID',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Route ID',
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
                                  'Status',
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
                              final int index =
                                  entry.key + (_pageIndex * _rowsPerPage);
                              final Passenger passenger = entry.value;
                              final Color color = index.isOdd
                                  ? Colors.grey[300]!
                                  : Colors.grey[100]!;
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
                                      '${passenger.passengerid}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text("${passenger.passenger_name}"),
                                  ),
                                  DataCell(
                                    Text(
                                      passenger.passenger_email,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      passenger.phoneNumber,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      passenger.passenger_location,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "Stop ID",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "Route ID",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(DateTime.parse(passenger.created)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      passenger.status ? 'Active' : 'Inactive',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: passenger.status ? Colours.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Tooltip(
                                      message:"Edit",
                                      child: IconButton(
                                        onPressed: passenger.status
                                            ? () => _editPassenger(passenger)
                                            : null,
                                        icon: const Icon(Icons.edit),
                                        color: passenger.status ? Colours.orange : Colours.grey,
                                      ),
                                    ),
                                  ),
                                  if(_userRole == 'SUPER_ADMIN')
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          if (passenger.status) {
                                            _toggleAccess(passenger);
                                            _refreshData();
                                          } else {
                                            _grandAccess(passenger);
                                            _refreshData();
                                          }
                                        },
                                        icon: Icon(
                                          passenger.status
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
