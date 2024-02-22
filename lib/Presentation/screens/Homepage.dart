import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/Utills/date_time_utils.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Homepage extends StatefulWidget {
  final String name;
  const Homepage({Key? key, required this.name});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
    // Cancel the timer to prevent calling setState after dispose
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentDate,style: const TextStyle(fontSize: 15,color: Colors.white),),
                Text(
                  "${currentTime}(SST)",
                  style: const TextStyle(fontSize: 15,color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            IconButton(onPressed: (){print("refresh  button pressed");}, icon: const Icon(Icons.refresh,color: Colors.white,))
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 2,
                  child: Container()
              ),
            ),
          ],
        ),
      ),
    );
  }
}
