import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Constants/api_constants.dart';

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
        '${ApiConstants.baseUrl}/Vehicle',
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
      backgroundColor: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text("Vehicle Capacity :"),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextField(
                                controller: _capacityController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text("Vehicle Number   :"),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextField(
                                controller: _numberController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(

                          onPressed: () {
                            _editUser();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colours.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text('Update',style: TextStyle(color: Colours.white),),
                        ),
                      ],
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
}
