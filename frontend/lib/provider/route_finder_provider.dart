import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/api/google_maps_api/directions_api.dart';
import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/styles/map/marker_styles.dart';
import 'package:tultul/utils/route/calculate_route_details.dart';
import 'package:tultul/utils/route/decode_polyline.dart';
import 'package:tultul/classes/location/location.dart';
import 'package:tultul/api/google_maps_api/places_api.dart';

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
    try {
      // Show loading state if you have one
      final nearestPlace = await PlacesApi.getNearestPlace(location);
      
      if (nearestPlace != null) {
        print('Setting marker at: ${nearestPlace.address}');
        
        if (isSettingOrigin) {
          origin = nearestPlace.coordinates; // Use the snapped coordinates
          originController.text = nearestPlace.address;
          isSettingOrigin = false;
          originMarker = createOriginMarker(
            nearestPlace.coordinates
          );
        } else {
          destination = nearestPlace.coordinates; // Use the snapped coordinates
          destinationController.text = nearestPlace.address;
          isSettingOrigin = true;
          destinationMarker = createDestinationMarker(
            nearestPlace.coordinates
          );
        }

        if (originController.text.isNotEmpty && destinationController.text.isNotEmpty) {
          await findRoutes();
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error setting marker: $e');
    }
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

  void setOrigin(Location location) {
    origin = location.coordinates;
    originController.text = location.address;
    originMarker = createOriginMarker(location.coordinates);
    
    if (destination != null) {
      findRoutes();
    }
    
    notifyListeners();
  }

  void setDestination(Location location) {
    destination = location.coordinates;
    destinationController.text = location.address;
    destinationMarker = createDestinationMarker(location.coordinates);
    
    if (origin != null) {
      findRoutes();
    }
    
    notifyListeners();
  }

  void clearOrigin() {
    origin = null;
    originController.clear();
    originMarker = null;
    notifyListeners();
  }

  void clearDestination() {
    destination = null;
    destinationController.clear();
    destinationMarker = null;
    notifyListeners();
  }
}
