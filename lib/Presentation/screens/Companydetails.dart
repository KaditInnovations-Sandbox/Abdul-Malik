import 'package:flutter/material.dart';
import 'package:tec_admin/Presentation/screens/Passengersdetails.dart';
import 'package:tec_admin/Presentation/screens/Routepage.dart';

class CompanyDetailsPage extends StatelessWidget {
  final String companyName;
  final VoidCallback onBack;

  const CompanyDetailsPage({Key? key, required this.companyName, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Kadit Innovations',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false, // Disable the default leading icon
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: onBack, // Call the onBack callback to return to the CompanyPage
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 350,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: const Icon(Icons.search_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 150,),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade400,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Add"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt),
                      Text("Filter")
                    ],
                  ),
                ),
                const SizedBox(width: 26),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: constraints.maxWidth,
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.35),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                          color: Colors.black,
                        ),
                        tabs: [
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Passengers'),
                            ),
                          ),
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Routes'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Passengerpage(),
                  Routepage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
