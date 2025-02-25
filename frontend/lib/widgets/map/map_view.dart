import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/styles/map/map_styles.dart';

class MapView extends StatefulWidget {
  final Function(LatLng)? onMapTap;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;

  const MapView({
    super.key,
    this.onMapTap, 
    this.markers,
    this.polylines,
    });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  final LatLng _initPos = const LatLng(10.3157, 123.8854); // Cebu City
  final double _defaultZoomLevel = 18.0;
  final double _minZoomLevel = 10.0;
  final double _maxZoomLevel = 20.0;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
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
      onTap: widget.onMapTap,
      markers: widget.markers ?? <Marker>{},
      polylines: widget.polylines ?? <Polyline>{},
      style: customMapStyle,
    );
  }
}
