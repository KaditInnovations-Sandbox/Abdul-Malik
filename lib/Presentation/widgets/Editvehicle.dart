import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testapp/Constants/Colours.dart';

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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colours.textColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      TextField(
                        controller: _capacityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      TextField(
                        controller: _numberController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editUser();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
