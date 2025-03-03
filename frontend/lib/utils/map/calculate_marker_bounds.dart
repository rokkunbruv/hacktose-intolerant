import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLngBounds calculateMarkerBounds(Set<Marker> markers) {
  double minLat = markers.first.position.latitude;
  double maxLat = markers.first.position.latitude;
  double minLng = markers.first.position.longitude;
  double maxLng = markers.first.position.longitude;

  for (final marker in markers) {
    if (marker.position.latitude < minLat) minLat = marker.position.latitude;
    if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
    if (marker.position.longitude < minLng) minLng = marker.position.longitude;
    if (marker.position.longitude > maxLng) maxLng = marker.position.longitude;
  }

  return LatLngBounds(
    northeast: LatLng(maxLat, maxLng),
    southwest: LatLng(minLat, minLng),
  );
}