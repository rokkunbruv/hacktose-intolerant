import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hacktose_intolerant_app/classes/direction/direction_path.dart';
import 'package:hacktose_intolerant_app/classes/route/commute_route.dart';

/// service to fetch directions from the Google Directions API.
class DirectionsApi {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  static final String _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static final Dio _dio = Dio();

  static Future<List<CommuteRoute>> getDirections(String origin, String destination) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': origin,
        'destination': destination,
        'mode': 'transit',
        'alternatives': true,
        'key': _apiKey,
      },
    );

    final data = response.data;
    
    if (data['status'] == 'REQUEST_DENIED') {
      throw Exception('Google Maps API key is invalid.');
    }
    
    List<CommuteRoute> routes = [];

    if (data['routes'] != null) {
      for (var routeJson in data['routes']) {
        DirectionPath path = DirectionPath.fromJson(routeJson);
        CommuteRoute route = CommuteRoute(path: path);

        routes.add(route);
      }
    }
    return routes;
  }
}
