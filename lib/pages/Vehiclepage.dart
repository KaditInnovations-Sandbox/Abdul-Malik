import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/pages/Removedvehicles.dart';
import 'package:testapp/widgets/AddVehicle.dart';
import 'package:testapp/pages/Passengersdetails.dart';
import 'package:testapp/pages/Presentvehicles.dart';
import 'package:testapp/pages/Routepage.dart';

class Vehicle extends StatefulWidget {
  const Vehicle({Key? key}) : super(key: key);

  @override
  _VehicleState createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  late String currentTime;
  late String currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    updateTime();
    updateDate();
    // Update date and time every second
    _timer = Timer.periodic(Duration(seconds: 0), (timer) {
      setState(() {
        updateTime();
        updateDate();
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    super.dispose();
  }

  void updateTime() {
    final now = DateTime.now();
    currentTime = DateFormat('hh:mm a').format(now);
  }

  void updateDate() {
    final now = DateTime.now();
    currentDate = DateFormat('MMM dd, yyyy').format(now);
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddVehicleDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate, style: TextStyle(fontSize: 15, color: Colors.white)),
                  Text(
                    currentTime,
                    style: TextStyle(fontSize: 15, color: Colors.white),
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
                SizedBox(width: 130,),
                ElevatedButton(
                  onPressed: () => _addUser(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffea6238),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Add"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffea6238),
                    foregroundColor: Colors.white,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.file_copy_sharp),
                      SizedBox(width: 3,),
                      Text("Export")
                    ],
                  ),
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
                  child: Container(
                    width: constraints.maxWidth,

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.35),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                          color: Colors.black,
                        ),
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
                  Presentvehicle(),
                  Removedvehicle()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
