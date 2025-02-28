import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tultul/classes/route_model.dart';

class RouteService {
  /// Loads multiple routes from a JSON file and returns a list of `RouteModel`
  static Future<List<RouteModel>> loadRoutes(String filePath) async {
    try {
      String jsonString = await rootBundle.loadString(filePath);
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> routesList = jsonData["routes"] ?? []; // Extract the "routes" list

      return routesList.map((route) => RouteModel.fromJson(route)).toList();
    } catch (e) {
      print("❌ Error loading route file: $e");
      return [];
    }
  }
}
