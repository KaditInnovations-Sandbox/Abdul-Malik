import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Admin.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';
import 'package:tec_admin/Data/Repositories/Admin_repo.dart';
import 'package:tec_admin/Presentation/widgets/AddSchedule.dart';
import 'package:tec_admin/Presentation/widgets/Editvehicle.dart';

enum FilterOption {
  all,
  active,
  inactive,
}

class Shedule extends StatefulWidget {
  const Shedule({super.key});

  @override
  State<Shedule> createState() => _SheduleState();
}

class _SheduleState extends State<Shedule> {
  List<Admin> users = [];
  bool isLoading = false;
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  late String _userRole;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userRole = getUserRoleFromCookie() ?? '';
    // Initialize current date and time
    _fetchData();
    _searchController.addListener(() {
      _filterVehicles(_searchController.text);
    });
  }

  String? getUserRoleFromCookie() {
    final cookies = document.cookie!.split(';');
    for (var cookie in cookies) {
      final keyValue = cookie.trim().split('=');
      if (keyValue.length == 2 && keyValue[0] == 'user_role') {
        return keyValue[1];
      }
    }
    return null;
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
    final repository = AdminRepository();
    List<Admin> fetchedUsers = await repository.fetchAdmins();

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddScheduleDialog();
      },
    );
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
        'http://192.168.20.21:8081/travelease/Vehicle',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Colours.Presentvehicletabletop),
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
                        SizedBox(
                          width: 10,
                        ),
                        PopupMenuButton<FilterOption>(
                          onSelected: (FilterOption result) {
                            setState(() {
                              // _filter_company(result);
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
                            columns:[
                              DataColumn(
                                label: Text(
                                  'Passenger ID',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Date',
                                  textAlign: TextAlign
                                      .center, // Center align the heading
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
                                  'Passengers',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Vehicle',
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
                              final int index =
                                  entry.key + (_pageIndex * _rowsPerPage);
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
                                      '${index + 1}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text("06/04/2024"),
                                  ),
                                  DataCell(
                                    Text(
                                      "KADTN101",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "400",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "40",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "04/04/2024",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.edit,
                                          color: Colours.Presentvehiclebutton),
                                    ),
                                  ),
                                  if(_userRole == 'SUPER_ADMIN')
                                    DataCell(
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colours.Presentvehiclebutton),
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
