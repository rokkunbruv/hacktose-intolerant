import 'package:flutter/material.dart';
import 'package:tultul/widgets/jeepney_route_map.dart';

class Jeep04L extends StatelessWidget { 
  const Jeep04L({super.key});

  @override
  Widget build(BuildContext context) {
    return const JeepneyRouteMap(jsonFile: '04L');
  }
}
