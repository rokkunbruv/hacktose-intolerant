import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:tultul/widgets/generic/draggable_container.dart';
// import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class JeepneyRouteMap extends StatefulWidget {
  final String jsonFile; // Pass JSON file name

  const JeepneyRouteMap({super.key, required this.jsonFile});

  @override
  _JeepneyRouteMapState createState() => _JeepneyRouteMapState();
}

class _JeepneyRouteMapState extends State<JeepneyRouteMap> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  List<String> _routeNames = [];

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    String jsonString =
        await rootBundle.loadString('assets/coordinates/${widget.jsonFile}');
    final jsonData = jsonDecode(jsonString);

    Set<Polyline> polylines = {};
    List<String> routeNames = [];

    // Define colors and styles for overlapping effect
    List<Color> colors = [
      AppColors.saffron.withOpacity(0.7),
      Colors.blue.withOpacity(0.7)
    ];
    List<int> zIndices = [1, 2]; // Blue route drawn on top

    for (int i = 0; i < jsonData['routes'].length; i++) {
      var route = jsonData['routes'][i];

      List<LatLng> path = (route['path'] as List)
          .map((point) => LatLng(point[0], point[1]))
          .toList();

      print(
          "Loading Route: ${route['name']} - ${path.length} points"); // Debugging

      polylines.add(
        Polyline(
          polylineId: PolylineId(
              '${route['name']}-${route['label']}'), // Ensures uniqueness
          points: path,
          color: colors[i % colors.length],
          width: 8, // Set a uniform thickness
          zIndex: i, // Ensures routes are drawn in order
        ),
      );

      routeNames.add(route['name']);
    }

    setState(() {
      _polylines = polylines;
      _routeNames = routeNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeepney Routes',
            style: AppTextStyles.title1.copyWith(color: AppColors.vanilla)),
        centerTitle: true,
        backgroundColor: AppColors.red,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(10.299297, 123.888721),
              zoom: 14.5,
            ),
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          DraggableContainer(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.lightGray),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        const SizedBox(width: 120),
                        Text(
                          '01B',
                          style: AppTextStyles.label1
                              .copyWith(color: AppColors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Column(
                    children: _routeNames.asMap().entries.map((entry) {
                      int index = entry.key;
                      String name = entry.value;
                      Image icon = index == 0
                          ? Image.asset('assets/icons/route_legend_yellow.png',
                              width: 30, height: 30)
                          : Image.asset('assets/icons/route_legend_blue.png',
                              width: 30, height: 30);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            icon,
                            const SizedBox(width: 5),
                            Text(name,
                                style: AppTextStyles.label4
                                    .copyWith(color: AppColors.black)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
