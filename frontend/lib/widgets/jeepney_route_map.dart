import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tultul/utils/route/load_routes.dart'; // Import the JSON loader function

class JeepneyRouteMap extends StatefulWidget {
  final String jsonFile; // JSON file to load

  const JeepneyRouteMap({super.key, required this.jsonFile});

  @override
  _JeepneyRouteMapState createState() => _JeepneyRouteMapState();
}

class _JeepneyRouteMapState extends State<JeepneyRouteMap> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    List<List<LatLng>> routes = await loadJeepneyRoutes(widget.jsonFile);
    Set<Polyline> polylines = {};

    for (int i = 0; i < routes.length; i++) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('route_$i'),
          points: routes[i],
          color: Colors.blue,
          width: 4,
        ),
      );
    }

    setState(() {
      _polylines = polylines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.jsonFile.replaceAll('.json', ''))),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(10.299297, 123.888721), // Default Cebu location
          zoom: 14.5,
        ),
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
