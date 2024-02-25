import 'package:day_picker/model/day_in_week.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
// import 'package:tec_admin/Data/Models/AddService.dart';
import 'package:tec_admin/Data/Repositories/Add_vehcle_repository.dart';

class AddServiceDialog extends StatefulWidget {
  const AddServiceDialog({Key? key}) : super(key: key);

  @override
  _AddServiceDialogState createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {

  final List<DayInWeek> _days = [
    DayInWeek("S", dayKey: "Sunday"),
    DayInWeek("M", dayKey: "Monday"),
    DayInWeek("T", dayKey: "Tuesday"),
    DayInWeek("W", dayKey: "Wednesday"),
    DayInWeek("T", dayKey: "Thursday"),
    DayInWeek("F", dayKey: "Friday"),
    DayInWeek("S", dayKey: "Saturday"),
  ];

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
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

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

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          _starttimeController.text = '${_startTime!.hour}:${_startTime!.minute}';
        } else {
          _endTime = picked;
          _endtimeController.text = '${_endTime!.hour}:${_endTime!.minute}';
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
              height: MediaQuery.of(context).size.height * 2,
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
                                  const Text("Route ID             "),
                                  const SizedBox(width: 18),
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
                                          return 'Route ID Required';
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
                                  const Text("Pickup Location"),
                                  const SizedBox(width: 18),
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
                                          return 'Pickup  Required';
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
                                  const Text("Drop Location   "),
                                  const SizedBox(width: 18),
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
                                          return 'Drop Location Required';
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
                                  const Text("Stops                  "),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _stopsController,
                                      decoration: InputDecoration(
                                        hintText: "Stop1 , Stop 2 ,Stop 3",
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_startDate == null) {
                                          return 'Stops are Required';
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _allDaysSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        _allDaysSelected = value!;
                                        _days.forEach((day) {
                                          day.isSelected = _allDaysSelected;
                                        });
                                      });
                                    },
                                  ),
                                  Text("All Days     "),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 20,
                                      children: _days.map((day) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              day.isSelected = !day.isSelected;
                                              _allDaysSelected = _days.every((day) => day.isSelected);
                                            });
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: day.isSelected ? Colours.orange : Colors.white,
                                              borderRadius: BorderRadius.circular(40),
                                              border: Border.all(
                                                color: day.isSelected ? Colours.orange : Colors.black,
                                              ),
                                            ),
                                            child:Center(
                                              child: Text(
                                                day.dayName,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: day.isSelected ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              // Start Time Field
                              Row(
                                children: [
                                  const Text("Start Time              "),

                                  Expanded(
                                    child: TextFormField(

                                      onTap: () => _selectTime(context, true),
                                      controller: _starttimeController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.access_time,color: Colours.grey,),
                                        hintText: _startTime == null
                                            ? ''
                                            : '${_startTime!.hour}:${_startTime!.minute}',
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_startTime == null) {
                                          return 'Start Time Required';
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

                                  const Text("End Time                "),
                                  Expanded(
                                    child: TextFormField(
                                      onTap: () => _selectTime(context, false),
                                      controller: _endtimeController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.access_time,color: Colours.grey,),
                                        hintText: _endTime == null
                                            ? ''
                                            : '${_endTime!.hour}:${_endTime!.minute}',
                                        border: OutlineInputBorder(
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      validator: (value) {
                                        if (_endTime == null) {
                                          return 'End Time Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              // Add Button
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  print('Route ID: ${_routeidController.text}');
                                  print('Pickup Location: ${_pickupController.text}');
                                  print('Drop Location: ${_dropController.text}');
                                  print('Stops: ${_stopsController.text}');
                                  print('Start Date: ${_startdateController.text}');
                                  print('End Date: ${_enddateController.text}');
                                  print('Start Time: ${_starttimeController.text}');
                                  print('End Time: ${_endtimeController.text}');
                                  if (_formKey.currentState!.validate()) {
                                    // _submitData();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colours.orange,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                ),
                                child: const Text(
                                  'Submit',
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
