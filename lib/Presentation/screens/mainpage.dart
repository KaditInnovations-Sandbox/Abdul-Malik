import 'dart:html';

import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Presentation/screens/Admin.dart';
import 'package:tec_admin/Presentation/screens/Companypage.dart';
import 'package:tec_admin/Presentation/screens/Driverpage.dart';
import 'package:tec_admin/Presentation/screens/Geofencing.dart';
import 'package:tec_admin/Presentation/screens/Homepage.dart';
import 'package:tec_admin/Presentation/screens/Vehiclepage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late String _userRole;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _userRole = _getUserRole() ?? ''; // Retrieve user role from localstorage
  }

  String? _getUserRole() {
    return window.localStorage['user_role']; // Retrieve user role from local storage
  }



  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    String route = '/home';
    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        route = '/home/driver';
        break;
      case 2:
        route = '/home/vehicle';
        break;
      case 3:
        route = '/home/company';
        break;
      case 4:
        route = '/home/admin';
        break;
      case 5:
        route = '/home/geofencing';
        break;
      default:
        route = '/home';
    }

    route = '$route&role=$_userRole'; // Replace 'your_token_here' with your token

    window.history.pushState(null, 'TEC Admin', route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Image.asset(
                  "assets/logo.png",
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
                _buildNavItem('Home', 0),
                _buildNavSeparator(),
                if (_userRole == 'SUPER_ADMIN' || _userRole == 'TRIP_ADMIN')
                  _buildNavItem('Driver', 1),
                _buildNavSeparator(),
                if (_userRole == 'SUPER_ADMIN' || _userRole == 'TRIP_ADMIN')
                  _buildNavItem('Vehicle', 2),
                _buildNavSeparator(),
                _buildNavItem('Company', 3),
                _buildNavSeparator(),
                if (_userRole == 'SUPER_ADMIN') _buildNavItem('Admin', 4),
                if (_userRole == 'SUPER_ADMIN')
                  _buildNavSeparator(),
                if (_userRole == 'SUPER_ADMIN') _buildNavItem('Geofencing', 5),
                const Spacer(),
                IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(Icons.logout, color: Colours.orange),
                ),
                const SizedBox(width: 9),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                Homepage(),
                Driver(),
                VehilceScreen(),
                Company(),
                Adminpage(),
                Geofencing(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return Material(
      color: _selectedIndex == index ? Colours.black : null,
      child: InkWell(
        onTap: () => _onNavItemTapped(index),
        onTapCancel: () {
          setState(() {
            _selectedIndex = -1; // Reset selectedIndex when tap is canceled
          });
        },
        onTapDown: (_) {
          setState(() {
            _selectedIndex = index; // Set selectedIndex when tap down
          });
        },
        onTapUp: (_) {
          setState(() {
            _selectedIndex = -1; // Reset selectedIndex when tap is released
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: _selectedIndex == index
                ? const Border(
              top: BorderSide(
                color: Colours.orange,
                width: 3,
              ),
            )
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colours.black,
              fontWeight:
              _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavSeparator() {
    return Container(
      width: 1,
      height: 20,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
