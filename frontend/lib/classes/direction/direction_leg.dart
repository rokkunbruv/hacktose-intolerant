import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/classes/direction/direction_step.dart';
import 'package:tultul/constants/travel_modes.dart';
import 'package:tultul/styles/map/polyline_styles.dart';

/// models a leg of the journey.
class DirectionLeg {
  final List<DirectionStep> steps;
  final double totalDistance; // in m
  final int totalDuration; // in sec

  DirectionLeg({
    required this.steps,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory DirectionLeg.fromJson(Map<String, dynamic> json) {
    var stepsJson = json['steps'] as List;
    var totalDistance = json['distanceMeters'].toDouble();
    var totalDuration = int.parse(json['duration'].replaceAll(RegExp(r'[^0-9]'), ''));

    List<DirectionStep> steps = [];
    List<DirectionStep> walkStepsBuffer = [];

    for (var stepJson in stepsJson) {
      DirectionStep step = DirectionStep.fromJson(stepJson);

      if (step.travelMode == walk) {
        walkStepsBuffer.add(step);
      } else {
        if (walkStepsBuffer.isNotEmpty) {
          steps.add(combineWalkSteps(walkStepsBuffer));
          walkStepsBuffer.clear();
        }

        steps.add(step);
      }
    }

    if (walkStepsBuffer.isNotEmpty) {
      steps.add(combineWalkSteps(walkStepsBuffer));
    }

    return DirectionLeg(
      steps: steps,
      totalDistance: totalDistance,
      totalDuration: totalDuration,
    );
  }

  /// combines consecutive walk steps into a single step.
  static DirectionStep combineWalkSteps(List<DirectionStep> walkSteps) {
    double totalDistance = 0;
    int totalDuration = 0;
    List<LatLng> combinedCoordinates = [];

    for (var step in walkSteps) {
      totalDistance += step.distance;
      totalDuration += step.duration;
      combinedCoordinates.addAll(step.polyline.points);
    }

    Polyline combinedPolyline = createPolyline(
      'combined_walk_steps',
      combinedCoordinates,
    );

    return DirectionStep(
      travelMode: 'WALK',
      distance: totalDistance,
      duration: totalDuration,
      polyline: combinedPolyline,
    );
  }
}