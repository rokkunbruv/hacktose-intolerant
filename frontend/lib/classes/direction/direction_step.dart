import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:tultul/classes/location/location.dart';
import 'package:tultul/utils/route/decode_polyline.dart';

/// models a single transit step.
class DirectionStep {
  final String travelMode;
  final double distance; // in m
  final int duration; // in sec
  final String? jeepneyName;
  final String? jeepneyCode;
  late double? jeepneyFare;
  late Location? origin;
  final LatLng? originCoords;
  late Location? destination;
  final LatLng? destinationCoords;
  final Polyline polyline;

  DirectionStep({
    required this.travelMode, 
    required this.distance,
    required this.duration, 
    this.jeepneyName,
    this.jeepneyCode,
    this.origin,
    this.originCoords,
    this.destination,
    this.destinationCoords,
    required this.polyline,
  });

  factory DirectionStep.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> originJson = json['startLocation']['latLng'];
    Map<String, dynamic> destinationJson = json['endLocation']['latLng'];
    
    String travelMode = json['travelMode'];
    double distance = (json['distanceMeters'] != null) 
    ? json['distanceMeters'].toDouble() : Geolocator.distanceBetween(
      originJson['latitude'].toDouble(),
      originJson['longitude'].toDouble(),
      destinationJson['latitude'].toDouble(),
      destinationJson['longitude'].toDouble(),
    );
    int duration = int.parse(json['staticDuration'].replaceAll(RegExp(r'[^0-9]'), ''));
    Polyline polyline = decodePolyline(json['polyline']['encodedPolyline']);
    String? jeepneyName;
    String? jeepneyCode;
    LatLng? originCoords;
    LatLng? destinationCoords;

    if (travelMode == 'TRANSIT' && json['transitDetails'] != null) {
      jeepneyName = json['transitDetails']['transitLine']['name'];
      jeepneyCode = json['transitDetails']['transitLine']['nameShort'];

      originCoords = LatLng(originJson['latitude'].toDouble(), originJson['longitude'].toDouble());
      destinationCoords = LatLng(destinationJson['latitude'].toDouble(), destinationJson['longitude'].toDouble());
    }
    
    return DirectionStep(
      travelMode: travelMode,
      distance: distance,
      duration: duration,
      jeepneyName: jeepneyName,
      jeepneyCode: jeepneyCode,
      originCoords: originCoords,
      destinationCoords: destinationCoords,
      polyline: polyline,
    );
  }

  void setJeepneyFare(double jeepneyFare) {
    this.jeepneyFare = jeepneyFare;
  }
}