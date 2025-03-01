import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<List<LatLng>>> loadJeepneyRoutes(String jsonFile) async {
  try {
    String jsonString = await rootBundle.loadString('assets/coordinates/$jsonFile');
    final jsonData = jsonDecode(jsonString);

    List<List<LatLng>> routes = [];
    for (var route in jsonData['routes']) {
      List<LatLng> path = (route['path'] as List)
          .map((point) => LatLng(point[0], point[1])) // Convert to LatLng
          .toList();
      routes.add(path);
    }
    return routes;
  } catch (e) {
    print("Error loading JSON file: $e");
    return [];
  }
}
