import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (pi / 180);
    double lng1 = start.longitude * (pi / 180);
    double lat2 = end.latitude * (pi / 180);
    double lng2 = end.longitude * (pi / 180);

    double dLon = lng2 - lng1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);

    return (bearing * (180 / pi) + 360) % 360; // convert to degrees
  }