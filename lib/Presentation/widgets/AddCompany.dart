import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/AddCompany.dart';
import 'package:tec_admin/Data/Repositories/Add_Company_repo.dart';
import 'package:universal_html/html.dart' as html;



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
  final TextEditingController _companynameController = TextEditingController();
  final TextEditingController _companyemailController = TextEditingController();
  final TextEditingController _companyephoneController = TextEditingController();
  final TextEditingController _companyepocController = TextEditingController();
  final CompanyRepository _repository = CompanyRepository();

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
          _startdateController.text = '${_startDate!.day.toString().padLeft(2, '0')}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.year}';
        } else {
          _endDate = picked;
          _enddateController.text = '${_endDate!.day.toString().padLeft(2, '0')}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.year}';
        }
      });
    }
  }


  void _submitData() async {
    try {
      final Company company = Company(
          Companyname: _companynameController.text,
          Companyemail: _companyemailController.text,
          Companyphone: _companyephoneController.text,
          Companypoc: _companyepocController.text,
          Companystart: _startdateController.text,
          Companyend: _enddateController.text
      );
      await _repository.addCompany(company);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 1,
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
                  child: Text("Add Company",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: SingleChildScrollView(
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
                                    controller: _companynameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    ),
                                    validator: (value) {
                                      if (_companynameController == null) {
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

                                    controller: _companyemailController,
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
                                    controller: _companyephoneController,
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
                                    controller: _companyepocController,
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
                                print('Route ID: ${_companynameController.text}');
                                print('companyemail Location: ${_companyemailController.text}');
                                print('companyephone Location: ${_companyephoneController.text}');
                                print('companyepoc: ${_companyepocController.text}');
                                print('Start Date: ${_startdateController.text}');
                                print('End Date: ${_enddateController.text}');
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
                            Center(
                                child: TextButton(
                                  onPressed: () async {
                                    // Check if running on web
                                    if (kIsWeb) {
                                      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                                      uploadInput.accept = 'csv'; // Only accept CSV files
                                      uploadInput.click();

                                      uploadInput.onChange.listen((event) {
                                        final files = uploadInput.files;
                                        if (files != null && files.isNotEmpty) {
                                          final file = files[0];
                                          final fileType = file.type;
                                          if (fileType == 'text/csv' || fileType == 'application/vnd.ms-excel') {
                                            // Handle selected CSV file
                                            print('Selected CSV file: ${file.name}');
                                          } else {
                                            // Show alert for invalid file type
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Invalid File Type'),
                                                  content: Text('Please choose a CSV file.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                      });
                                    } else {
                                      // Platform not supported
                                      print('File picking is not supported on this platform');
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined, color: Colours.grey,),
                                      SizedBox(width: 5,),
                                      Text("Drop Your Files Here", style: TextStyle(color: Colours.grey),)
                                    ],
                                  ),
                                )

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
      ),
    );
  }
}
