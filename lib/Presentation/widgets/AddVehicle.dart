import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/AddVehicle.dart';
import 'package:tec_admin/Data/Repositories/Add_vehcle_repository.dart';

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
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text("Vehicle Capacity :"),
                              const SizedBox(width: 18),
                              Expanded(
                                child: _buildInputField(
                                  hintText: 'BUS40',
                                  controller: _capacityController,
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
                          Row(
                            children: [
                              const Text("Vehicle Number   :"),
                              const SizedBox(width: 18),
                              Expanded(
                                child: _buildInputField(
                                  hintText: 'SPR00000',
                                  controller: _numberController,
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
                          const SizedBox(height: 20),
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
                          SizedBox(height: 3,),
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
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }
}
