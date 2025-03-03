import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/theme/colors.dart';

Polyline createPolyline(String polylineID, List<LatLng> polylineCoordinates) {
  Color color = AppColors.navy;
  const int width = 5;

  return Polyline(
    polylineId: PolylineId(polylineID),
    color: color,
    width: width,
    points: polylineCoordinates,
  );
}

Polyline createPolyline2(String polylineID, List<LatLng> polylineCoordinates) {
  Color color = AppColors.saffron;
  const int width = 5;

  return Polyline(
    polylineId: PolylineId(polylineID),
    color: color,
    width: width,
    points: polylineCoordinates,
  );
}