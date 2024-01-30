import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class Homepage extends StatefulWidget {
  final String name;
  const Homepage({super.key, required this.name});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 130,
              child: Text(
                "Welcome ${widget.name} !",
                style: TextStyle(fontSize: MediaQuery.of(context).size.width / 30),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 12,
              child: Text(
                "Track Your Vehicles Here:",
                style: TextStyle(fontSize: MediaQuery.of(context).size.width / 70),
              ),
            ),
            Positioned(
              top: 15,
              left: MediaQuery.of(context).size.width / 2.08,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width /4,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        
            ),
            Padding(
              padding: const EdgeInsets.only(top: 115),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width / 1.1,
                child: FlutterMap(
                  options: MapOptions(
                    zoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
