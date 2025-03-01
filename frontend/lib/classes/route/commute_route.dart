import 'package:flutter/material.dart';
import 'package:tultul/classes/direction/direction_path.dart';
import 'package:tultul/constants/travel_modes.dart';

// contains information about a route
class CommuteRoute {
  final DirectionPath path;
  late double totalDistance;
  late int totalDuration;
  late TimeOfDay departureTime;
  late TimeOfDay arrivalTime;
  late double totalFare;
  late List<String> rides;

  CommuteRoute({required this.path}) {
    totalDistance = 0;
    totalDuration = 0;
    rides = [];
    
    for (var leg in path.legs) {
      // compute total distance and duration of a route
      totalDistance += leg.totalDistance;
      totalDuration += leg.totalDuration;

      // add list of jeepneys to ride
      for (var step in leg.steps) {
        if (step.travelMode == transit && step.jeepneyCode != null) {
          rides.add(step.jeepneyCode!);
        }
      }
    }

    DateTime now = DateTime.now();

    DateTime departureDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    departureDateTime = departureDateTime.add(Duration(seconds: totalDuration));

    departureTime = TimeOfDay(hour: now.hour, minute: now.minute);
    arrivalTime = TimeOfDay(hour: departureDateTime.hour, minute: departureDateTime.minute);

    debugPrint(departureTime.toString() + arrivalTime.toString());
  }

  // getters
  DirectionPath get getDirectionPath => path;
  double get getTotalDistance => totalDistance;
  int get getTotalDuration => totalDuration;
  double get getTotalFare => totalFare;
}