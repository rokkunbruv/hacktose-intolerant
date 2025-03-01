import 'package:tultul/classes/direction/direction_path.dart';
import 'package:tultul/classes/route/jeepney_ride.dart';

// contains information about a route
class CommuteRoute {
  final DirectionPath path;
  late double totalFare;
  late double totalDistance;
  late List<JeepneyRide> rides;

  CommuteRoute({
    required this.path,
  });

  // getters
  DirectionPath get getDirectionPath => path;
  double get getTotalFare => totalFare;
  double get getTotalDistance => totalDistance;

  // setters
  void setTotalFare(double fare) {
    totalFare = fare;
  }

  void setTotalDistance(double distance) {
    totalDistance = distance;
  }
}