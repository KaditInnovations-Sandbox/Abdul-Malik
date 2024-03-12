import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Companymodel.dart';
import 'package:tec_admin/Data/Repositories/Company_repo.dart';
import 'package:tec_admin/Presentation/screens/Companydetails.dart';
import 'package:tec_admin/Presentation/widgets/AddCompany.dart';
import 'package:tec_admin/Presentation/widgets/EditCompany.dart';
import '../../Utills/date_time_utils.dart';

enum FilterOption {
  all,
  active,
  inactive,
}

class Company extends StatefulWidget {
  const Company({Key? key}) : super(key: key);

  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  final CompanyRepository _repository = CompanyRepository();
  List<Companymodel> _originalCompany = [];
  List<Companymodel> _filteredCompany = [];
  bool isLoading = false;
  bool showCompanyDetailsPage = false;
  late String companyName;
  late String currentTime;
  late String currentDate;
  late Timer _timer;
  final int _rowsPerPage = 20;
  int _pageIndex = 0;
  FilterOption _selectedFilter = FilterOption.all;

  @override
  void initState() {
    super.initState();
    currentTime = DateTimeUtils.getCurrentTime();
    currentDate = DateTimeUtils.getCurrentDate();
    // Update date and time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTimeUtils.getCurrentTime();
        currentDate = DateTimeUtils.getCurrentDate();
      });
    });
    _fetchData();
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    super.dispose();
  }

  void _onPreviousPage() {
    setState(() {
      _pageIndex = (_pageIndex - 1).clamp(0, (_calculateTotalPages() - 1));
    });
  }

  void _onNextPage() {
    setState(() {
      _pageIndex = (_pageIndex + 1).clamp(0, (_calculateTotalPages() - 1));
    });
  }

  int _calculateTotalPages() {
    return (_filteredCompany.length / _rowsPerPage).ceil();
  }

  Future<void> _refreshData() async {
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final vehicles = await _repository.fetchVehicles();
      setState(() {
        _originalCompany = vehicles;
        _applyFilter(_selectedFilter);
      });
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _editCompanymodel(Companymodel Company) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCompanyDialog(
          companyId: Company.Companyid,
          companyname: Company.Companyname,
          companyemail: Company.Companyemail,
          companyphone: Company.Companyphone,
          companypoc: Company.Companypoc,
          companystart: Company.Companystart,
          companyend: Company.Companyend,
        );
      },
    );
  }

  Future<void> _toggleAccess(Companymodel Company) async {
    try {
      final response = await Dio().delete(
        'http://localhost:8081/travelease/Company',
        data: {
          "company_name" : '${Company.Companyname}'
        },
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        print('Company access removed successfully');
      } else {
        // Handle error or failure response
        print('Failed to remove vehicle access');
      }
    } catch (error) {
      // Handle Dio error
      print('Error removing vehicle access: $error');
    }
  }

  Future<void> _grandAccess(Companymodel Company) async {
    try {
      final response = await Dio().put(
        'http://localhost:8081/travelease/BindCompany',
        data: {
          "company_name" : '${Company.Companyname}'
        },
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        print('Company access granted successfully');
      } else {
        // Handle error or failure response
        print('Failed to grant vehicle access');
      }
    } catch (error) {
      // Handle Dio error
      print('Error granting vehicle access: $error');
    }
  }

  void _filter_company(FilterOption filterOption) {
    setState(() {
      _selectedFilter = filterOption;
      _applyFilter(filterOption);
    });
  }

  void _applyFilter(FilterOption filterOption) {
    switch (filterOption) {
      case FilterOption.all:
        _filteredCompany = List.from(_originalCompany);
        break;
      case FilterOption.active:
        _filteredCompany = _originalCompany.where((company) => company.status).toList();
        break;
      case FilterOption.inactive:
        _filteredCompany = _originalCompany.where((company) => !company.status).toList();
        break;
    }
  }

  void _addCompanymodel() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddCompanyDialog();
      },
    );
  }

  void _goBack() {
    setState(() {
      _timer.cancel();
      showCompanyDetailsPage = false;
    });
  }

  void _viewCompanyDetails(String companyName) {
    setState(() {
      showCompanyDetailsPage = true;
      this.companyName = companyName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showCompanyDetailsPage) {
      return CompanyDetailsPage(companyName: companyName, onBack: _goBack);
    } else {
      return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colours.black,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate, style: const TextStyle(fontSize: 15, color: Colours.white)),
                  Text("${currentTime}(SGT)", style: const TextStyle(fontSize: 15, color: Colours.white)),
                ],
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 130,),
                IconButton(
                  onPressed: () {},
                  icon: ImageIcon(
                    AssetImage("assets/orange.png"),
                    color: Colours.white,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _addCompanymodel(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.orange,
                    foregroundColor: Colours.white,
                  ),
                  child: const Text("Add"),
                ),
                const SizedBox(width: 26),
              ],
            ),
          ],
        ),
        body: isLoading
            ? Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colours.Presentvehicletabletop,
          child: Container(
            height: 4.0, // Adjust the height of the shimmer effect
            color: Colors.white,
          ),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colours.white,
                child: Row(
                  children: [
                    Tooltip(
                      message: 'Refresh', // Tooltip message to display when hovering
                      child: IconButton(
                        onPressed: () => _refreshData(),
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                    Tooltip(
                      message: "Search Companies",
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.28,
                        height: 30,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Name, Email, phone, Role",
                            hintStyle: TextStyle(color: Colours.black,fontSize: 15,),
                            fillColor: Colors.grey[300],
                            filled: true,
                            suffixIcon: const Icon(Icons.search_rounded),
                            border: OutlineInputBorder( // Specify border here
                              // Adjust border radius as needed
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust content padding to ensure text appears inside the border
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10,),
                    PopupMenuButton<FilterOption>(
                      onSelected: (FilterOption result) {
                        setState(() {
                          _filter_company(result);
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterOption>>[
                        const PopupMenuItem<FilterOption>(
                          value: FilterOption.all,
                          child: Text('All'),
                        ),
                        const PopupMenuItem<FilterOption>(
                          value: FilterOption.active,
                          child: Text('Active'),
                        ),
                        const PopupMenuItem<FilterOption>(
                          value: FilterOption.inactive,
                          child: Text('Inactive'),
                        ),
                      ],
                      icon: const Icon(Icons.filter_alt,color: Colours.orange,),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Previous Page",
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: _pageIndex == 0 ? null : _onPreviousPage,
                          ),
                        ),
                        Tooltip(
                            message: "${_pageIndex + 1} of ${_calculateTotalPages()}",
                            child: Text('${_pageIndex + 1} of ${_calculateTotalPages()}')),
                        Tooltip(
                          message: "Next Page",
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: _pageIndex == (_calculateTotalPages() - 1) ? null : _onNextPage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15,)
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colours.white,
                    padding: const EdgeInsets.all(20.0),
                    child: DataTable(
                      columnSpacing: 5.0,
                      headingRowColor: MaterialStateProperty.resolveWith(
                            (states) =>  Colours.orange,
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colours.white,
                        fontSize: 12, // Adjust heading font size
                      ),
                      headingRowHeight: 50.0,
                      dataRowHeight: 50.0,
                      dividerThickness: 0,
                      dataTextStyle: const TextStyle(
                        color: Colours.black,
                        fontSize: 11,
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Company ID',
                            textAlign: TextAlign.center, // Center align the heading
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Company Name',
                            textAlign: TextAlign.center, // Center align the heading
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Phone Number',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Start Date',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'End Date',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'POC',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Created at',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Edit',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Remove Access',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: _filteredCompany.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final Companymodel Company = entry.value;
                        final Color color =
                        index.isOdd ? Colors.grey[300]! : Colors.grey[100]!;
                        return DataRow(
                          color: MaterialStateProperty.all(color),
                          cells: [
                            DataCell(
                              Text(
                                '${Company.Companyid}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(TextButton(onPressed: () => _viewCompanyDetails('${Company.Companyname}'),
                                child: Text("${Company.Companyname}",
                                  style: const TextStyle(color: Colours.orange, fontSize: 12),
                                  textAlign: TextAlign.center,))),
                            DataCell(
                              Text(Company.Companyemail, textAlign: TextAlign.center,),
                            ),
                            DataCell(Text(Company.Companyphone,
                              textAlign: TextAlign.center,
                            ),),
                            DataCell(
                              Text(
                                Company.Companystart,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                Company.Companyend,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                                Text(
                                  Company.Companypoc,
                                  textAlign: TextAlign.center,)
                            ),
                            DataCell(
                              Text(
                                Company.status ? 'Active' : 'Inactive',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Company.status ? Colours.green : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                DateFormat('MMM dd, yyyy').format(DateTime.parse(Company.Companycreatedat)),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            DataCell(
                              Tooltip(
                                message:"Edit",
                                child: IconButton(
                                  onPressed: Company.status
                                      ? () => _editCompanymodel(Company)
                                      : null,
                                  icon: const Icon(Icons.edit),
                                  color: Company.status ? Colours.orange : Colours.grey,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () {
                                  if (Company.status) {
                                    _toggleAccess(Company);
                                  } else {
                                    _grandAccess(Company);
                                  }
                                },
                                icon: Icon(
                                  Company.status
                                      ? Icons.remove_circle_outline
                                      : Icons.add_circle_outline,
                                  color: Colours.orange,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
