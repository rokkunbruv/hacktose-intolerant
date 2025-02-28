import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tultul/utils/location/get_position.dart';
import 'package:tultul/styles/map/marker_styles.dart';

class PositionProvider extends ChangeNotifier {
  LatLng? currentPosition;
  Marker? currentPositionMarker;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Start listening to location updates
  Future<void> startPositionUpdates() async {
    bool hasPermission = await checkLocationPermissions();
    if (!hasPermission) {
      debugPrint("Location services are disabled or permission denied.");
      return;
    }

    // Cancel existing stream if already running
    _positionStreamSubscription?.cancel();

    _positionStreamSubscription = getPositionStream().listen(
      (Position position) {
        currentPosition = LatLng(position.latitude, position.longitude);
        currentPositionMarker = createCurrentPositionMarker(currentPosition ?? LatLng(0, 0));
        
        debugPrint("Updated Position: $currentPosition");

        notifyListeners();
      },
      onError: (error) {
        debugPrint("Error getting location updates: $error");
      },
    );
  }

  // Stop listening to location updates
  void stopPositionUpdates() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  @override
  void dispose() {
    stopPositionUpdates();
    super.dispose();
  }
}
