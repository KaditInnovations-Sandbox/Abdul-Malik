import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testapp/Presentation/screens/Companypage.dart';
import 'package:testapp/Presentation/screens/Removedvehicles.dart';
import 'package:testapp/Presentation/screens/Sevilaidrivers.dart';
import 'package:testapp/Presentation/widgets/AddVehicle.dart';
import 'package:testapp/Presentation/screens/Presentvehicles.dart';
import 'package:testapp/Utills/date_time_utils.dart';

class Driver extends StatefulWidget {
  const Driver({Key? key}) : super(key: key);

  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  late String currentTime;
  late String currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Initialize current date and time
    currentTime = DateTimeUtils.getCurrentTime();
    currentDate = DateTimeUtils.getCurrentDate();
    // Update date and time every second
    _timer = Timer.periodic(const Duration(seconds: 0), (timer) {
      setState(() {
        currentTime = DateTimeUtils.getCurrentTime();
        currentDate = DateTimeUtils.getCurrentDate();
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    super.dispose();
  }


  void _addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddVehicleDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate, style: const TextStyle(fontSize: 15, color: Colors.white)),
                  Text(
                    "${currentTime}(SST)",
                    style: const TextStyle(fontSize: 15, color: Colors.white),
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
                const SizedBox(width: 130,),
                ElevatedButton(
                  onPressed: () => _addUser(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffea6238),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Add"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffea6238),
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
                  child: SizedBox(
                    width: constraints.maxWidth,

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.35),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                          color: Colors.black,
                        ),
                        tabs: [
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Sevilai Driver'),
                            ),
                          ),
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Contract Drivers'),
                            ),
                          ),
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Inactive Driver'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Sevilaidrivers(),
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
