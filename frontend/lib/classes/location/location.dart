import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final String address;
  final LatLng coordinates;

  Location({
    required this.address,
    required this.coordinates,
  });

  String get getAddress => address;
  LatLng get getCoordinates => coordinates;
}