import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Presentation/screens/Admin.dart';
import 'package:tec_admin/Presentation/screens/Companypage.dart';
import 'package:tec_admin/Presentation/screens/Driverpage.dart';
import 'package:tec_admin/Presentation/screens/Geofencing.dart';
import 'package:tec_admin/Presentation/screens/Vehiclepage.dart';
import 'package:tec_admin/Presentation/screens/login.dart';
import 'package:tec_admin/Presentation/screens/mainpage.dart';
import 'package:tec_admin/Presentation/screens/testfile.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Presentation/screens/Companypage.dart';

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEC Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colours.white),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Loginpage(),
        '/home': (context) => const MyHomePage(),
        '/home/driver': (context) => Driver(),
        '/home/vehicle': (context) => VehilceScreen(),
        '/home/company': (context) => Company(),
        '/home/admin': (context) => Adminpage(),
        '/home/geofencing': (context) => Geofencing(),
      },
    );
  }
}
