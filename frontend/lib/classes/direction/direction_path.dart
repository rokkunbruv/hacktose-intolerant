import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/classes/direction/direction_leg.dart';
import 'package:tultul/utils/route/decode_polyline.dart';

/// models an entire route.
class DirectionPath {
  final List<DirectionLeg> legs;
  final Polyline polyline;

  DirectionPath({
    required this.legs,
    required this.polyline
  });

  factory DirectionPath.fromJson(Map<String, dynamic> json) {
    var legsJson = json['legs'] as List;
    List<DirectionLeg> legs = legsJson.map((l) => DirectionLeg.fromJson(l)).toList();
    var polyline = decodePolyline(json['polyline']['encodedPolyline']);

    return DirectionPath(
      legs: legs,
      polyline: polyline,
    );
  }
}