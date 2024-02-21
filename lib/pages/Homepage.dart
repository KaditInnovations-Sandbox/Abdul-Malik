import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    updateTime();
    updateDate();
    // Update date and time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          updateTime();
          updateDate();
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

  void updateTime() {
    final now = DateTime.now();
    currentTime = DateFormat('hh:mm a').format(now);
  }

  void updateDate() {
    final now = DateTime.now();
    currentDate = DateFormat('MMM dd, yyyy').format(now);
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
                Text(currentDate,style: TextStyle(fontSize: 15,color: Colors.white),),
                Text(
                  currentTime,
                  style: TextStyle(fontSize: 15,color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            IconButton(onPressed: (){print("refresh  button pressed");}, icon: Icon(Icons.refresh,color: Colors.white,))
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
