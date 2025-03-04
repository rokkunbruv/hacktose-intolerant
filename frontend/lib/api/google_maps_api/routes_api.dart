import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

import 'package:tultul/classes/direction/direction_path.dart';
import 'package:tultul/classes/route/commute_route.dart';

/// service to fetch directions from the Google Directions API.
class RoutesApi {
  static const String _baseUrl = 'http://3.106.113.161/routes/';

  static final Dio _dio = Dio();

  static Future<List<CommuteRoute>> getDirections(String origin, String destination) async {    
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': origin,
        'destination': destination,
      },
    );

    if (response.statusCode == 400) {
      throw Exception('Error in retrieving suggested routes.');
    }

    final data = response.data;
    
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
