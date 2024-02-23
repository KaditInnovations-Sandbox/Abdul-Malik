import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Presentation/screens/mainpage.dart';
import 'package:timezone/data/latest.dart' as tz;





void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEC Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffea6438)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      home: const MyHomePage()
    );
  }
}



