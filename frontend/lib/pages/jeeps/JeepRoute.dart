import 'package:flutter/material.dart';
import 'package:tultul/widgets/jeepney_route_map.dart';

class JeepRoutePage extends StatelessWidget {
  final String routeCode;

  const JeepRoutePage({super.key, required this.routeCode});

  @override
  Widget build(BuildContext context) {
    return JeepneyRouteMap(jsonFile: routeCode); // Load JSON dynamically
  }
}
