import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tultul/api/google_maps_api/route_service.dart';
import 'package:tultul/classes/route_model.dart';

class JeepneyProvider with ChangeNotifier {
  List<LatLng> firstRoute = [];
  List<LatLng> secondRoute = [];
  List<LatLng> fullRoute = [];

  List<Map<String, dynamic>> jeepneys = [];
  Timer? _timer;
  LatLngBounds? routeBounds;
  final Random _random = Random();

  Future<void> loadRoute(String fileName) async {
    String filePath = "assets/coordinates/$fileName.json"; // ✅ Fixed double `.json.json`
    debugPrint("📂 Loading file: $filePath");

    try {
      List<RouteModel> routes = await RouteService.loadRoutes(filePath);
      if (routes.isEmpty) {
        debugPrint("🚨 No routes found in $fileName!");
        return;
      }

      firstRoute = routes.isNotEmpty ? routes[0].coordinates.map((c) => LatLng(c[0], c[1])).toList() : [];
      secondRoute = routes.length > 1 ? routes[1].coordinates.map((c) => LatLng(c[0], c[1])).toList() : [];
      fullRoute = [...firstRoute, ...secondRoute];

      _calculateBounds();
      _initializeJeepneys(); // ✅ New: Randomized jeepney start positions
      notifyListeners();
      _startMoving();
    } catch (e) {
      debugPrint("❌ Error loading route file: $e");
    }
  }

  /// 🔹 Calculates the bounds for centering the camera
  void _calculateBounds() {
    if (fullRoute.isEmpty) return;
    double minLat = fullRoute.first.latitude, maxLat = fullRoute.first.latitude;
    double minLng = fullRoute.first.longitude, maxLng = fullRoute.first.longitude;

    for (LatLng point in fullRoute) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    routeBounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// 🔹 Initializes multiple jeepneys with unique starting positions
  void _initializeJeepneys() {
    if (fullRoute.isEmpty) return;

    jeepneys.clear();
    int jeepneyCount = _random.nextInt(4) + 3; // Randomize between 3 and 6 jeepneys
    Set<int> usedIndices = {}; // Prevents duplicate start positions

    while (jeepneys.length < jeepneyCount) {
      int randomIndex = _random.nextInt(fullRoute.length);

      if (!usedIndices.contains(randomIndex)) {
        usedIndices.add(randomIndex);
        jeepneys.add({
          'index': randomIndex,
          'position': fullRoute[randomIndex],
        });
      }
    }

    debugPrint("🚍 Spawned $jeepneyCount jeepneys at unique positions");
  }

  /// 🔹 Moves jeepneys along the route and loops them back
  void _startMoving() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (fullRoute.isEmpty) return;

      for (var jeepney in jeepneys) {
        jeepney['index'] = (jeepney['index'] + 1) % fullRoute.length;
        jeepney['position'] = fullRoute[jeepney['index']];
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
