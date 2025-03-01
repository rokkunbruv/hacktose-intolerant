import 'dart:math';

import 'package:tultul/constants/passenger_types.dart';
import 'package:tultul/constants/jeepney_types.dart';
import 'package:tultul/constants/fares.dart';

/// calculates the total fare of a jeepney
double calculateFare(double distanceM, String jeepneyType, String passengerType) {
  double distanceKm = distanceM / 1000.0;

  // calculate fare considering discounts and jeepney types
  double baseFare = (jeepneyType == traditional) ? tradJeepneyFare : modernJeepneyFare;
  baseFare = baseFare - ((passengerType == regular) ? 0 : (baseFare * 0.2).roundToDouble());

  // calculate final fare based on distance covered
  double additionalKm = max(0, distanceKm - 4);
  return baseFare + additionalKm.ceil();
}