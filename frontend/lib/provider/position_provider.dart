import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:tultul/api/google_maps_api/places_api.dart';
import 'package:tultul/classes/location/location.dart';
import 'package:tultul/utils/location/get_position.dart';
import 'package:tultul/styles/map/marker_styles.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/utils/navigation/navigator_key.dart';

class PositionProvider extends ChangeNotifier {
  LatLng? currentPosition;
  Location? currentLocation;
  Marker? currentPositionMarker;

  StreamSubscription<Position>? _positionStreamSubscription;

  // start listening to location updates
  Future<void> startPositionUpdates() async {
    bool hasPermission = await checkLocationPermissions();
    if (!hasPermission) {
      debugPrint("Location services are disabled or permission denied.");
      return;
    }

    // cancel existing stream if already running
    _positionStreamSubscription?.cancel();

    _positionStreamSubscription = getPositionStream().listen(
      (Position position) async {
        currentPosition = LatLng(position.latitude, position.longitude);
        await _updateCurrentLocation();
        currentPositionMarker = createCurrentPositionMarker(currentPosition ?? LatLng(0, 0));

        // Update the route finder provider with the current location
        if (currentLocation != null && navigatorKey.currentContext != null) {
          final routeFinderProvider = Provider.of<RouteFinderProvider>(
            navigatorKey.currentContext!,
            listen: false
          );
          routeFinderProvider.updateCurrentLocation(currentLocation!);
        }

        notifyListeners();
      },
      onError: (error) {
        debugPrint("Error getting location updates: $error");
      },
    );
  }

  // stop listening to location updates
  void stopPositionUpdates() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  Future<void> _updateCurrentLocation() async {
    if (currentPosition != null) {
      currentLocation = await PlacesApi.getNearestPlace(currentPosition ?? LatLng(0, 0));
    } else {
      currentLocation = null;
    }
  }

  @override
  void dispose() {
    stopPositionUpdates();
    super.dispose();
  }
}
