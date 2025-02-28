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
  GoogleMapController? _mapController; 

  /// Attach the Google Map controller
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Load a specific route based on the given file name
  Future<void> loadRoute(String fileName) async {
    String filePath = "assets/coordinates/$fileName.json";
    debugPrint("\ud83d\udcc2 Loading file: $filePath");

    List<RouteModel> routes = await RouteService.loadRoutes(filePath);
    if (routes.isEmpty) {
      debugPrint("\ud83d\udea8 No routes found in $fileName!");
      return;
    }

    if (routes.isNotEmpty) {
      firstRoute = routes[0].coordinates.map((c) => LatLng(c[0], c[1])).toList();
    }
    if (routes.length > 1) {
      secondRoute = routes[1].coordinates.map((c) => LatLng(c[0], c[1])).toList();
    }

    fullRoute = [...firstRoute, ...secondRoute];
    debugPrint("\u2705 Loaded Route: ${routes.map((r) => r.name).join(', ')}");

    _setRandomStartingPoint();
    notifyListeners();
    _startMoving();
    _centerMapOnRoute(); 
  }

  /// Center the map to fit the route
  void _centerMapOnRoute() {
    if (_mapController == null || fullRoute.isEmpty) return;

    LatLngBounds bounds = _getRouteBounds(fullRoute);
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );

    debugPrint("\ud83d\udccc Centered map on route");
  }

  /// Get the bounding box of the route
  LatLngBounds _getRouteBounds(List<LatLng> route) {
    double minLat = route.map((p) => p.latitude).reduce(min);
    double maxLat = route.map((p) => p.latitude).reduce(max);
    double minLng = route.map((p) => p.longitude).reduce(min);
    double maxLng = route.map((p) => p.longitude).reduce(max);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Select a random starting point along the route
  void _setRandomStartingPoint() {
    if (fullRoute.isEmpty) return;

    final random = Random();
    currentIndex = random.nextInt(fullRoute.length);
    currentPosition = fullRoute[currentIndex];

    debugPrint("\ud83d\udccd Random Start Position: $currentPosition");
  }

  /// Moves the jeepney along the full route, looping back at the end
  void _startMoving() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (fullRoute.isEmpty) return;

      currentIndex = (currentIndex + 1) % fullRoute.length;
      currentPosition = fullRoute[currentIndex];

      debugPrint("\ud83d\ude96 Moving to: $currentPosition");
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
