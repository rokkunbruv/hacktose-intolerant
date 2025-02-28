import 'package:flutter/material.dart';
import 'package:tultul/widgets/jeepney_route_map.dart'; // Import the reusable component

class jeep01b extends StatelessWidget {
  const jeep01b({super.key});

  @override
  Widget build(BuildContext context) {
    return const JeepneyRouteMap(jsonFile: 'coords01b.json'); // Specify JSON file
  }
}
