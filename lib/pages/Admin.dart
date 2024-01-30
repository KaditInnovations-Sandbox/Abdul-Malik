import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

class Admin extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<Admin> {
  List<User> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is first created
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Replace 'https://your-api-endpoint' with your actual API endpoint
      final response = await Dio().get('http://localhost:8081/travelease/Admin');

      // Parse the response and update the state
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
      // You can show a snack bar or other error UI feedback if needed
      // For simplicity, just printing the error here
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _editUser(User user) {
    // Implement edit user logic here
  }

  void _deleteUser(User user) {
    // Implement delete user logic here
  }

  void _toggleAccess(User user) {
    // Implement toggle access logic here
  }

  void _filterUsers() {
    // Implement filter logic here
    // You can use another dialog or a bottom sheet to get filter criteria
  }

  void _addUser() {
    // Implement add user logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Details'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? LinearProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
      )
          : Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.transparent, // Background color of the header row
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.deepOrange.shade400), // Color of the header row
              dataRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white), // Color of the data rows
              columnSpacing: 20.0,
              headingTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color of column headers
              ),
              dataRowHeight: 60.0,
              dataTextStyle: TextStyle(
                color: Colors.deepOrange.shade400, // Text color of data cells
              ),
              decoration: BoxDecoration(
                color: Colors.transparent, // Background color of the table cells
                borderRadius: BorderRadius.circular(10.0),
              ),
              columns: [
                DataColumn(label: Text('First Name')),
                DataColumn(label: Text('Last Name')),
                DataColumn(label: Text('Phone Number')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Actions')),
              ],
              rows: users.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.firstName)),
                    DataCell(Text(user.lastName)),
                    DataCell(Text(user.phoneNumber)),
                    DataCell(Text(user.role)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editUser(user),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteUser(user),
                          ),
                        ],
                      ),
                    ),
                  ],
                  color: MaterialStateProperty.all(Colors.transparent),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _filterUsers(),
            child: Icon(Icons.filter_alt),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _addUser(),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
