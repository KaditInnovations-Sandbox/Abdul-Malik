import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Admin.dart';
import 'package:tec_admin/Data/Repositories/Admin_repo.dart';
import 'package:tec_admin/Presentation//widgets/Addadmin.dart';
import 'package:intl/intl.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';



class Adminpage extends StatefulWidget {
  const Adminpage({super.key, Key});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<Adminpage> {
  List<Admin> users = [];
  bool isLoading = false;
  late String currentTime;
  late String currentDate;
  final bool _isSelectedAll = false;
  final List<Admin> _selectedRows = [];
  late Timer _timer;
  final int _rowsPerPage = 20;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
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

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
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

  void _editUser(Admin admin) {

  }

  void _toggleAccess(Admin admin) {

  }

  void _filterUsers() {

  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddAdminDialog();
      },
    );
  }

  Future<void> _refreshData() async {
    _fetchData();
  }
  Future<void> _downloaddata() async {
    await _fetchData(); // Fetch data from the server

    // Generate CSV data
    String csvData = _generateCsvData(users);

    // Initiate download
    _downloadCsv(csvData);

  }

  String _generateCsvData(List<Admin> users) {
    String csvData = 'Name,Email,Phone Number,Created At\n';
    for (var user in users) {
      csvData += '${user.lastName},${user.email},${user.phoneNumber},27/02/2024\n';
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
      backgroundColor: Colours.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colours.black,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentDate, style: const TextStyle(fontSize: 15, color: Colours.white)),
                Text(
                  "${currentTime}(SGT)",
                  style: const TextStyle(fontSize: 15, color: Colours.white),
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
              IconButton(
                  onPressed: () {
                    _downloaddata();
                  },
                  icon: ImageIcon(
                    AssetImage("assets/orange.png"),
                    color: Colours.white,)
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _addUser(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Add"),
              ),
              const SizedBox(width: 26),
            ],
          ),
        ],
      ),
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
              color: Colours.white,
              child: Row(
                children: [
                  IconButton(onPressed: ()=>_refreshData(), icon: const Icon(Icons.refresh)),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Name, Email, phone, Email",
                        hintStyle: const TextStyle(color: Colours.grey),
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
                              (states) => Colours.orange
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colours.white,
                        fontSize: 12, // Adjust heading font size
                      ),
                      headingRowHeight: 50.0,
                      dataRowHeight: 50.0,
                      dividerThickness: 0,
                      dataTextStyle: const TextStyle(
                        color: Colours.black,
                        fontSize: 11,
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Admin ID',
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                            'Email',
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
                              Text(
                                '${index + 1}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text("${admin.admin_name}"),
                            ),
                            DataCell(
                              Text(
                                admin.email,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                admin.phoneNumber,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const DataCell(
                              Text("Trip Admin", textAlign: TextAlign.center,),
                            ),
                            const DataCell(
                              Text(
                                '20-02-24,15:26',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () => _editUser(admin),
                                icon: const Icon(Icons.edit, color: Color(0xffea6238)),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () => _toggleAccess(admin),
                                icon: const Icon(Icons.remove_circle_outline, color: Color(0xffea6238)),
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
