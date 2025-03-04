import 'dart:convert';
import 'package:http/http.dart' as http; // Import HTTP package
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<List<LatLng>>> loadJeepneyRoutes(String routeName) async {
  final String apiUrl = 'http://3.106.113.161:8080/jeepney_routes/$routeName'; // FastAPI endpoint
  
  try {
    final response = await http.get(Uri.parse(apiUrl)); // Fetch JSON from API

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      
      List<List<LatLng>> routes = [];
      for (var route in jsonData['routes']) {
        List<LatLng> path = (route['path'] as List)
            .map((point) => LatLng(point[0], point[1])) // Convert to LatLng
            .toList();
        routes.add(path);
      }

      return routes;
    } else {
      print("🚨 Error: Server responded with status code ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("❌ Error fetching JSON: $e");
    return [];
  }
}
