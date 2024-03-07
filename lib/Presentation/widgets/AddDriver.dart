import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/AddVehicle.dart';
import 'package:tec_admin/Data/Repositories/Add_vehcle_repository.dart';

class AddDriverDialog extends StatefulWidget {
  const AddDriverDialog({super.key});

  @override
  State<AddDriverDialog> createState() => _AddDriverDialogState();
}

class _AddDriverDialogState extends State<AddDriverDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final VehicleRepository _repository = VehicleRepository();

  // Dropdown options
  List<String> vehicleNumbers = ['SPR45', 'SPR56', 'SPR67', 'SPR78', 'SPR89'];
  List<String> vehicleCapacities = ['VAN20', 'BUS30', 'BUS40', 'BUS50', 'BUS60'];
  List<String> driverTypes = ['Sevilai', 'Contract'];

  String? selectedVehicleNumber;
  String? selectedVehicleCapacity;
  String? selectedDriverType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
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
                                const Text("Driver Name"),
                                const SizedBox(width: 65),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Driver Name is required';
                                      }
                                      RegExp regex = RegExp(r'^[a-zA-Z]');
                                      if (!regex.hasMatch(value)) {
                                        return 'It Must be Alphabetical Letters';
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
                                const Text("Email Address"),
                                const SizedBox(width: 52),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _emailController,
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
                                const SizedBox(width: 52),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _phoneNumberController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mobile Number is required';
                                      }
                                      RegExp regex = RegExp(r'^\d{10}$');
                                      if (!regex.hasMatch(value)) {
                                        return 'Enter Valid Phone Number';
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
                                const Text("Vehicle Capacity"),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedVehicleCapacity,
                                    items: vehicleCapacities.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedVehicleCapacity = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vehicle Capacity is required';
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
                                const Text("Vehicle Number"),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedVehicleNumber,
                                    items: vehicleNumbers.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedVehicleNumber = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vehicle Number is required';
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
                                const Text("Driver Type"),
                                const SizedBox(width: 70),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedDriverType,
                                    items: driverTypes.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDriverType = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Driver Type is required';
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
      final Vehicle vehicle = Vehicle(

        capacity: selectedVehicleCapacity!,
        number: selectedVehicleNumber!,
      );
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
