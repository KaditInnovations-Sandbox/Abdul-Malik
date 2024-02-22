import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({Key? key}) : super(key: key);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  final Dio _dio = Dio();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
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
                  _buildInputField(label: 'Username', hintText: 'Enter username', controller: _usernameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
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
    try {
      // Your API endpoint URL
      const String apiUrl = 'http://localhost:8081/travelease/Admin';

      // Data to be sent to the API
      Map<String, dynamic> adminData = {
        'admin_name': _usernameController.text,
        'admin_password': _passwordController.text,
        'admin_email': _emailController.text,
        'admin_phone': _phoneNumberController.text,
        'admin_first_name': _firstNameController.text,
        'admin_last_name': _lastNameController.text,
      };

      // Data to be sent to the server
      Map<String, dynamic> requestData = {
        'admin': adminData,
        'roleName': _selectedRole,
      };

      // Send POST request
      final Response response = await _dio.post(
        apiUrl,
        data: requestData,
      );

      // Handle response
      if (response.statusCode == 201) {
        // Data sent successfully
        Navigator.of(context).pop();
        // Optionally, show a success message
      } else {
        // Error occurred while sending data
        // Optionally, show an error message
        print('Error: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      // Handle error
      // Optionally, show an error message
      print('Error: $e');
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
