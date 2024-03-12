import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tec_admin/Data/Models/Addadmin_model.dart';
import 'package:tec_admin/Data/Repositories/Addadmin_repo.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({Key? key}) : super(key: key);

  @override
  _AddAdminDialogState createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  final AdminRepository _adminRepository = AdminRepository();


  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _AdminnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  _buildInputField(label: 'First Name', hintText: 'Enter first name', controller: _firstNameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  }),
                  _buildInputField(label: 'Last Name', hintText: 'Enter last name', controller: _lastNameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  }),
                  _buildInputField(label: 'Phone Number', hintText: 'Enter phone number', controller: _phoneNumberController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  }),
                  _buildInputField(label: 'Adminname', hintText: 'Enter Adminname', controller: _AdminnameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adminname is required';
                    }
                    return null;
                  }),
                  _buildInputField(label: 'Email', hintText: 'Enter email', controller: _emailController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!isValidEmail(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  }),
                  _buildInputField(label: 'Password', hintText: 'Enter password', controller: _passwordController, isObscure: true, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  }),
                  const SizedBox(height: 10),
                  _buildDropdown(label: 'Role', validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Role is required';
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitData();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitData() async {
    final AdminModel admin = AdminModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      adminName: _AdminnameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      rolename: _selectedRole.toString(),
    );

    try {
      await _adminRepository.addAdmin(admin);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  Widget _buildInputField({required String label, required String hintText, TextEditingController? controller, bool isObscure = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isObscure,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({required String label, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              onChanged: (String? value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'TRIP_ADMIN',
                  child: Text('TRIP_ADMIN', style: TextStyle(fontSize: 16)),
                ),
                DropdownMenuItem(
                  value: 'SUPER_ADMIN',
                  child: Text('SUPER_ADMIN', style: TextStyle(fontSize: 16)),
                ),
              ],
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    // Simple email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
