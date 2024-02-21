import 'package:flutter/material.dart';
import 'package:testapp/pages/Passengersdetails.dart';
import 'package:testapp/pages/Routepage.dart';

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
          title: Text(
            'Kadit Innovations',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false, // Disable the default leading icon
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
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
                      suffixIcon: Icon(Icons.search_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 150,),
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
                      child: TabBar(
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
            Expanded(
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
