import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:tultul/styles/map/polyline_styles.dart';

/// decode polyline for a specific route
Set<Polyline> decodePolyline(String encodedPolyline) {
  PolylinePoints polylinePoints = PolylinePoints();
  List<PointLatLng> decodedPoints =
      polylinePoints.decodePolyline(encodedPolyline);

  List<LatLng> polylineCoordinates = decodedPoints
      .map((point) => LatLng(point.latitude, point.longitude))
      .toList();

  if (polylineCoordinates.isEmpty) return {};

  return {
    createPolyline(
      'route',
      polylineCoordinates,
    ),
  };
}