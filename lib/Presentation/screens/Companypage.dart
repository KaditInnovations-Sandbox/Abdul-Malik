import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Presentation/screens/Companydetails.dart';
import 'package:tec_admin/Presentation/widgets/Addadmin.dart';

import '../../Utills/date_time_utils.dart';

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

class Company extends StatefulWidget {
  const Company({super.key, Key});

  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  List<User> users = [];
  bool isLoading = false;
  bool showCompanyDetailsPage = false;
  late String companyName;
  late String currentTime;
  late String currentDate;
  late Timer _timer;
  final int _rowsPerPage = 20;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentTime = DateTimeUtils.getCurrentTime();
    currentDate = DateTimeUtils.getCurrentDate();
    // Update date and time every second
    _timer = Timer.periodic(const Duration(seconds: 0), (timer) {
      setState(() {
        currentTime = DateTimeUtils.getCurrentTime();
        currentDate = DateTimeUtils.getCurrentDate();
      });
    });
    _fetchData();
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
  Future<void> _refreshData() async {
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

  void _goBack() {
    setState(() {
      _timer.cancel();
      showCompanyDetailsPage = false;
    });
  }

  void _viewCompanyDetails(String companyName) {
    setState(() {
      showCompanyDetailsPage = true;
      this.companyName = companyName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showCompanyDetailsPage) {
      return CompanyDetailsPage(companyName: companyName, onBack: _goBack);
    } else {
      return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate, style: const TextStyle(fontSize: 15, color: Colors.white)),
                  Text(
                    "${currentTime}(SGT)",
                    style: const TextStyle(fontSize: 15, color: Colors.white),
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
                const SizedBox(width: 130,),
                ElevatedButton(
                  onPressed: () => _addUser(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffea6238),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Add"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _filterUsers(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffea6238),
                    foregroundColor: Colors.white,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.file_copy_sharp),
                      SizedBox(width: 3,),
                      Text("Export")
                    ],
                  ),
                ),
                const SizedBox(width: 26),
              ],
            ),
          ],
        ),
        body: isLoading
            ? LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(onPressed: ()=>_refreshData(), icon: const Icon(Icons.refresh)),
                    SizedBox(
                      width: 600,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Name, Email, phone, Role",
                          hintStyle: const TextStyle(color: Colors.grey),
                          fillColor: Colors.grey.withOpacity(0.5),
                          filled: true,
                          suffixIcon: const Icon(Icons.search_rounded),
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
                          onPressed: _pageIndex == (_calculateTotalPages() - 1) ? null : _onNextPage,
                        ),
                      ],
                    ),
                    const SizedBox(width: 15,)
                  ],
                ),
              ),
            ),
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
                            (states) => const Color(0xffea6238),
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
                            'Company Name',
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
                            'POC',
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
                                child:TextButton(onPressed: () =>_viewCompanyDetails('${user.firstName} ${user.lastName}'),
                                    child: Text("${user.firstName} ${user.lastName}",
                                      style: const TextStyle(color: Colors.black,fontSize: 12),
                                      textAlign: TextAlign.center,))
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
                            const DataCell(Text("Trip Admin",

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
    }
  }
}
