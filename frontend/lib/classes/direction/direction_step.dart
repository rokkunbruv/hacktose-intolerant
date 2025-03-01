import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart' as google_polyline;

import 'package:tultul/utils/route/decode_polyline.dart';

/// models a single transit step.
class DirectionStep {
  final String travelMode;
  final double distance; // in m
  final int duration; // in sec
  final String? jeepneyName;
  final String? jeepneyCode;
  late double? jeepneyFare;
  final String? origin;
  final String? destination;
  final Polyline polyline;

  DirectionStep({
    required this.travelMode, 
    required this.distance,
    required this.duration, 
    this.jeepneyName,
    this.jeepneyCode,
    this.origin,
    this.destination,
    required this.polyline,
  });

  factory DirectionStep.fromJson(Map<String, dynamic> json) {
    String travelMode = json['travelMode'];
    double distance = json['distanceMeters'].toDouble();
    int duration = int.parse(json['staticDuration'].replaceAll(RegExp(r'[^0-9]'), ''));
    Polyline polyline = decodePolyline(json['polyline']['encodedPolyline']);
    String? jeepneyName;
    String? jeepneyCode;
    String? origin;
    String? destination;

    if (travelMode == 'TRANSIT' && json['transitDetails'] != null) {
      jeepneyName = json['transitDetails']['transitLine']['name'];
      jeepneyCode = json['transitDetails']['transitLine']['nameShort'];

      Map<String, dynamic> originJson = json['startLocation']['latLng'];
      LatLng originCoords = LatLng(originJson['latitude'].toDouble(), originJson['longitude'].toDouble());
      Map<String, dynamic> destinationJson = json['endLocation']['latLng'];
      LatLng destinationCoords = LatLng(destinationJson['latitude'].toDouble(), destinationJson['longitude'].toDouble());
      
      // convert coordinates to locations using places api
      origin = originCoords.toString();
      destination = destinationCoords.toString();
    }
    
    return DirectionStep(
      travelMode: travelMode,
      distance: distance,
      duration: duration,
      jeepneyName: jeepneyName,
      jeepneyCode: jeepneyCode,
      origin: origin,
      destination: destination,
      polyline: polyline,
    );
  }

  void setJeepneyFare(double jeepneyFare) {
    this.jeepneyFare = jeepneyFare;
  }
}