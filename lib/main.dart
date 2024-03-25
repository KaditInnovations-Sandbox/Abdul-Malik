import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Repositories/Login_repo.dart';
import 'package:tec_admin/Presentation/screens/Admin.dart';
import 'package:tec_admin/Presentation/screens/Companypage.dart';
import 'package:tec_admin/Presentation/screens/Driverpage.dart';
import 'package:tec_admin/Presentation/screens/Geofencing.dart';
import 'package:tec_admin/Presentation/screens/Vehiclepage.dart';
import 'package:tec_admin/Presentation/screens/login.dart';
import 'package:tec_admin/Presentation/screens/mainpage.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = UserRepository.getTokenFromLocalStorage(); // Get the token from the cookie
    final isLoggedIn = token != null;

    return MaterialApp(
      title: 'TEC Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colours.white),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',

      routes: {
        '/login': (context) => isLoggedIn ? const MyHomePage() : const Loginpage(), // If already logged in, navigate to home
        '/home': (context) => MyHomePage(),
        '/home/driver': (context) => Driver(),
        '/home/vehicle': (context) => VehilceScreen(),
        '/home/company': (context) => Company(),
        '/home/admin': (context) => Adminpage(),
        '/home/geofencing': (context) => Geofencing(),
      },
    );
  }
}
