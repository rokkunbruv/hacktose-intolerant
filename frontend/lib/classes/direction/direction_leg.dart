import 'package:hacktose_intolerant_app/classes/direction/direction_step.dart';

/// models a leg of the journey.
class DirectionLeg {
  final List<DirectionStep> steps;

  DirectionLeg({
    required this.steps
  });

  factory DirectionLeg.fromJson(Map<String, dynamic> json) {
    var stepsJson = json['steps'] as List;
    List<DirectionStep> steps = stepsJson.map((s) => DirectionStep.fromJson(s)).toList();

    return DirectionLeg(steps: steps);
  }
}