import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tultul/classes/route_model.dart';

class RouteService {
  /// Loads routes from the FastAPI backend
  static Future<List<RouteModel>> loadRoutes(String routeName) async {
    final String apiUrl = "http://3.106.113.161:8080/jeepney_routes/$routeName";

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
      print("❌ Error fetching route from API: $e");
      return [];
    }
  }
}