import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Admin.dart';
import 'package:tec_admin/Data/Repositories/Admin_repo.dart';

class Routepassenger extends StatefulWidget {
  final String companyName;
  final String routeid;
  final VoidCallback onBack;

  const Routepassenger(
      {
        Key? key,
        required this.companyName,
        required this.routeid,
        required this.onBack
      }) : super(key: key);

  @override
  State<Routepassenger> createState() => _RoutepassengerState();
}

class _RoutepassengerState extends State<Routepassenger> {
  List<Admin> users = [];
  bool isLoading = false;
  final int _rowsPerPage = 20;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _editUser(Admin admin) {}
  @override
  void dispose() {
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
  Future<void> _toggleAccess(Admin admin) async {
    try {
      final response = await Dio()
          .delete('http://192.168.20.21:8081/travelease/Admin', data: admin.email);
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
        'http://localhost:8081/travelease/BindAdmin',
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

  Future<void> _refreshData() async {
    _fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.orange,
        centerTitle: false,
        toolbarHeight: 30,
        title: Center(child: Text("${widget.routeid}",style: TextStyle(fontSize: 15,color: Colours.white),)),
        leading: IconButton(
          iconSize: 16,
          icon: Icon(
            Icons.arrow_back,
            color: Colours.white,

          ),
          onPressed: widget
              .onBack,
        ),
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
                            'Email',
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
}
