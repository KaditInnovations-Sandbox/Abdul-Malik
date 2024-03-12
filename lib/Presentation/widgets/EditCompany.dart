import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';

class EditCompanyDialog extends StatefulWidget {
  final String companyId;
  final String companyname;
  final String companyemail;
  final String companyphone;
  final String companypoc;
  final String companystart;
  final String companyend;

  const EditCompanyDialog({
    Key? key,
    required this.companyId,
    required this.companyname,
    required this.companyemail,
    required this.companyphone,
    required this.companypoc,
    required this.companystart,
    required this.companyend,
  }) : super(key: key);



  @override
  _EditCompanyDialogState createState() => _EditCompanyDialogState();
}

class _EditCompanyDialogState extends State<EditCompanyDialog> {
  late TextEditingController _companyidController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _pocController;
  late TextEditingController _startController;
  late TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _companyidController = TextEditingController(text: widget.companyId);
    _nameController = TextEditingController(text: widget.companyname);
    _emailController = TextEditingController(text: widget.companyemail);
    _phoneController = TextEditingController(text: widget.companyphone);
    _pocController = TextEditingController(text: widget.companypoc);
    _startController = TextEditingController(text: widget.companystart);
    _endController = TextEditingController(text: widget.companyend);
  }

  @override
  void dispose() {
    _companyidController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _editUser() async {
    try {
      final response = await Dio().put(
        'http://localhost:8081/travelease/Company',
        data: {
          "company_id": widget.companyId,
          "company_name" : _nameController.text,
          "company_email" : _emailController.text,
          "company_phone" : _phoneController.text,
          "company_poc" : _pocController.text,
          "company_start_date" : _startController.text,
          "company_end_date" : _endController.text,
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
                                const Text("Company Name   :"),
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
                                const Text("Company Email   :"),
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
                                const Text("Company Number   :"),
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
                                const Text("POC Number   :"),
                                const SizedBox(width: 55),
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
                            Row(
                              children: [
                                const Text("Start Date   :"),
                                const SizedBox(width: 70),
                                Expanded(
                                  child: TextField(
                                    controller: _startController,
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
                                const Text("End Date   :"),
                                const SizedBox(width: 75),
                                Expanded(
                                  child: TextField(
                                    controller: _endController,
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
