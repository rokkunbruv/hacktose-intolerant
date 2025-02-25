import 'dart:math';

import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/classes/direction/direction_path.dart';
import 'package:tultul/classes/route/jeepney_ride.dart';
import 'package:tultul/constants/passenger_types.dart';
import 'package:tultul/constants/jeepney_types.dart';

/// Holds the result of the fare calculation.
class RouteDetails {
  final List<JeepneyRide> rides;
  final double totalDistance;
  final double totalFare;

  RouteDetails({
    required this.rides, 
    required this.totalDistance,
    required this.totalFare,
  });
}

/// calculates the total fare, distance, and rides for a given route
RouteDetails calculateRouteDetails(CommuteRoute route, String passengerType, String jeepneyType) {
  double totalFare = 0;
  double distanceKm = 0;
  List<JeepneyRide> rides = [];

  DirectionPath path = route.path;

  for (var leg in path.legs) {
    for (var step in leg.steps) {
      if (step.travelMode == 'TRANSIT' && step.transitLineName != null) {
        // convert distance to kilometers
        distanceKm = step.distanceValue / 1000.0;

        // calculate fare considering discounts and jeepney types
        double baseFare;
        if (passengerType == regular) {
          baseFare = (jeepneyType == modern) ? 15 : 13;
        } else {
          baseFare = (jeepneyType == modern) ? 12 : 10;
        }

        double additionalKm = max(0, distanceKm - 4);
        double stepFare = baseFare + additionalKm.ceil();

        JeepneyRide ride = JeepneyRide(
          route: step.transitLineName ?? '',
          type: jeepneyType,
          fare: stepFare,
        );
        rides.add(ride);

        totalFare += stepFare;
      }
    }
  }

  return RouteDetails(
    rides: rides,
    totalDistance: distanceKm, 
    totalFare: totalFare,
  );
}
