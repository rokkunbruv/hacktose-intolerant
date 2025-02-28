import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JeepneyRouteMap extends StatefulWidget {
  final String jsonFile; // Pass JSON file name

  const JeepneyRouteMap({super.key, required this.jsonFile});

  @override
  _JeepneyRouteMapState createState() => _JeepneyRouteMapState();
}

class _JeepneyRouteMapState extends State<JeepneyRouteMap> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  List<String> _routeNames = [];

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    String jsonString = await rootBundle.loadString('assets/coordinates/${widget.jsonFile}');
    final jsonData = jsonDecode(jsonString);

    Set<Polyline> polylines = {};
    List<String> routeNames = [];

    // Define colors and styles for overlapping effect
    List<Color> colors = [Colors.green.withOpacity(0.7), Colors.blue.withOpacity(0.7)];
    List<int> zIndices = [1, 2]; // Blue route drawn on top

    for (int i = 0; i < jsonData['routes'].length; i++) {
      var route = jsonData['routes'][i];

      List<LatLng> path = (route['path'] as List)
          .map((point) => LatLng(point[0], point[1]))
          .toList();

      print("Loading Route: ${route['name']} - ${path.length} points"); // Debugging

      polylines.add(
        Polyline(
          polylineId: PolylineId('${route['name']}-${route['label']}'), // Ensures uniqueness
          points: path,
          color: colors[i % colors.length], 
          width: 8, // Set a uniform thickness
          zIndex: i, // Ensures routes are drawn in order
        ),
      );


      routeNames.add(route['name']);
    }

    setState(() {
      _polylines = polylines;
      _routeNames = routeNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jeepney Routes')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(10.299297, 123.888721),
              zoom: 14.5,
            ),
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: _routeNames.asMap().entries.map((entry) {
                int index = entry.key;
                String name = entry.value;
                Color color = index == 0 ? Colors.green : Colors.blue;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(width: 16, height: 16, color: color.withOpacity(0.7)),
                      const SizedBox(width: 5),
                      Text(name, style: const TextStyle(color: Colors.black, fontSize: 12)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
