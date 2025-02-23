import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:hacktose_intolerant_app/config/map/map_styles.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? mapController;

  // CONSTANTS
  final LatLng _initPos = const LatLng(10.3157, 123.8854); // Cebu City

  // zoom levels
  final double _defaultZoomLevel = 18.0;
  final double _minZoomLevel = 15.0;
  final double _maxZoomLevel = 20.0;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _initPos,
        zoom: _defaultZoomLevel,
      ),
      minMaxZoomPreference: MinMaxZoomPreference(_minZoomLevel, _maxZoomLevel),
      zoomControlsEnabled: false,
      style: customMapStyle,
    );
  }
}