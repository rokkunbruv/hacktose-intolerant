import 'package:tultul/classes/route/commute_route.dart';

List<CommuteRoute> filterDuplicateRoutes(List<CommuteRoute> routes) {
  Set<String> uniqueRouteKeys = {};
  List<CommuteRoute> filteredRoutes = [];

  for (CommuteRoute route in routes) {
    String routeKey = _createRouteKey(route);

    if (!uniqueRouteKeys.contains(routeKey)) {
      uniqueRouteKeys.add(routeKey);
      filteredRoutes.add(route);
    }
  }

  return filteredRoutes;
}

/// create route key based on total distance, total duration, times, and rides
String _createRouteKey(CommuteRoute route) {
  return '${route.totalDistance}_${route.totalDuration}_'
         '${route.departureTime.hour}:${route.departureTime.minute}_'
         '${route.arrivalTime.hour}:${route.arrivalTime.minute}_'
         '${route.rides.join(',')}';
}