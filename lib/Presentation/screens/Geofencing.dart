import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Utills/date_time_utils.dart';

class Geofencing extends StatefulWidget {
  @override
  _GeofencingState createState() => _GeofencingState();
}

class _GeofencingState extends State<Geofencing> {
  List<List<LatLng>> _polygons = [];
  List<Color> _polygonColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple
  ]; // Add more colors if needed
  bool _drawingEnabled = false;
  List<List<LatLng>> _savedPolygons = [];
  Map<List<LatLng>, List<String>> _placeNamesCache = {};

  late String currentTime;
  late String currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    currentTime = DateTimeUtils.getCurrentTime();
    currentDate = DateTimeUtils.getCurrentDate();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateTimeUtils.getCurrentTime();
          currentDate = DateTimeUtils.getCurrentDate();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.black,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentDate,
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
                Text(
                  "${currentTime}(SGT)",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                print("refresh button pressed");
              },
              icon: const Icon(Icons.autorenew, color: Colors.white),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      // body: Stack(
      //   children: [
      //     FlutterMap(
      //       options: MapOptions(
      //         center: LatLng(1.3521, 103.8198), // Initial map center
      //         zoom: 15.0, // Initial zoom level
      //         onTap: (tapPosition, latLng) {
      //           if (_drawingEnabled) _handleTap(latLng);
      //         },
      //       ),
      //       children: [
      //         TileLayer(
      //           urlTemplate:
      //           'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      //           additionalOptions: {
      //             'accessToken':
      //             'pk.eyJ1IjoiYWJkdWxtYWxpazAyIiwiYSI6ImNsc3k5NndzNzBhbHcyam9ldzMweHp1ZXgifQ.8OJRRvY-p357uGyu6lxheQ',
      //             'id': 'mapbox/dark-v10', // Map style
      //           },
      //         ),
      //         for (int i = 0; i < _polygons.length; i++)
      //           PolygonLayer(
      //             polygons: [
      //               Polygon(
      //                 points: _polygons[i],
      //                 color: _polygonColors[i % _polygonColors.length],
      //                 borderStrokeWidth: 2,
      //                 borderColor:
      //                 _polygonColors[i % _polygonColors.length],
      //               ),
      //             ],
      //           ),
      //       ],
      //     ),
      //     Positioned(
      //       top: 10,
      //       left: 10,
      //       bottom: 10,
      //       width: 400,
      //       child: Container(
      //         color: Colours.black,
      //         child: ListView.builder(
      //           itemCount: _savedPolygons.length,
      //           itemBuilder: (context, index) {
      //             return PlaceNameExpansionTile(
      //               polygons: _savedPolygons[index],
      //               placeNamesCache: _placeNamesCache,
      //               polygonIndex: index + 1,
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_drawingEnabled)
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _drawingEnabled = true;
                });
              },
              child: Icon(Icons.edit),
            ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_drawingEnabled) {
                  _drawingEnabled = false;
                } else {
                  _savePolygon();
                }
              });
            },
            child: _drawingEnabled ? Icon(Icons.stop) : Icon(Icons.save),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _undo,
            child: Icon(Icons.undo),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _getPlaceNames(List<LatLng> coordinates) async {
    if (_placeNamesCache.containsKey(coordinates)) {
      return _placeNamesCache[coordinates]!;
    }
    final List<String> placeNames = [];
    for (final coordinate in coordinates) {
      final response = await http.get(
          Uri.parse(
              'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinate.longitude},${coordinate.latitude}.json?access_token=pk.eyJ1IjoiYWJkdWxtYWxpazAyIiwiYSI6ImNsc3k5NndzNzBhbHcyam9ldzMweHp1ZXgifQ.8OJRRvY-p357uGyu6lxheQ'
          ));
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final features = decodedResponse['features'];
        if (features != null && features.isNotEmpty) {
          final placeName = features[0]['place_name'];
          placeNames.add(placeName);
        }
      }
    }
    _placeNamesCache[coordinates] = placeNames;
    return placeNames;
  }

  void _handleTap(LatLng latLng) {
    if (mounted) {
      setState(() {
        if (_polygons.isEmpty || _polygons.last.length >= 1000) {
          _polygons.add([]);
        }
        _polygons.last.add(latLng);
      });
    }
  }

  void _savePolygon() {
    if (_polygons.isNotEmpty && _polygons.last.length >= 3) {
      _savedPolygons.add(List.from(_polygons.last));
      _polygons.clear();
    }
  }

  void _undo() {
    setState(() {
      if (_polygons.isNotEmpty && _polygons.last.isNotEmpty) {
        _polygons.last.removeLast();
      } else if (_polygons.isNotEmpty) {
        _polygons.removeLast();
      }
    });
  }
}

class PlaceNameExpansionTile extends StatefulWidget {
  final List<LatLng> polygons;
  final Map<List<LatLng>, List<String>> placeNamesCache;
  final int polygonIndex;

  const PlaceNameExpansionTile({
    required this.polygons,
    required this.placeNamesCache,
    required this.polygonIndex,
    Key? key,
  }) : super(key: key);

  @override
  _PlaceNameExpansionTileState createState() => _PlaceNameExpansionTileState();
}

class _PlaceNameExpansionTileState extends State<PlaceNameExpansionTile> {
  late Future<List<String>> _placeNamesFuture;

  @override
  void initState() {
    super.initState();
    _placeNamesFuture = _getPlaceNames(widget.polygons);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _placeNamesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ExpansionTile(
            title: Text(
              'Polygon ${widget.polygonIndex}',
              style: TextStyle(color: Colours.white),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!
                    .map((placeName) => Text(
                  placeName,
                  style: TextStyle(color: Colours.white),
                ))
                    .toList(),
              ),
            ],
          );
        }
      },
    );
  }

  Future<List<String>> _getPlaceNames(List<LatLng> coordinates) async {
    if (widget.placeNamesCache.containsKey(coordinates)) {
      return widget.placeNamesCache[coordinates]!;
    }
    final List<String> placeNames = [];
    for (final coordinate in coordinates) {
      final response = await http.get(
          Uri.parse(
              'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinate.longitude},${coordinate.latitude}.json?access_token=pk.eyJ1IjoiYWJkdWxtYWxpazAyIiwiYSI6ImNsc3k5NndzNzBhbHcyam9ldzMweHp1ZXgifQ.8OJRRvY-p357uGyu6lxheQ'
          ));
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final features = decodedResponse['features'];
        if (features != null && features.isNotEmpty) {
          final placeName = features[0]['place_name'];
          placeNames.add(placeName);
        }
      }
    }
    widget.placeNamesCache[coordinates] = placeNames;
    return placeNames;
  }
}
