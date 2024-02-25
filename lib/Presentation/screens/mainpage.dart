import 'package:flutter/material.dart';
import 'package:tec_admin/Presentation/screens/Admin.dart';
import 'package:tec_admin/Presentation/screens/Companypage.dart';
import 'package:tec_admin/Presentation/screens/Driverpage.dart';
import 'package:tec_admin/Presentation/screens/Homepage.dart';
import 'package:tec_admin/Presentation/screens/Vehiclepage.dart';

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key, }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<String> _pageNames = [
    'Home',
    'Route Allocation',
    'Vehicle Details',
    'Driver Details',
    'Company Details',
    'Trip Admin',
    'Report Page'
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
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
                _buildNavItem('Driver', 1),
                _buildNavSeparator(),
                _buildNavItem('Vehicle', 2),
                _buildNavSeparator(),
                _buildNavItem('Company', 3),
                _buildNavSeparator(),
                _buildNavItem('Admin', 4),
                const Spacer(),
                IconButton(onPressed: (){}, icon:const Icon(Icons.logout,color: Color(0xffea6238),)),
                const SizedBox(width: 9),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const [
                Homepage(),
                Driver(),
                VehilceScreen(),
                Company(),
                Adminpage()

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return InkWell(
      onTap: () => _onNavItemTapped(index),
      child: Container(

        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.black : null,
          border: _selectedIndex == index
              ? const Border(
            top: BorderSide(
              color: Color(0xffea6238),
              width: 3,
            ),
          )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : Colors.black,
            fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
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
