import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddVehicleDialog extends StatefulWidget {
  const AddVehicleDialog({Key? key}) : super(key: key);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  final Dio _dio = Dio();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();


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
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  _buildInputField(label: 'Vehicle Capacity', hintText: 'Enter first name', controller: _firstNameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle Capacity  is required';
                    }
                    return null;
                  }),
                  _buildInputField(label: 'Vehicle Number', hintText: 'Enter last name', controller: _lastNameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle Number is required';
                    }
                    return null;
                  }),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitData();
                      }
                    },
                    child: Text('Add'),
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
      final String apiUrl = 'http://localhost:8081/travelease/Vehicle';

      // Data to be sent to the API
      Map<String, dynamic> adminData = {
        'vehicle_capacity': _firstNameController.text,
        'vehicle_number': _lastNameController.text,
      };


      // Send POST request
      final Response response = await _dio.post(
        apiUrl,
        data: adminData,
      );

      // Handle response
      if (response.statusCode == 200) {
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isObscure,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
