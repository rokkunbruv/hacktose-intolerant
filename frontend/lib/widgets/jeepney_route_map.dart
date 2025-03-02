import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class JeepneyRouteMap extends StatefulWidget {
  final String jsonFile;

  const JeepneyRouteMap({super.key, required this.jsonFile});

  @override
  _JeepneyRouteMapState createState() => _JeepneyRouteMapState();
}

class _JeepneyRouteMapState extends State<JeepneyRouteMap> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  List<String> _routeNames = [];
  List<LatLng> _allPoints = []; // Store all route points
  bool _isCameraMovedByUser = false; // ✅ Track if user has moved the camera

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    final String apiUrl =
        "http://3.106.113.161:8080/jeepney_routes/${widget.jsonFile}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        Set<Polyline> polylines = {};
        List<String> routeNames = [];
        List<LatLng> allPoints = [];

        List<Color> colors = [
          const Color.fromARGB(255, 94, 255, 116).withOpacity(0.7),
          Colors.blue.withOpacity(0.7)
        ];

        for (int i = 0; i < jsonData['routes'].length; i++) {
          var route = jsonData['routes'][i];

          List<LatLng> path = (route['path'] as List)
              .map((point) => LatLng(point[0], point[1]))
              .toList();

          allPoints.addAll(path);

          polylines.add(
            Polyline(
              polylineId: PolylineId('${route['name']}-${route['label']}'),
              points: path,
              color: colors[i % colors.length],
              width: 8,
              zIndex: i,
            ),
          );

          routeNames.add(route['name']);
        }

        setState(() {
          _polylines = polylines;
          _routeNames = routeNames;
          _allPoints = allPoints;
        });

        // ✅ Only move camera if the user hasn't manually moved it
        if (_mapController != null && _allPoints.isNotEmpty && !_isCameraMovedByUser) {
          _calculateBounds(_allPoints);
        }
      } else {
        print("❌ Error fetching route: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error loading route from API: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // ✅ Only move camera initially, but never reset user movement
    Future.delayed(Duration.zero, () {
      if (_allPoints.isNotEmpty && !_isCameraMovedByUser) {
        _calculateBounds(_allPoints);
      }
    });
  }

  void _calculateBounds(List<LatLng> routePoints) {
    if (routePoints.isEmpty || _mapController == null) return;

    double minLat = routePoints.first.latitude, maxLat = routePoints.first.latitude;
    double minLng = routePoints.first.longitude, maxLng = routePoints.first.longitude;

    for (LatLng point in routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // ✅ Move camera only if user hasn't moved it manually
    if (!_isCameraMovedByUser) {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  /// ✅ Track when user moves the camera
  void _onCameraMove(CameraPosition position) {
    if (!_isCameraMovedByUser) {
      print("📍 User moved the camera. Stopping auto-reset.");
    }
    _isCameraMovedByUser = true;
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
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove, // ✅ Detects user zoom/pan
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
                          widget.jsonFile,
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
