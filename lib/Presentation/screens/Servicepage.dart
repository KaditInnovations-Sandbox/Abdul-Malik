import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Admin.dart';
import 'package:tec_admin/Data/Models/Presentvehicle.dart';
import 'package:tec_admin/Data/Repositories/Admin_repo.dart';
import 'package:tec_admin/Data/Repositories/Present_vehcile_repositories.dart';
import 'package:tec_admin/Presentation/widgets/AddService.dart';
import 'package:tec_admin/Presentation/widgets/Add_passenger.dart';
import 'package:tec_admin/Presentation/widgets/Editvehicle.dart';

class Servicepage extends StatefulWidget {
  const Servicepage({super.key});

  @override
  State<Servicepage> createState() => _ServicepageState();
}

class _ServicepageState extends State<Servicepage> {
  List<Admin> users = [];
  bool isLoading = false;
  final int _rowsPerPage = 10;
  int _pageIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    _fetchData();
    _searchController.addListener(() {
      _filterVehicles(_searchController.text);
    });
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _searchController.dispose();
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
    return (users.length / _rowsPerPage).ceil();
  }

  Future<void> _fetchData() async {
    final repository = AdminRepository();
    List<Admin> fetchedUsers = await repository.fetchAdmins();

    setState(() {
      users = fetchedUsers;
      isLoading = false;
    });

  }
  void _filterVehicles(String query) {
    setState(() {


    });
  }

  Future<void> _refreshData() async {
    _fetchData();
  }
  void _addPassenger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddServiceDialog();
      },
    );
  }

  void _editVehicle(PresentVehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditVehicleDialog(
          vehicleId: vehicle.vehicleid,
          vehicleCapacity: vehicle.vehiclecapacity,
          vehicleNumber: vehicle.vehiclenumber,
        );
      },
    );
  }

  void _toggleAccess(PresentVehicle vehicle) async {
    try {
      final response = await Dio().delete(
        'http://localhost:8081/travelease/Vehicle',
        data: vehicle.vehiclenumber,
      );
      if (response.statusCode == 200) {
        // Handle success, such as updating UI or showing a message
        print('Vehicle access removed successfully');
      } else {
        // Handle error or failure response
        print('Failed to remove vehicle access');
      }
    } catch (error) {
      // Handle Dio error
      print('Error removing vehicle access: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? LinearProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: const AlwaysStoppedAnimation<Color>(Colours.Presentvehicletabletop),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _refreshData();
                      },
                      icon: const Icon(Icons.refresh)),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Enter Passenger Name ,Phone Number",
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.withOpacity(0.5),
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              // _searchVehicles(_searchController.text);
                            },
                            icon: const Icon(Icons.search_rounded)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () => _addPassenger(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.buttonBackground,
                      foregroundColor: Colours.textColor,
                    ),
                    child: const Text("Add"),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: _pageIndex == 0 ? null : _onPreviousPage,
                      ),
                      Text('${_pageIndex + 1} of ${_calculateTotalPages()}'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: _pageIndex == (_calculateTotalPages() - 1)
                            ? null
                            : _onNextPage,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
