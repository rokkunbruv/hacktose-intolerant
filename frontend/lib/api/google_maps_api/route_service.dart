import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // ✅ Import this for debugPrint
import 'package:tultul/classes/route_model.dart';

class RouteService {
  static Future<List<RouteModel>> loadRoutes() async {
    try {
      // Load JSON file
      String jsonString = await rootBundle.loadString('assets/coordinates/coords01b.json');
      Map<String, dynamic> jsonData = jsonDecode(jsonString); // Decode as a Map

      // Extract 'routes' array
      List<dynamic> routesJson = jsonData['routes'] ?? [];

      return routesJson.map((route) => RouteModel.fromJson(route)).toList();
    } catch (e) {
      if (kDebugMode) print("❌ Error loading routes: $e"); // ✅ Fix debug print
      return [];
    }
  }
}
