import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';
import 'dart:ui_web' as ui;

class Homepage extends StatefulWidget {
  const Homepage({Key? key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String currentTime;
  late String currentDate;
  late Timer _timer;
  late MapboxMapController _controller;

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

  void _onMapCreated(MapboxMapController controller) {
    _controller = controller;

    // Wait for a delay to ensure the map is fully loaded before adding the marker
    Future.delayed(const Duration(seconds: 2), () {
      // Add the marker symbol layer
      controller.addSymbol(SymbolOptions(
        geometry: LatLng(1.338170, 103.902300),
        iconImage: 'assets/marker_icon.png',
        textField: 'Sevilai Transport',
        iconSize: 0.3,
        textSize: 16,
        textColor: '#000000',
        textOffset: Offset(0, 2),

      ));

      controller.addSymbol(SymbolOptions(
        geometry: LatLng(1.337840, 103.903170),
        iconImage: 'assets/marker_icon.png',
        textField: 'Alpha Builders',
        iconSize: 0.3,
        textSize: 16,
        textColor: '#000000',
        textOffset: Offset(0, 2),
      ));

    });
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
                Text(currentDate, style: const TextStyle(fontSize: 15, color: Colors.white)),
                Text(
                  "${currentTime}(SGT)",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                print("refresh button pressed");
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      // body: SingleChildScrollView(
      //   child: Stack(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.all(2.0),
      //         child: SizedBox(
      //           height: MediaQuery.of(context).size.height * 0.6,
      //           width: MediaQuery.of(context).size.width * 2,
      //           child: MapboxMap(
      //             onMapCreated: _onMapCreated,
      //             styleString: MapboxStyles.LIGHT,
      //             accessToken: 'pk.eyJ1IjoiYWJkdWxtYWxpazAyIiwiYSI6ImNsc3k5NndzNzBhbHcyam9ldzMweHp1ZXgifQ.8OJRRvY-p357uGyu6lxheQ',
      //             initialCameraPosition: const CameraPosition(
      //               target: LatLng(1.338170, 103.902300), // Initial map center position
      //               zoom: 17, // Initial zoom level
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
