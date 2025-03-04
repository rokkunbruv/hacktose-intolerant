import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/classes/route_model.dart';
import 'package:tultul/styles/map/polyline_styles.dart';

class JeepneyApi {
  // loads jeepney positions from the FastAPI backend given a route
  static Future<List<RouteModel>> getJeepneyPositions(String routeName) async {
    final String apiUrl = "http://3.106.113.161:8080/jeepney_routes/$routeName";

    if (routeName.isEmpty) {
      debugPrint("Route name is empty");
      return [];
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> routesList = jsonData["routes"] ?? [];

        return routesList.map((route) => RouteModel.fromJson(route)).toList();
      } else {
        throw Exception("Failed to load routes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching route from API: $e");
      return [];
    }
  }

  // loads jeepney routes data
  static Future<Map<String, dynamic>> getJeepneyRoute(String jsonFile) async {
    final String apiUrl = "http://3.106.113.161:8080/jeepney_routes/$jsonFile";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        bool isSecondary = false; // swaps between primary and secondary polylines

        final jsonData = jsonDecode(response.body);

        Set<Polyline> polylines = {};
        List<String> routeNames = [];
        List<LatLng> allPoints = [];

        for (int i = 0; i < jsonData['routes'].length; i++) {
          var route = jsonData['routes'][i];

          List<LatLng> path = (route['path'] as List)
              .map((point) => LatLng(point[0], point[1]))
              .toList();

          allPoints.addAll(path);

          polylines.add((!isSecondary) ?
            createPolyline(
              '${route['name']}-${route['label']}',
              path,
            ) : 
            createPolyline2(
              '${route['name']}-${route['label']}',
              path,
            )
          );

          routeNames.add(route['name']);

          isSecondary = (isSecondary) ? false : true;
        }

        return <String, dynamic>{
          'polylines': polylines,
          'routeNames': routeNames,
          'allPoints': allPoints,
        };
      } else {
        debugPrint("Error fetching route: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error loading route from API: $e");
    }

    return <String, dynamic>{};
  }
}