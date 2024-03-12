import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/AddVehicle.dart';
import 'package:tec_admin/Data/Repositories/Add_vehcle_repository.dart';

class AddPassengerDialog extends StatefulWidget {
  const AddPassengerDialog({super.key});

  @override
  State<AddPassengerDialog> createState() => _AddPassengerDialogState();
}

class _AddPassengerDialogState extends State<AddPassengerDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final VehicleRepository _repository = VehicleRepository();


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
                  child: Text("Add Passenger",style: TextStyle(fontWeight: FontWeight.bold),),
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
                                const Text("Passengers Name"),
                                const SizedBox(width: 65),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _capacityController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Passengers is required';
                                      }
                                      RegExp regex = RegExp(r'^[a-zA-Z]');
                                      if (!regex.hasMatch(value)) {
                                        return 'It Must be Alphabetical Letters';
                                      }
                                      return null;
                                      return null;
                                    },
                                  ),
                                ),
                      
                      
                              ],
                            ),
                            SizedBox(height: 21,),
                            Row(
                              children: [
                                const Text("Email Address"),
                                const SizedBox(width: 90),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _numberController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email Address is required';
                                      }
                                      RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                      if (!regex.hasMatch(value)) {
                                        return 'Email Format is Missing';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                      
                      
                              ],
                            ),
                            SizedBox(height: 21,),
                            Row(
                              children: [
                                const Text("Phone Number"),
                                const SizedBox(width: 90),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _capacityController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mobile Number  is required';
                                      }
                                      RegExp regex = RegExp(r'^d{10}$');
                                      if (!regex.hasMatch(value)) {
                                        return 'Enter Valid Phone Number';
                                      }
                                      return null;
                                      return null;
                                    },
                                  ),
                                ),
                      
                      
                              ],
                            ),
                            SizedBox(height: 21,),
                            Row(
                              children: [
                                const Text("Location"),
                                const SizedBox(width: 125),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _numberController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Location is required';
                                      }
                                      RegExp regex = RegExp(r'^[a-zA-Z]$');
                                      if (!regex.hasMatch(value)) {
                                        return 'Enter Valid Location';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                      
                      
                              ],
                            ),
                            SizedBox(height: 21,),
                            Row(
                              children: [
                                const Text("Stop ID"),
                                const SizedBox(width: 135),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _numberController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Stop ID is required';
                                      }
                                      RegExp regex = RegExp(r'^[a-zA-Z]{5}\d{4}$');
                                      if (!regex.hasMatch(value)) {
                                        return '(e.g., ABCD1234)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                      
                      
                              ],
                            ),
                            SizedBox(height: 21,),
                            Row(
                              children: [
                                const Text("Route ID"),
                                const SizedBox(width: 125),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _numberController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Route ID  is required';
                                      }
                                      RegExp regex = RegExp(r'^[a-zA-Z]{5}\d{5}$');
                                      if (!regex.hasMatch(value)) {
                                        return '(e.g., ABCDE12345)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                      
                      
                              ],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submitData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colours.orange,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Center(
                              child: TextButton(onPressed: (){}, child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined,color: Colours.grey,),
                                  SizedBox(width: 5,),
                                  Text("Drop Your Files Here",style: TextStyle(color: Colours.grey),)
                                ],
                              )),
                            )
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
  void _submitData() async {
    try {
      final Vehicle vehicle = Vehicle(capacity: _capacityController.text, number: _numberController.text);
      await _repository.addVehicle(vehicle);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  Widget _buildInputField({required String hintText, TextEditingController? controller, String? Function(String?)? validator}) {
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
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }
}
