import 'package:day_picker/model/day_in_week.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
// import 'package:tec_admin/Data/Models/AddService.dart';
import 'package:tec_admin/Data/Repositories/Add_vehcle_repository.dart';

class AddCompanyDialog extends StatefulWidget {
  const AddCompanyDialog({Key? key}) : super(key: key);

  @override
  _AddCompanyDialogState createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends State<AddCompanyDialog> {



  bool _allDaysSelected = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startdateController = TextEditingController();
  final TextEditingController _enddateController = TextEditingController();
  final TextEditingController _starttimeController = TextEditingController();
  final TextEditingController _endtimeController = TextEditingController();
  final TextEditingController _routeidController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  final TextEditingController _stopsController = TextEditingController();
  final VehicleRepository _repository = VehicleRepository();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 101),
    );
    if (picked != null && (isStartDate || picked.isAfter(_startDate!))) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startdateController.text = '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}';
        } else {
          _endDate = picked;
          _enddateController.text = '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}';
        }
      });
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 1,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Text("Company Name"),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(

                                      controller: _routeidController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_routeidController == null) {
                                          return 'Company Name is  Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  const Text("Email"),
                                  const SizedBox(width: 85),
                                  Expanded(
                                    child: TextFormField(

                                      controller: _pickupController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_startDate == null) {
                                          return 'Email is Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  const Text("Phone   "),
                                  const SizedBox(width: 70),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _dropController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_startDate == null) {
                                          return 'Phone Number is Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  const Text("POC Name         "),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _stopsController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_startDate == null) {
                                          return 'POC Name is Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  const Text("Start Date          "),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: TextFormField(

                                      onTap: () => _selectDate(context, true),
                                      controller: _startdateController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.calendar_month,color: Colours.grey,),
                                        hintText: _startDate == null
                                            ? ''
                                            : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_startDate == null) {
                                          return 'Start Date Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [

                                  const Text("End Date            "),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: TextFormField(
                                      onTap: () => _selectDate(context, false),
                                      controller: _enddateController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.calendar_month,color: Colours.grey,),
                                        hintText: _endDate == null
                                            ? ''
                                            : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                        border: OutlineInputBorder(

                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_endDate == null) {
                                          return 'End Date Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              // Start Time Field
                              ElevatedButton(
                                onPressed: () {
                                  print('Route ID: ${_routeidController.text}');
                                  print('Pickup Location: ${_pickupController.text}');
                                  print('Drop Location: ${_dropController.text}');
                                  print('Stops: ${_stopsController.text}');
                                  print('Start Date: ${_startdateController.text}');
                                  print('End Date: ${_enddateController.text}');





                                  if (_formKey.currentState!.validate()) {
                                    // _submitData();
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
      ),
    );
  }
}
