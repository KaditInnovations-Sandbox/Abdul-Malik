import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Removedvehicle.dart';
import 'package:tec_admin/Data/Repositories/Present_vehcile_repositories.dart';
import 'package:tec_admin/Data/Repositories/Removed_vehilce_repository.dart';
import 'package:tec_admin/Presentation/screens/Presentvehicles.dart';
import 'package:tec_admin/Presentation/screens/Removedvehicles.dart';
import 'package:tec_admin/Presentation/widgets/AddVehicle.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';
import '../../Data/Models/Presentvehicle.dart';


class VehilceScreen extends StatefulWidget {
  const VehilceScreen({Key? key}) : super(key: key);

  @override
  _VehilceScreenState createState() => _VehilceScreenState();
}

class _VehilceScreenState extends State<VehilceScreen> {
  final PresentVehicleRepository _repository = PresentVehicleRepository();
  List<PresentVehicle> _vehicles = [];
  final RemovedVehicleRepository _repository2 = RemovedVehicleRepository();
  List<RemovedVehicle> _vehicles2 = [];
  late String currentTime;
  late String currentDate;
  late Timer _timer;
  late int _currentTabIndex;
  late String filename;// Track the current active tab index

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    currentTime = DateTimeUtils.getCurrentTime();
    currentDate = DateTimeUtils.getCurrentDate();
    _currentTabIndex = 0; // Initialize to the first tab
    // Update date and time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateTimeUtils.getCurrentTime();
          currentDate = DateTimeUtils.getCurrentDate();
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final vehicles = await _repository.fetchVehicles();
      setState(() {
        _vehicles = vehicles;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _fetchData2() async {
    try {
      final vehicles = await _repository2.fetchRemovedVehicles();
      setState(() {
        _vehicles2 = vehicles;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddVehicleDialog();
      },
    );
  }

  Future<void> _downloaddata() async {
    if (_currentTabIndex == 0) {
      await _fetchData();
      String csvData = _generateCsvData(_vehicles, 'active_vehicles.csv');
      _downloadCsv(csvData);
    } else {
      await _fetchData2();
      String csvData = _generateCsvData(_vehicles2, 'inactive_vehicles.csv');
      _downloadCsv(csvData);
    }
  }

  String _generateCsvData(List<dynamic> vehicles, String fileName) {
    String csvData = 'Vehicle ID,Vehicle Capacity,Vehicle Number,Registered At\n';
    for (var vehicle in vehicles) {
      csvData +=
      '${vehicle.vehicleid},${vehicle.vehiclecapacity},${vehicle.vehiclenumber},${vehicle.registered}\n';
    }
    return csvData;
  }

  void _downloadCsv(String csvData) {
    // Create a Blob containing the CSV data
    Blob blob = Blob([csvData], 'text/csv:charset=utf-8');

    // Create a URL for the Blob
    String url = Url.createObjectUrlFromBlob(blob);

    // Create a link element
    AnchorElement anchor = AnchorElement(href: url)
      ..setAttribute('download', _currentTabIndex == 0 ? 'active_vehicles.csv' : 'inactive_vehicles.csv');


    // Simulate a click to initiate the download
    anchor.click();

    // Revoke the URL to free up memory
    Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colours.appBarBackground,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate,
                      style: const TextStyle(
                          fontSize: 15, color: Colours.textColor)),
                  Text(
                    "${currentTime}(SGT)",
                    style: const TextStyle(
                        fontSize: 15, color: Colours.textColor),
                  ),
                ],
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 130,
                ),
                IconButton(
                  onPressed: () {
                    _downloaddata();
                  },
                  icon: ImageIcon(
                    AssetImage("assets/orange.png"),
                    color: Colours.white,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _addUser(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.buttonBackground,
                    foregroundColor: Colours.textColor,
                  ),
                  child: const Text("Add"),
                ),
                const SizedBox(width: 26),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.35),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colours.textColor,
                        indicator: BoxDecoration(
                          color: Colours.black,
                        ),
                        onTap: (index) {
                          setState(() {
                            _currentTabIndex = index;
                          });
                        },
                        tabs: [
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Active Vehicles'),
                            ),
                          ),
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Inactive Vehicles'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PresentVehicleScreen(),
                  RemovedVehicleScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
