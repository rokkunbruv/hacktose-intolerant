import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:hacktose_intolerant_app/api/google_maps_api/directions.dart';
import 'package:hacktose_intolerant_app/classes/route/commute_route.dart';
import 'package:hacktose_intolerant_app/config/map/marker_styles.dart';
import 'package:hacktose_intolerant_app/utils/route/calculate_route_details.dart';
import 'package:hacktose_intolerant_app/utils/route/decode_polyline.dart';

class RouteFinderProvider extends ChangeNotifier {
  // controllers for text fields.
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  // markers and positions.
  LatLng? origin;
  LatLng? destination;
  Marker? originMarker;
  Marker? destinationMarker;
  bool isSettingOrigin = true;

  // directions routes and selected route.
  List<CommuteRoute> routes = [];

  // fare calculation results.
  String fareBreakdown = '';
  double totalFare = 0.0;

  // dropdown selections.
  String passengerType = 'regular';
  String jeepneyType = 'traditional';

  CommuteRoute? selectedRoute;
  Map<CommuteRoute, Set<Polyline>> routePolylines = {};

  void setPassengerType(String type) {
    passengerType = type;

    notifyListeners();
  }

  void setJeepneyType(String type) {
    jeepneyType = type;

    notifyListeners();
  }

  /// called when the map is tapped.
  void setMarker(LatLng location) async {
    if (isSettingOrigin) {
      origin = location;
      originController.text = '${location.latitude}, ${location.longitude}';
      isSettingOrigin = false;

      originMarker = createOriginMarker(location);
    } else {
      destination = location;
      destinationController.text = '${location.latitude}, ${location.longitude}';
      isSettingOrigin = true;

      destinationMarker = createDestinationMarker(location);
    }

    if (originController.text.isNotEmpty && destinationController.text.isNotEmpty) {
      await findRoutes();
    }

    notifyListeners();
  }

  /// returns the set of markers to display on the map.
  Set<Marker> getMarkers() {
    Set<Marker> markers = {};

    if (originMarker != null) markers.add(originMarker!);

    if (destinationMarker != null) markers.add(destinationMarker!);

    return markers;
  }

  /// fetch routes using the directions api.
  Future<void> findRoutes() async {
    if (originController.text.isEmpty || destinationController.text.isEmpty) {
      throw('Origin and destination are not all set.');
    }

    try {
      routes = await DirectionsApi.getDirections(
        originController.text, 
        destinationController.text
      );

      for (CommuteRoute route in routes) {
        routePolylines[route] = decodePolyline(route.path.overviewPolyline);
        
        RouteDetails details = calculateRouteDetails(route, passengerType, jeepneyType);

        route.setTotalFare(details.totalFare);
        route.setTotalDistance(details.totalDistance);
        route.rides = details.rides;
      }

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// select a route and calculate its fare.
  void selectRoute(CommuteRoute route) {
    selectedRoute = route;

    notifyListeners();
  }

  /// get polylines for the selected route
  Set<Polyline> getSelectedRoutePolylines() {
    return routePolylines[selectedRoute] ?? {};
  }

  /// clears all markers, routes, and UI fields.
  void clearAll() {
    origin = null;
    destination = null;
    originMarker = null;
    destinationMarker = null;
    originController.clear();
    destinationController.clear();
    routes = [];
    selectedRoute = null;
    fareBreakdown = '';
    totalFare = 0;
    isSettingOrigin = true;
    routePolylines.clear();
    
    notifyListeners();
  }
}
