import 'package:tultul/classes/direction/direction_leg.dart';

/// models an entire route.
class DirectionPath {
  final List<DirectionLeg> legs;
  final String overviewPolyline;

  DirectionPath({
    required this.legs, required this.overviewPolyline
  });

  factory DirectionPath.fromJson(Map<String, dynamic> json) {
    var legsJson = json['legs'] as List;
    List<DirectionLeg> legs = legsJson.map((l) => DirectionLeg.fromJson(l)).toList();
    return DirectionPath(
      legs: legs,
      overviewPolyline: json['overview_polyline']['points'],
    );
  }
}