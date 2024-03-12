import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Admin.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';
import 'package:tec_admin/Data/Repositories/Admin_repo.dart';
import 'package:tec_admin/Data/Repositories/Present_vehcile_repositories.dart';
import 'package:tec_admin/Presentation/widgets/AddService.dart';
import 'package:tec_admin/Presentation/widgets/Add_passenger.dart';
import 'package:tec_admin/Presentation/widgets/Editvehicle.dart';

class Servicepage extends StatefulWidget {
  const Servicepage({super.key});

  @override
  State<Servicepage> createState() => _ServicepageState();
}

class _ServicepageState extends State<Servicepage> {

  List<Admin> users = [];
  bool isLoading = false;
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late List<bool> _switchStates;


  @override
  void initState() {
    super.initState();
    _switchStates = List.filled(users.length, false);
    _fetchData();
    _searchController.addListener(() {
      _filterVehicles(_searchController.text);
    });
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
      _switchStates = List.filled(fetchedUsers.length, false);
      isLoading = false;
    });

  }
  void _filterVehicles(String query) {
    setState(() {


    });
  }

  Future<void> _refreshData() async {
    _fetchData();
  }
  void _addPassenger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddServiceDialog();
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
  bool _isSwitched = false;


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
                        hintText: "Enter Passenger Name ,Phone Number",
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.withOpacity(0.5),
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              // _searchVehicles(_searchController.text);
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
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () => _addPassenger(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.buttonBackground,
                      foregroundColor: Colours.textColor,
                    ),
                    child: const Text("Add"),
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
                            'Date',
                            textAlign: TextAlign.center, // Center align the heading
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
                            'Pickup up',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Drop',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'No.of Days',
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
                            'Vehicle',
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
                            'Stops',
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
                            'Allow Booking',
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
                      rows: users
                          .skip(_pageIndex * _rowsPerPage)
                          .take(_rowsPerPage)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final int index = entry.key + (_pageIndex * _rowsPerPage);
                        final Admin admin = entry.value;
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
                              Text("06/04/2024"),
                            ),
                            DataCell(
                                TextButton(
                                    onPressed: (){},
                                    child: Text("KADTN${index + 0}0${index + 1}",
                                      style: TextStyle(color: Colours.orange,fontSize: 12),
                                    )
                                )
                            ),
                            DataCell(
                              Text(
                                "Pickup",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                'Drop',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text("${index + 7}"),
                            ),
                            DataCell(
                              Text("0${index +1}:00"),
                            ),
                            DataCell(
                              Text(
                                "0${index +3}:00",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                "SPR${index +2}${index +1}${index +4}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text('${index +1}00'),
                            ),

                            DataCell(
                              Text(
                                "Stop 1 ,Stop 2",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                "0${index +2}/04/2024",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Transform.scale(
                                scale : 0.5,
                                child: Switch(
                                  value: _switchStates[index], // Use the variable to manage the switch state
                                  onChanged: (newValue) {
                                    // Update the variable when the switch is toggled
                                    setState(() {
                                      _switchStates[index] = newValue;
                                    });
                                  },
                                  activeColor: Colours.green,
                                  inactiveThumbColor: Colours.grey,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(Icons.edit, color: Colours.Presentvehiclebutton),
                              ),
                            ),
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
}
