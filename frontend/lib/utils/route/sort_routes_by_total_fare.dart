import 'package:tultul/classes/route/commute_route.dart';

void sortRoutesByTotalFare(List<CommuteRoute> routes) {
  routes.sort((route1, route2) {
    return route1.totalFare.compareTo(route2.totalFare);
  });
}