import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker createOriginMarker(LatLng location) {
  const markerId = MarkerId('origin');
  const infoWindow = InfoWindow(title: 'Origin');
  const color = BitmapDescriptor.hueOrange;
  
  return Marker(
    markerId: markerId,
    position: location,
    infoWindow: infoWindow,
    icon: BitmapDescriptor.defaultMarkerWithHue(color),
  );
}

Marker createDestinationMarker(LatLng location) {
  const markerId = MarkerId('destination');
  const infoWindow = InfoWindow(title: 'Destination');
  const color = BitmapDescriptor.hueRed;

  return Marker(
    markerId: markerId,
    position: location,
    infoWindow: infoWindow,
    icon: BitmapDescriptor.defaultMarkerWithHue(color),
  );
}

Marker createCurrentPositionMarker(LatLng location) {
  const markerId = MarkerId('currentPosition');
  const infoWindow = InfoWindow(title: 'Your Position');
  const color = BitmapDescriptor.hueBlue;

  return Marker(
    markerId: markerId,
    position: location,
    infoWindow: infoWindow,
    icon: BitmapDescriptor.defaultMarkerWithHue(color),
  );
}

Marker createJeepneyyMarker(String markerId, BitmapDescriptor icon, position, double rotation) {
  return Marker(
    markerId: MarkerId(markerId),
    position: position,
    rotation: rotation,
    icon: icon,
    flat: true,
    visible: true,
    anchor: const Offset(0.5, 0.5),
  );
}