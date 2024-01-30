import 'package:flutter/material.dart';


class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String role;
  bool hasAccess;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    this.hasAccess = true,
  });
}



class Admin extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<Admin> {
  List<User> users = [
    User(firstName: 'John', lastName: 'Doe', phoneNumber: '1234567890', role: 'Admin'),
    User(firstName: 'Jane', lastName: 'Doe', phoneNumber: '9876543210', role: 'User'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text('First Name')),
            DataColumn(label: Text('Last Name')),
            DataColumn(label: Text('Phone Number')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Remove Access')),
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
                  IconButton(
                    icon: Icon(user.hasAccess ? Icons.check : Icons.close),
                    onPressed: () => _toggleAccess(user),
                  ),
                ),
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
              color: user.hasAccess ? null : MaterialStateProperty.all(Colors.grey),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _filterUsers(),
            child: Icon(Icons.filter_list),
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

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            children: [
              TextFormField(
                initialValue: user.firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                onChanged: (value) => user.firstName = value,
              ),
              TextFormField(
                initialValue: user.lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                onChanged: (value) => user.lastName = value,
              ),
              TextFormField(
                initialValue: user.phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) => user.phoneNumber = value,
              ),
              DropdownButtonFormField<String>(
                value: user.role,
                decoration: InputDecoration(labelText: 'Role'),
                items: ['Admin', 'User'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    user.role = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(User user) {
    setState(() {
      users.remove(user);
    });
  }

  void _toggleAccess(User user) {
    setState(() {
      user.hasAccess = !user.hasAccess;
    });
  }

  void _filterUsers() {
    // Implement filter logic here
    // You can use another dialog or a bottom sheet to get filter criteria
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        User newUser = User(firstName: '', lastName: '', phoneNumber: '', role: 'User');
        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Add User'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value) => newUser.firstName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name'),
                  onChanged: (value) => newUser.lastName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value) => newUser.phoneNumber = value,
                ),
                DropdownButtonFormField<String>(
                  value: newUser.role,
                  decoration: InputDecoration(labelText: 'Role'),
                  items: ['Admin', 'User'].map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      newUser.role = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    users.add(newUser);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
