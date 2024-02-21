import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditVehicleDialog extends StatefulWidget {
  final String vehicleId;
  final String vehicleCapacity;
  final String vehicleNumber;

  const EditVehicleDialog({
    Key? key,
    required this.vehicleId,
    required this.vehicleCapacity,
    required this.vehicleNumber,
  }) : super(key: key);

  @override
  _EditVehicleDialogState createState() => _EditVehicleDialogState();
}

class _EditVehicleDialogState extends State<EditVehicleDialog> {
  late TextEditingController _capacityController;
  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _capacityController = TextEditingController(text: widget.vehicleCapacity);
    _numberController = TextEditingController(text: widget.vehicleNumber);
  }

  @override
  void dispose() {
    _capacityController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _editUser() async {
    try {
      final response = await Dio().put(
        'http://localhost:8081/travelease/Vehicle',
        data: {
          "vehicle_id" : widget.vehicleId,
          "vehicle_capacity": _capacityController.text,
          "vehicle_number": _numberController.text,
        },
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        print('Vehicle updated successfully');
      } else {
        // Handle error or failure response
        print('Failed to update vehicle');
      }
    } catch (error) {
      // Handle Dio error
      print('Error updating vehicle: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Vehicle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _capacityController,
            decoration: InputDecoration(labelText: 'Vehicle Capacity'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _numberController,
            decoration: InputDecoration(labelText: 'Vehicle Number'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _editUser();
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
