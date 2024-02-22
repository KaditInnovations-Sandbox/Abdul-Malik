// lib/presentation/widgets/add_vehicle_dialog.dart

import 'package:flutter/material.dart';
import 'package:testapp/Constants/Colours.dart';
import 'package:testapp/Data/Models/AddVehicle.dart';
import 'package:testapp/Data/Repositories/Add_vehcle_repository.dart';


class AddVehicleDialog extends StatefulWidget {
  const AddVehicleDialog({Key? key}) : super(key: key);

  @override
  _AddVehicleDialogState createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final VehicleRepository _repository = VehicleRepository();

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
                  _buildInputField(label: 'Vehicle Capacity', hintText: 'BUS40', controller: _capacityController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle Capacity is required';
                    }
                    return null;
                  }),
                  _buildInputField(label: 'Vehicle Number', hintText: 'SPR00000', controller: _numberController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle Number is required';
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.Addvehiclebutton,
                      foregroundColor: Colors.white,
                    ),
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
      final Vehicle vehicle = Vehicle(capacity: _capacityController.text, number: _numberController.text);
      await _repository.addVehicle(vehicle);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting data: $e');
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
}
