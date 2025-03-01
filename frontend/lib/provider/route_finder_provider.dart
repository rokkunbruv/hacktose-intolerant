import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/api/google_maps_api/routes.dart';
import 'package:tultul/api/google_maps_api/places_api.dart';
import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/classes/direction/direction_step.dart';
import 'package:tultul/classes/location/location.dart';
import 'package:tultul/constants/jeepney_types.dart';
import 'package:tultul/constants/passenger_types.dart';
import 'package:tultul/constants/travel_modes.dart';
import 'package:tultul/styles/map/marker_styles.dart';
import 'package:tultul/utils/route/calculate_fare.dart';
import 'package:tultul/utils/route/filter_duplicate_routes.dart';
import 'package:tultul/utils/route/sort_routes_by_total_fare.dart';
import 'package:tultul/utils/route/decode_polyline.dart';

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

  // dropdown selections.
  String selectedPassengerType = regular;
  String selectedJeepneyType = traditional;

  CommuteRoute? selectedRoute;

  void setPassengerType(String type) {
    selectedPassengerType = type;

    updateFares();
    notifyListeners();
  }

  void setJeepneyType(String type) {
    selectedJeepneyType = type;

    updateFares();
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

  // update fare calculations
  void updateFares() {
    for (CommuteRoute route in routes) {
      double totalFare = 0;
      
      for (DirectionStep step in route.path.legs[0].steps) {
        if (step.travelMode == transit) {
          step.jeepneyFare = calculateFare(step.distance, selectedJeepneyType, selectedPassengerType);
          totalFare += step.jeepneyFare!;
        } else {
          step.jeepneyFare = null;
        }
      }

      route.totalFare = totalFare;
    }
  }

  /// fetch routes using the directions api.
  Future<void> findRoutes() async {
    if (originController.text.isEmpty || destinationController.text.isEmpty) {
      throw('Origin and destination are not all set.');
    }

    try {
      routes = await RoutesApi.getDirections(
        originController.text, 
        destinationController.text
      );
      routes = filterDuplicateRoutes(routes);

      updateFares();

      // sort routes once fares have been initialized
      sortRoutesByTotalFare(routes);

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
    isSettingOrigin = true;
    
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
