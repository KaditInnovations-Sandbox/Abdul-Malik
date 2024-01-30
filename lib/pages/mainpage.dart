import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:testapp/pages/Admin.dart';
import 'package:testapp/pages/Homepage.dart';
import 'package:testapp/pages/login.dart';
class MyHomePage extends StatefulWidget {
  final String name;

  const MyHomePage({Key? key, required this.name, }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.orange[100],
              selectedHoverColor: Colors.orange[100],
              selectedColor: Colors.transparent,
              selectedTitleTextStyle: const TextStyle(color: Colors.orange),
              selectedIconColor: Colors.orange,

            ),
            title: Column(

              children: [
                SizedBox(height: 10,),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
            items: [
              SideMenuItem(
                title: 'Home',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                title: 'Route Allocation',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.route_rounded),
              ),
              SideMenuItem(
                title: 'Company Details',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.domain_rounded),
              ),
              SideMenuItem(
                title: 'Vehicles',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.drive_eta),
              ),
              SideMenuItem(
                title: 'Drivers',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.account_circle_rounded),
              ),
              SideMenuItem(
                title: 'Trip Admin',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.person),
              ),
              SideMenuItem(
                title: 'Report',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.file_copy_rounded),
              ),
              SideMenuItem(
                title: 'Log Out',
                onTap: (index, _) {

                },
                icon: const Icon(Icons.logout_sharp),
              )
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [

                Homepage(name: widget.name,),

                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Driver Details',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Company Details',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Vehicles Details',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Drivers Page',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Admin(),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Report Page',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}