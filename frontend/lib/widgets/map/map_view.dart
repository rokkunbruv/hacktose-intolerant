import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tultul/styles/map/map_styles.dart';

class MapView extends StatefulWidget {
  final Function(LatLng)? onMapTap;
  final Function(GoogleMapController)? onMapCreated;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
  final bool? snapToCurrentPosition;
  final bool? snapToPolyline;

  const MapView({
    super.key,
    this.onMapTap, 
    this.onMapCreated,
    this.markers,
    this.polylines,
    this.snapToCurrentPosition,
    this.snapToPolyline,
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
    widget.onMapCreated?.call(controller);

    if (widget.snapToCurrentPosition == true && widget.markers != null) {
      final currentPositionMarker = widget.markers!.firstWhere(
        (marker) => marker.markerId.value == 'currentPosition',
        orElse: () => throw Exception('Current position marker not found'),
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPositionMarker.position, _defaultZoomLevel),
      );
    }

    if (widget.snapToPolyline == true && widget.polylines != null && widget.polylines!.isNotEmpty) {
      final polyline = widget.polylines!.first;
      final bounds = _calculateBounds(polyline.points);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      northeast: LatLng(maxLat, maxLng),
      southwest: LatLng(minLat, minLng),
    );
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