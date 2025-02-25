import 'package:flutter/material.dart';

import 'package:tultul/widgets/route/route_item.dart';
import 'package:tultul/classes/route/commute_route.dart';

class RouteList extends StatelessWidget {
  final List<CommuteRoute> routes;
  final Function(CommuteRoute) onRouteSelected;

  const RouteList({
    super.key, 
    required this.routes, 
    required this.onRouteSelected
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: routes.asMap().entries.map((entry) {
        CommuteRoute route = entry.value;

        return GestureDetector(
          onTap: () => onRouteSelected(route),
          child: Column(
            children: <Widget>[
              RouteItem(
                route: route,
              ),
              SizedBox(height: 8),
            ],
          )
        );
      }).toList(),
    );
  }
}
