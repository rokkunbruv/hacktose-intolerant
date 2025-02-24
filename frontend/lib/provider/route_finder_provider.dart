import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:hacktose_intolerant_app/api/google_maps_api/directions.dart';
import 'package:hacktose_intolerant_app/classes/route/route.dart';
import 'package:hacktose_intolerant_app/utils/route/calculate_route_details.dart';

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

      originMarker = Marker(
        markerId: const MarkerId('origin'),
        position: location,
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      );
    } else {
      destination = location;
      destinationController.text = '${location.latitude}, ${location.longitude}';
      isSettingOrigin = true;

      destinationMarker = Marker(
        markerId: const MarkerId('destination'),
        position: location,
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
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
        routePolylines[route] = (_decodePolyline(route.path.overviewPolyline));
        
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

  /// decode polyline for a specific route
  Set<Polyline> _decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints =
        polylinePoints.decodePolyline(encodedPolyline);

    List<LatLng> polylineCoordinates = decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    if (polylineCoordinates.isEmpty) return {};

    return {
      Polyline(
        polylineId: PolylineId('route_${routePolylines.length}'),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
      ),
    };
  }

  /// select a route and calculate its fare.
  void selectRoute(CommuteRoute route) {
    selectedRoute = route;

    notifyListeners();
  }

  /// Get polylines for the selected route
  Set<Polyline> getSelectedRoutePolylines() {
    return routePolylines[selectedRoute] ?? {};
  }

  /// Clears all markers, routes, and UI fields.
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
