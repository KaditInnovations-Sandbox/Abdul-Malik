import 'dart:async';
import 'dart:html';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Constants/api_constants.dart';
import 'package:tec_admin/Data/Models/Admin.dart';
import 'package:tec_admin/Data/Repositories/Admin_repo.dart';
import 'package:tec_admin/Presentation//widgets/Addadmin.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';

enum FilterOption {
  all,
  active,
  inactive,
}

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
    setState(() {

      isLoading = true; // Set isLoading to true while fetching data
    });
    try {
      final repository = AdminRepository();
      List<Admin> fetchedUsers = await repository.fetchAdmins();
      print("Data Fetched");
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

  void _editUser(Admin admin) {}

  Future<void> _toggleAccess(Admin admin) async {
    try {
      final response = await Dio()
          .delete('${ApiConstants.baseUrl}/Admin', data: admin.email);
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
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

  Future<void> _grandAccess(Admin admin) async {
    try {
      final response = await Dio().put(
        '${ApiConstants.baseUrl}/BindAdmin',
        data: {
          "admin_name": '${admin.admin_name}',
          "admin_email": '${admin.email}',
        },
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
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

  void _filterUsers() {}

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

  String _generateCsvData(List<Admin> users) {
    String csvData = 'Name,Email,Phone Number,Created At\n';
    for (var user in users) {
      csvData +=
          '${user.admin_name},${user.email},${user.phoneNumber},27/02/2024\n';
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
                Text(currentDate,
                    style: const TextStyle(fontSize: 15, color: Colours.white)),
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
                  )),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _addUser(),
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
              const SizedBox(width: 26),
            ],
          ),
        ],
      ),
      body: isLoading
          ? _buildErrorWidget()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: Colours.white,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => _refreshData(),
                            icon: const Icon(Icons.refresh)),
                        Tooltip(
                          message: "Search Admins",
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
                                (states) => Colours.orange),
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
                                  'Phone Number',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Role',
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
                            rows: users
                                .skip(_pageIndex * _rowsPerPage)
                                .take(_rowsPerPage)
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                              final int index =
                                  entry.key + (_pageIndex * _rowsPerPage);
                              final Admin admin = entry.value;
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
                                      admin.adminid,
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
                                    Text(
                                      "Trip Admin",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      admin.status ? 'Active' : 'Inactive',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: admin.status
                                            ? Colours.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                  const DataCell(
                                    Text(
                                      '20-02-24,15:26',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    Tooltip(
                                      message: "Edit",
                                      child: IconButton(
                                        onPressed: admin.status
                                            ? () => _editUser(admin)
                                            : null,
                                        icon: const Icon(Icons.edit),
                                        color: admin.status
                                            ? Colours.orange
                                            : Colours.grey,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        if (admin.status) {
                                          _toggleAccess(admin);
                                        } else {
                                          _grandAccess(admin);
                                        }
                                      },
                                      icon: Icon(
                                        admin.status
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
