import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Add_passenger_model.dart';
import 'package:tec_admin/Data/Repositories/Add_passenger_repo.dart';
import 'package:universal_html/html.dart' as html;

class AddPassengerDialog extends StatefulWidget {
  final String companyname;
  const AddPassengerDialog({Key? key, required this.companyname}) : super(key: key);

  @override
  State<AddPassengerDialog> createState() => _AddPassengerDialogState();
}

class _AddPassengerDialogState extends State<AddPassengerDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passengernameController = TextEditingController();
  final TextEditingController _passengeremailController = TextEditingController();
  final TextEditingController _passengerphoneController = TextEditingController();
  final TextEditingController _passengerlocationController = TextEditingController();
  final PassengerRepository _repository = PassengerRepository();

  void _submitData() async {

    try {
      final Passenger passenger = Passenger(
        Passengername: _passengernameController.text,
        Passengeremail: _passengeremailController.text,
        Passengerphone: _passengerphoneController.text,
        Passengerlocation: _passengerlocationController.text,
      );
      await _repository.addPassenger(widget.companyname,passenger);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
                Center(
                  child: Text(
                    "Add Passenger",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text("Passenger's Name"),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: 'Enter name',
                                    controller: _passengernameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Passenger name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 21),
                            Row(
                              children: [
                                const Text("Email Address"),
                                const SizedBox(width: 50),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: 'Enter email',
                                    controller: _passengeremailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email address is required';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 21),
                            Row(
                              children: [
                                const Text("Phone Number"),
                                const SizedBox(width: 50),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: 'Enter phone number',
                                    controller: _passengerphoneController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Phone number is required';
                                      }
                                      if (!RegExp(r'^\+65\d{8}$').hasMatch(value)) {
                                        return 'Enter a valid mobile number starting with +65';
                                      }
                                      if (value.length > 12) {
                                        return 'Phone number should not exceed 12 digits';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 21),
                            Row(
                              children: [
                                const Text("Location"),
                                const SizedBox(width: 85),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: 'Enter location',
                                    controller: _passengerlocationController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Location is required';
                                      }
                                      // Add location validation here if needed
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 21),
                            ElevatedButton(
                              onPressed: () {
                                print("Company name : ${widget.companyname}");
                                if (_formKey.currentState!.validate()) {
                                  _submitData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colours.orange,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  if (kIsWeb) {
                                    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                                    uploadInput.accept = 'csv';
                                    uploadInput.click();
                                    uploadInput.onChange.listen((event) {
                                      final files = uploadInput.files;
                                      if (files != null && files.isNotEmpty) {
                                        final file = files[0];
                                        print('Selected CSV file: ${file.name}');
                                      }
                                    });
                                  } else {
                                    print('File picking is not supported on this platform');
                                  }

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colours.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Drop Your Files Here",
                                      style: TextStyle(color: Colours.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
