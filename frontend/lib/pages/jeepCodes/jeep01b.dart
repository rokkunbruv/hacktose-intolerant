import 'package:flutter/material.dart';
import 'package:tultul/widgets/jeepney_route_map.dart';

class Jeep01B extends StatelessWidget { 
  const Jeep01B({super.key});

  @override
  Widget build(BuildContext context) {
    return const JeepneyRouteMap(jsonFile: '01B');
  }
}
