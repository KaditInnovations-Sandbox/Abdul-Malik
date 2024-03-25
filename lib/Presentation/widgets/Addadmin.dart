import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Addadmin_model.dart';
import 'package:tec_admin/Data/Repositories/Addadmin_repo.dart';



class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({Key? key}) : super(key: key);

  @override
  _AddAdminDialogState createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final AdminRepository _adminRepository = AdminRepository();
  late AddAdminModel _adminModel;
  List<String> roles = ['SUPER_ADMIN', 'TRIP_ADMIN'];
  String? _selectedRole;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child:Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.8,
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
                  child: Text("Add Admin",style: TextStyle(fontWeight: FontWeight.bold),),
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
                                const Text("Admin Name"),
                                const SizedBox(width: 65),
                                Expanded(
                                  child: _buildInputField(
                                    hintText: '',
                                    controller: _adminNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Admin Name is required';
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
                                const Text("Admin Type"),
                                const SizedBox(width: 70),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedRole,
                                    items: roles.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Admin Type is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
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
      ) ,
    );
  }

  void _submitData() async {
    _adminModel = AddAdminModel(
      roleName: _selectedRole!,
      admin: {
        'admin_name': _adminNameController.text,
        'admin_password': _passwordController.text,
        'admin_email': _emailController.text,
        'admin_phone': _phoneNumberController.text,
      },
    );

    try {
      await _adminRepository.addAdmin(_adminModel);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error: $e');
      // Handle error
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
  Widget _buildDropdown({required String label, String? Function(String?)? validator}) {
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
            child: DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              onChanged: (String? value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'TRIP_ADMIN',
                  child: Text('TRIP_ADMIN', style: TextStyle(fontSize: 16)),
                ),
                DropdownMenuItem(
                  value: 'SUPER_ADMIN',
                  child: Text('SUPER_ADMIN', style: TextStyle(fontSize: 16)),
                ),
              ],
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    // Simple email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
