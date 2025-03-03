import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/api/jeepney_api/jeepney_api.dart';
import 'package:tultul/classes/route_model.dart';
import 'package:tultul/styles/map/marker_styles.dart';
import 'package:tultul/utils/jeep/load_jeepney_icon.dart';
import 'package:tultul/utils/jeep/calculate_bearing.dart';

class JeepneyProvider with ChangeNotifier {
  List<LatLng> firstRoute = [];
  List<LatLng> secondRoute = [];
  List<LatLng> fullRoute = [];

  List<Map<String, dynamic>> jeepneys = [];
  late BitmapDescriptor jeepneyIcon;
  Set<Marker> jeepneyMarkers = {};
  LatLngBounds? routeBounds;
  bool isRouteLoaded = false; 

  Timer? _timer;
  final Random _random = Random();

  // bool _isCameraMovedByUser = false; 

  // load jeepney markers
  Future<void> initializeJeepneyMarker() async {
    jeepneyIcon = await loadJeepneyIcon();
  }

  // load route from api and process it
  Future<void> loadRoute(String routeName) async {
    try {
      List<RouteModel> routes = await JeepneyApi.getJeepneyPositions(routeName);

      if (routes.isEmpty) {
        debugPrint("No routes found for $routeName!");
        return;
      }

      firstRoute = routes.isNotEmpty
          ? routes[0].coordinates.map((c) => LatLng(c[0], c[1])).toList()
          : [];
      secondRoute = routes.length > 1
          ? routes[1].coordinates.map((c) => LatLng(c[0], c[1])).toList()
          : [];
      fullRoute = [...firstRoute, ...secondRoute];

      _initializeJeepneys();
      
      if (!isRouteLoaded && routeBounds != null) {
        isRouteLoaded = true;
      }

      notifyListeners();
      _startMoving();
    } catch (e) {
      debugPrint("Error fetching route from API: $e");
    }
  }

  // initializes multiple jeepneys with unique starting positions
  void _initializeJeepneys() {
    if (fullRoute.isEmpty) return;

    jeepneys.clear();

    int jeepneyCount = _random.nextInt(4) + 3;
    Set<int> usedIndices = {};

    while (jeepneys.length < jeepneyCount) {
      int randomIndex = _random.nextInt(fullRoute.length);

      if (!usedIndices.contains(randomIndex)) {
        usedIndices.add(randomIndex);

        // calculate initial bearing
        double bearing = calculateBearing(
          fullRoute[randomIndex],
          fullRoute[(randomIndex + 1) % fullRoute.length]
        );

        Map<String, dynamic> jeepney = {
          'index': randomIndex,
          'position': fullRoute[randomIndex],
          'bearing': bearing,
        };

        jeepneys.add(jeepney);
      }
    }
  }

  /// moves jeepneys along the route and loops them back
  void _startMoving() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (fullRoute.isEmpty) return;

      // removes previous positions of jeepney markers
      jeepneyMarkers.clear();

      for (var jeepney in jeepneys) {
        int currentIndex = jeepney['index'];
        int nextIndex = (currentIndex + 1) % fullRoute.length;
        
        // calculate new bearing before updating position
        double bearing = calculateBearing(
          fullRoute[currentIndex],
          fullRoute[nextIndex]
        );
        
        jeepney['index'] = nextIndex;
        jeepney['position'] = fullRoute[nextIndex];
        jeepney['bearing'] = bearing;

        // adding jeepney markers w/ new positions
        // to give the illusion of movement
        jeepneyMarkers.add(createJeepneyyMarker(
          'jeepney_${jeepney['index']}',
          jeepneyIcon, jeepney['position'],
          jeepney['bearing'] ?? 0.0)
        );
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