import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tultul/api/google_maps_api/route_service.dart';
import 'package:tultul/classes/route_model.dart';

class JeepneyProvider with ChangeNotifier {
  List<RouteModel> routes = [];
  int currentRouteIndex = 0;
  int currentIndex = 0;
  LatLng? currentPosition;
  Timer? _timer;
  final Duration moveDelay = Duration(seconds: 1); // Adjust speed here

  /// Load all routes and start simulation
  Future<void> startSimulation() async {
    routes = await RouteService.loadRoutes();
    if (routes.isEmpty) {
      debugPrint("🚨 No routes found!");
      return;
    }

    currentRouteIndex = 0; // Start from first route
    _setRandomStartingPoint();
    notifyListeners();
    _startMoving();
  }

  /// Selects a random starting point within the current route
  void _setRandomStartingPoint() {
    if (routes.isEmpty || routes[currentRouteIndex].coordinates.isEmpty) return;

    final random = Random();
    currentIndex = random.nextInt(routes[currentRouteIndex].coordinates.length);
    currentPosition = LatLng(
      routes[currentRouteIndex].coordinates[currentIndex][0],
      routes[currentRouteIndex].coordinates[currentIndex][1],
    );

    debugPrint("📍 Starting at: $currentPosition (Route: ${routes[currentRouteIndex].name})");
  }

  /// Moves the jeepney along the route and switches to the next route when finished
  void _startMoving() {
    _timer?.cancel();
    _timer = Timer.periodic(moveDelay, (timer) {
      if (routes.isEmpty || routes[currentRouteIndex].coordinates.isEmpty) return;

      currentIndex++;

      // If reached the end of the route, switch to the next one
      if (currentIndex >= routes[currentRouteIndex].coordinates.length) {
        currentRouteIndex = (currentRouteIndex + 1) % routes.length;
        currentIndex = 0;
        debugPrint("🔄 Switching to next route: ${routes[currentRouteIndex].name}");
      }

      currentPosition = LatLng(
        routes[currentRouteIndex].coordinates[currentIndex][0],
        routes[currentRouteIndex].coordinates[currentIndex][1],
      );

      debugPrint("🚖 Moving to: $currentPosition (Route: ${routes[currentRouteIndex].name})");
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
