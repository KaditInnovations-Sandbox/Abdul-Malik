import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Presentation/widgets/Addadmin.dart';


class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String role;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
  });
}

class Passengerpage extends StatefulWidget {
  const Passengerpage({super.key, Key});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<Passengerpage> {
  List<User> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await Dio().get('http://localhost:8081/travelease/Admin');

      List<User> apiUsers = (response.data as List<dynamic>).map((userData) {
        return User(
          firstName: userData['admin_first_name'].toString(),
          lastName: userData['admin_last_name'].toString(),
          phoneNumber: userData['admin_phone'].toString(),
          role: userData['admin_email'].toString(),
        );
      }).toList();
      print("Fetch Data Successful");
      apiUsers.sort((a, b) => a.firstName.compareTo(b.firstName));

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

  void _editUser(User user) {}

  void _toggleAccess(User user) {}

  void _filterUsers() {}

  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddAdminDialog();
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.black87,
              body: isLoading
                  ? LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              )
                  : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: DataTable(
                            columnSpacing: 5.0,
                            headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.black87,
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
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Name',
                                  textAlign: TextAlign.center, // Center align the heading
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
                                  'Rooute ID',
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
                            rows: users.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final User user = entry.value;
                              final Color color =
                              index.isOdd ? Colors.grey[300]! : Colors.grey[100]!;
                              return DataRow(
                                color: MaterialStateProperty.all(color),
                                cells: [
                                  DataCell(Flexible(
                                      child:Text("${user.firstName} ${user.lastName}")
                                  )),
                                  DataCell(Flexible(
                                    child: Text(user.role,
                                      textAlign: TextAlign.center,),
                                  )),
                                  DataCell(Flexible(
                                    child: Text(user.phoneNumber,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  const DataCell(Text("Stop ID",
                                    textAlign: TextAlign.center,)),
                                  const DataCell(Text("Route ID",
                                    textAlign: TextAlign.center,)),
                                  DataCell(Flexible(
                                    child: IconButton(
                                      onPressed: () => _editUser(user),
                                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                                    ),
                                  )),
                                  DataCell(Flexible(
                                    child: TextButton(
                                      onPressed: () => _toggleAccess(user),
                                      child: const Text(
                                        "Remove access",
                                        style: TextStyle(color: Colors.deepOrange,),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
