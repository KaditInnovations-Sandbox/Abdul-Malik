import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/pages/Companydetails.dart';
import 'package:testapp/pages/login.dart';
import 'package:testapp/pages/mainpage.dart';


void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffea6238)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      home: const MyHomePage(name: 'Abdul Malik',)
    );
  }
}



