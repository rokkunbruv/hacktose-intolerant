import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:tultul/api/jeepney_api/jeepney_api.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class JeepRoutePage extends StatefulWidget {
  final String jsonFile;

  const JeepRoutePage({super.key, required this.jsonFile});

  @override
  State<JeepRoutePage> createState() => _JeepRoutePageState();
}

class _JeepRoutePageState extends State<JeepRoutePage> {
  Set<Polyline> _polylines = {};
  List<String> _routeNames = [];
  // List<LatLng> _allPoints = [];

  bool _isMapLoaded = false;

  void navigateBack() {
    Navigator.of(context).pop();
  }

  Future<void> loadRoute() async {
    Map<String, dynamic> jsonRouteData = await JeepneyApi.getJeepneyRoute(widget.jsonFile);

    _polylines = jsonRouteData['polylines'];
    _routeNames = jsonRouteData['routeNames'];
    // _allPoints = jsonRouteData['allPoints'];

    if (jsonRouteData != {}) {
      setState(() => _isMapLoaded = true);
    }
  }
  // void _calculateBounds(List<LatLng> routePoints) {
  //   if (routePoints.isEmpty || _mapController == null) return;

  //   double minLat = routePoints.first.latitude, maxLat = routePoints.first.latitude;
  //   double minLng = routePoints.first.longitude, maxLng = routePoints.first.longitude;

  //   for (LatLng point in routePoints) {
  //     if (point.latitude < minLat) minLat = point.latitude;
  //     if (point.latitude > maxLat) maxLat = point.latitude;
  //     if (point.longitude < minLng) minLng = point.longitude;
  //     if (point.longitude > maxLng) maxLng = point.longitude;
  //   }

  //   LatLngBounds bounds = LatLngBounds(
  //     southwest: LatLng(minLat, minLng),
  //     northeast: LatLng(maxLat, maxLng),
  //   );

  //   if (!_isCameraMovedByUser) {
  //     _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  //   }
  // }

  // void _onCameraMove(CameraPosition position) {
  //   _isCameraMovedByUser = true;
  // }

  @override
  void initState() {
    super.initState();

    loadRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeepney Routes',
            style: AppTextStyles.title1.copyWith(color: AppColors.vanilla)),
        centerTitle: true,
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // MAP VIEW
          _isMapLoaded
              ? MapView(
                polylines: _polylines,
              )
              : Center(child: CircularProgressIndicator()),

          // ROUTE DETAILS
          if (_isMapLoaded)
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
                      child: Stack(
                        alignment: Alignment.center, 
                        children: [
                          Align(
                            alignment: Alignment.centerLeft, 
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: navigateBack,
                            ),
                          ),
                          Center( 
                            child: Text(
                              widget.jsonFile,
                              style: AppTextStyles.label1.copyWith(color: AppColors.red),
                            ),
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
                            ? Image.asset('assets/icons/route_legend_yellow.png', width: 30, height: 30)
                            : Image.asset('assets/icons/route_legend_blue.png', width: 30, height: 30);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              icon,
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  name, 
                                  style: AppTextStyles.label4.copyWith(
                                    color: AppColors.black
                                  ),
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
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
