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

  List<Map<String, dynamic>> jeepneys = [];
  Timer? _timer;
  LatLngBounds? routeBounds;
  final Random _random = Random();
  bool _isCameraMovedByUser = false; // ✅ New flag to track user movement
  bool _isRouteLoaded = false; // ✅ Prevents resetting after initial load

  GoogleMapController? _mapController;

  /// 🚀 Load route from API and process it
  Future<void> loadRoute(String routeName) async {
    debugPrint("🌍 Fetching route: $routeName from API");

    try {
      List<RouteModel> routes = await RouteService.loadRoutes(routeName);
      if (routes.isEmpty) {
        debugPrint("🚨 No routes found for $routeName!");
        return;
      }

      firstRoute = routes.isNotEmpty
          ? routes[0].coordinates.map((c) => LatLng(c[0], c[1])).toList()
          : [];
      secondRoute = routes.length > 1
          ? routes[1].coordinates.map((c) => LatLng(c[0], c[1])).toList()
          : [];
      fullRoute = [...firstRoute, ...secondRoute];

      _calculateBounds(); 
      _initializeJeepneys();
      
      // Only center on initial load
      if (!_isRouteLoaded && _mapController != null && routeBounds != null) {
        centerCamera();
        _isRouteLoaded = true;
      }
      
      notifyListeners();
      _startMoving();
    } catch (e) {
      debugPrint("❌ Error fetching route from API: $e");
    }
  }

  /// 🚀 Assign GoogleMapController instance
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    // Only center on initial load
    if (!_isRouteLoaded && routeBounds != null) {
      centerCamera();
      _isRouteLoaded = true;
    }
  }

  /// 🚀 Add this new method to be called from your button
  void centerCamera() {
    if (_mapController != null && routeBounds != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(routeBounds!, 50)
      );
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
    int jeepneyCount = _random.nextInt(4) + 3;
    Set<int> usedIndices = {};

    while (jeepneys.length < jeepneyCount) {
      int randomIndex = _random.nextInt(fullRoute.length);
      if (!usedIndices.contains(randomIndex)) {
        usedIndices.add(randomIndex);
        // Calculate initial bearing
        double bearing = _calculateBearing(
          fullRoute[randomIndex],
          fullRoute[(randomIndex + 1) % fullRoute.length]
        );
        jeepneys.add({
          'index': randomIndex,
          'position': fullRoute[randomIndex],
          'bearing': bearing,
        });
      }
    }

    debugPrint("🚍 Spawned $jeepneyCount jeepneys at unique positions");
  }

  // Add this method to calculate bearing
  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (pi / 180);
    double lng1 = start.longitude * (pi / 180);
    double lat2 = end.latitude * (pi / 180);
    double lng2 = end.longitude * (pi / 180);

    double dLon = lng2 - lng1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);
    return (bearing * (180 / pi) + 360) % 360; // Convert to degrees
  }

  /// 🔹 Moves jeepneys along the route and loops them back
  void _startMoving() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (fullRoute.isEmpty) return;

      for (var jeepney in jeepneys) {
        int currentIndex = jeepney['index'];
        int nextIndex = (currentIndex + 1) % fullRoute.length;
        
        // Calculate new bearing before updating position
        double bearing = _calculateBearing(
          fullRoute[currentIndex],
          fullRoute[nextIndex]
        );
        
        jeepney['index'] = nextIndex;
        jeepney['position'] = fullRoute[nextIndex];
        jeepney['bearing'] = bearing;
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