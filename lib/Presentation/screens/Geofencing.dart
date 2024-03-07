import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Example'),
      ),
      body: Row(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(1.3521, 103.8198), // Initial map center
                zoom: 15.0, // Initial zoom level
                onTap: (tapPosition, latLng) {
                  if (_drawingEnabled) _handleTap(latLng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: {
                    'accessToken':
                    'pk.eyJ1IjoiYWJkdWxtYWxpazAyIiwiYSI6ImNsc3k5NndzNzBhbHcyam9ldzMweHp1ZXgifQ.8OJRRvY-p357uGyu6lxheQ',
                    'id': 'mapbox/light-v10', // Map style
                  },
                ),
                for (int i = 0; i < _polygons.length; i++)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: _polygons[i],
                        color: _polygonColors[i % _polygonColors.length],
                        borderStrokeWidth: 2,
                        borderColor:
                        _polygonColors[i % _polygonColors.length],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            width: 200,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _savedPolygons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Polygon ${index + 1}'),
                  onTap: () {
                    _showPolygon(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
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

  void _handleTap(LatLng latLng) {
    if (mounted) { // Check if the widget is still mounted
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
      _savedPolygons.add(List.from(_polygons.last)); // Save the current polygon
      _polygons.clear(); // Clear the current drawing
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

  void _showPolygon(int index) {
    setState(() {
      // Check if the selected polygon is already being displayed
      if (_polygons.isNotEmpty && _polygons.first == _savedPolygons[index]) {
        _polygons.clear(); // Clear to hide the polygon
      } else {
        _polygons.clear(); // Clear previously displayed polygons
        _polygons.add(List.from(_savedPolygons[index])); // Show the selected polygon
      }
    });
  }
}
