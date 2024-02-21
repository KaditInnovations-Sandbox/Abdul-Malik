import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp/pages/Companydetails.dart';
import 'package:testapp/widgets/AddVehicle.dart';
import 'package:testapp/widgets/Adduser.dart';
import 'package:testapp/widgets/Editvehicle.dart';
import '../widgets/EmailforOtp.dart';
import 'package:intl/intl.dart';

class User {
  String vehiclecapacity;
  String vehicleid;
  String vehiclenumber;
  String registeded;

  User({
    required this.vehiclecapacity,
    required this.vehiclenumber,
    required this.registeded,
    required this.vehicleid,
  });
}

class Presentvehicle extends StatefulWidget {
  const Presentvehicle({Key? key});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<Presentvehicle> {
  List<User> users = [];
  bool isLoading = false;
  late String currentTime;
  late String currentDate;
  bool _isSelectedAll = false;
  List<User> _selectedRows = [];
  late Timer _timer;
  int _rowsPerPage = 20;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    updateTime();
    updateDate();
    // Update date and time every second
    _timer = Timer.periodic(Duration(seconds: 0), (timer) {
      setState(() {
        updateTime();
        updateDate();
      });
    });
    _fetchData();
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
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

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await Dio().get('http://localhost:8081/travelease/ActiveVehicle');

      List<User> apiUsers = (response.data as List<dynamic>).map((userData) {
        return User(
          vehicleid: userData['vehicle_id'].toString(),
          vehiclecapacity: userData['vehicle_capacity'].toString(),
          vehiclenumber: userData['vehicle_number'].toString(),
          registeded: userData['vehicle_registered'].toString(),
        );
      }).toList();
      print("Fetch Data Successful");
      apiUsers.sort((a, b) => int.parse(a.vehicleid).compareTo(int.parse(b.vehicleid)));

      setState(() {
        users = apiUsers;
      });
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditVehicleDialog(
          vehicleId: user.vehicleid,
          vehicleCapacity: user.vehiclecapacity,
          vehicleNumber: user.vehiclenumber,
        );
      },
    );
  }

  void _toggleAccess(User user) async {
    try {
      final response = await Dio().delete(
        'http://localhost:8081/travelease/Vehicle',
        data: user.vehiclenumber,
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


  void _filterUsers() {}

  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddVehicleDialog();
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
          ? LinearProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffea6238)),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(onPressed: ()=>_refreshData(), icon: Icon(Icons.refresh)),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Name, Email, phone, registeded",
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.withOpacity(0.5),
                        filled: true,
                        suffixIcon: Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: _pageIndex == 0 ? null : _onPreviousPage,
                      ),
                      Text('${_pageIndex + 1} of ${_calculateTotalPages()}'),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: _pageIndex == (_calculateTotalPages() - 1) ? null : _onNextPage,
                      ),
                    ],
                  ),
                  SizedBox(width: 15,)
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
                              (states) => Color(0xffea6238)
                      ),
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
                      rows: users.skip(_pageIndex * _rowsPerPage).take(_rowsPerPage).toList().asMap().entries.map((entry) {
                        final int index = entry.key + (_pageIndex * _rowsPerPage);
                        final User user = entry.value;
                        final Color color =
                        index.isOdd ? Colors.grey[300]! : Colors.grey[100]!;
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
                                '${user.vehicleid}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text("${user.vehiclecapacity}"),
                            ),

                            DataCell(
                              Text(user.vehiclenumber, textAlign: TextAlign.center,),
                            ),
                            DataCell(
                              Text(
                                DateFormat('MMM dd, yyyy').format(DateTime.parse(user.registeded)),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            DataCell(
                              IconButton(
                                onPressed: () => _editUser(user),
                                icon: Icon(Icons.edit, color: Color(0xffea6238)),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () => _toggleAccess(user),
                                icon: Icon(Icons.remove_circle_outline, color: Color(0xffea6238)),
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
