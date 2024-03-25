import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Constants/api_constants.dart';

class EditPassengerDialog extends StatefulWidget {
  final String passengerId;
  final String passengername;
  final String passengeremail;
  final String passengerphone;
  final String location;

  const EditPassengerDialog({
    Key? key,
    required this.passengerId,
    required this.passengername,
    required this.passengeremail,
    required this.passengerphone,
    required this.location,
  }) : super(key: key);



  @override
  _EditpassengerDialogState createState() => _EditpassengerDialogState();
}

class _EditpassengerDialogState extends State<EditPassengerDialog> {
  late TextEditingController _passengeridController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _pocController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.passengername);
    _emailController = TextEditingController(text: widget.passengeremail);
    _phoneController = TextEditingController(text: widget.passengerphone);
    _pocController = TextEditingController(text: widget.location);
  }

  @override
  void dispose() {
    _passengeridController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _editUser() async {
    try {
      final response = await Dio().put(
        '${ApiConstants.baseUrl}/Passenger',
        data: {
          "passenger_id" : widget.passengerId,
          "passenger_name" : _nameController.text,
          "passenger_email" : _emailController.text,
          "passenger_phone" : _phoneController.text,
          "passenger_location" : _pocController.text,
        },
      );
      if (response.statusCode == 200) {
        print('Vehicle updated successfully');
      } else {
        print('Failed to update vehicle');
      }
    } catch (error) {
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 1,
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
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text("Passenger Name   :"),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: TextField(
                                    controller: _nameController,
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
                                const Text("Passenger Email   :"),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: TextField(
                                    controller: _emailController,
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
                                const Text("Passenger Number   :"),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
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
                                const Text("Location   :"),
                                const SizedBox(width: 90),
                                Expanded(
                                  child: TextField(
                                    controller: _pocController,
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
        ),
      ),
    );
  }
}
