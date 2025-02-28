import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tultul/api/google_maps_api/route_service.dart';
import 'package:tultul/classes/route_model.dart';

class JeepneyProvider with ChangeNotifier {
  List<LatLng> firstRoute = [];
  List<LatLng> secondRoute = [];
  List<LatLng> fullRoute = [];

  int currentIndex = 0;
  LatLng? currentPosition;
  Timer? _timer;

  /// Load a specific route based on the given file name
  Future<void> loadRoute(String fileName) async {
    String filePath = "assets/coordinates/$fileName.json"; 
    debugPrint("📂 Loading file: $filePath");

    List<RouteModel> routes = await RouteService.loadRoutes(filePath);
    if (routes.isEmpty) {
      debugPrint("🚨 No routes found in $fileName!");
      return;
    }

    // Ensure the RouteModel class has a "coordinates" field
    if (routes.length > 0) {
      firstRoute = routes[0].coordinates.map((c) => LatLng(c[0], c[1])).toList();
    }
    if (routes.length > 1) {
      secondRoute = routes[1].coordinates.map((c) => LatLng(c[0], c[1])).toList();
    }

    // Combine both routes for seamless movement
    fullRoute = [...firstRoute, ...secondRoute];

    debugPrint("✅ Loaded Route: ${routes.map((r) => r.name).join(', ')}");

    _setRandomStartingPoint();
    notifyListeners();
    _startMoving();
  }

  /// Select a random starting point along the entire route
  void _setRandomStartingPoint() {
    if (fullRoute.isEmpty) return;

    final random = Random();
    currentIndex = random.nextInt(fullRoute.length);
    currentPosition = fullRoute[currentIndex];

    debugPrint("📍 Random Start Position: $currentPosition");
  }

  /// Moves the jeepney along the full route, looping back at the end
  void _startMoving() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (fullRoute.isEmpty) return;

      // Move to the next point, looping back when reaching the end
      currentIndex = (currentIndex + 1) % fullRoute.length;
      currentPosition = fullRoute[currentIndex];

      debugPrint("🚖 Moving to: $currentPosition");
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
