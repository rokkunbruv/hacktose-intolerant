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
      notifyListeners();

      // ✅ Move camera only once when the route is first loaded
      if (!_isRouteLoaded && !_isCameraMovedByUser && routeBounds != null && _mapController != null) {
        Future.delayed(Duration(milliseconds: 500), () {
          _mapController!.animateCamera(CameraUpdate.newLatLngBounds(routeBounds!, 50));
        });
        _isRouteLoaded = true; // 🔹 Prevents future resets
      }

      _startMoving();
    } catch (e) {
      debugPrint("❌ Error fetching route from API: $e");
    }
  }

  /// 🚀 Assign GoogleMapController instance
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    if (routeBounds != null && !_isRouteLoaded && !_isCameraMovedByUser) {
      Future.delayed(Duration(milliseconds: 500), () {
        _mapController!.animateCamera(CameraUpdate.newLatLngBounds(routeBounds!, 50));
      });
      _isRouteLoaded = true;
    }
  }

  /// 🚀 Track user interaction with the map
  void onCameraMove() {
    _isCameraMovedByUser = true; // ✅ Stops auto-resets after user moves the map
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
