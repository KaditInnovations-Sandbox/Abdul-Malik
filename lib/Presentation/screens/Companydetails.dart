import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Presentation/screens/Admin.dart';
import 'package:tec_admin/Presentation/screens/Passengersdetails.dart';
import 'package:tec_admin/Presentation/screens/Presentvehicles.dart';
import 'package:tec_admin/Presentation/screens/Servicepage.dart';

import 'package:tec_admin/Presentation/screens/Sevilaidrivers.dart';
import 'package:tec_admin/Presentation/screens/Shedulepage.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';

class CompanyDetailsPage extends StatefulWidget {
  final String companyName;
  final VoidCallback onBack;




  const CompanyDetailsPage({Key? key, required this.companyName, required this.onBack}) : super(key: key);



  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late String currentTime;
  late String currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
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



    @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Colours.black,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDate, style: const TextStyle(fontSize: 15, color: Colours.white)),
                  Text(
                    "${currentTime}(SGT)",
                    style: const TextStyle(fontSize: 15, color: Colours.white),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.companyName,
                    style: TextStyle(color: Colours.white),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false, // Disable the default leading icon
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colours.white,),
            onPressed: widget.onBack, // Call the onBack callback to return to the CompanyPage
          ),
          actions: [
            IconButton(
                onPressed: () {
                },
                icon: ImageIcon(AssetImage("assets/orange.png"),color: Colours.white,)),
            SizedBox(width: 20,)
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
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colours.white,
                        indicator: BoxDecoration(
                          color: Colours.black,
                        ),
                        tabs: [
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Schedules'),
                            ),
                          ),
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Passengers'),
                            ),
                          ),
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Service'),
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
                  Shedule(),
                  Passengerspage(),
                  Servicepage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
