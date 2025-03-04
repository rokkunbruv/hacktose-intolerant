import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/styles/map/map_styles.dart';
import 'package:tultul/utils/map/calculate_bounds.dart';
import 'package:tultul/utils/map/calculate_marker_bounds.dart';
import 'package:tultul/theme/colors.dart';

class MapView extends StatefulWidget {
  final Function(LatLng)? onMapTap;
  final Function(GoogleMapController)? onMapCreated;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
  final bool? snapToCurrentPosition;
  final bool? snapToMarkers;
  final bool? snapToPolyline;
  final double? bottomPadding;

  const MapView({
    super.key,
    this.onMapTap, 
    this.onMapCreated,
    this.markers,
    this.polylines,
    this.snapToCurrentPosition,
    this.snapToMarkers,
    this.snapToPolyline,
    this.bottomPadding,
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

    if (widget.snapToMarkers == true && widget.markers != null && widget.markers!.isNotEmpty) {
      final bounds = calculateMarkerBounds(widget.markers!);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }

    if (widget.snapToPolyline == true && widget.polylines != null && widget.polylines!.isNotEmpty) {
      final polyline = widget.polylines!.first;
      final bounds = calculateBounds(polyline.points);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  void _recenterMap() {
    if (_mapController == null) return;

    if (widget.snapToCurrentPosition == true && widget.markers != null) {
      final currentPositionMarker = widget.markers!.firstWhere(
        (marker) => marker.markerId.value == 'currentPosition',
        orElse: () => throw Exception('Current position marker not found'),
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPositionMarker.position, _defaultZoomLevel),
      );
    } else if (widget.snapToMarkers == true && widget.markers != null && widget.markers!.isNotEmpty) {
      final bounds = calculateMarkerBounds(widget.markers!);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } else if (widget.snapToPolyline == true && widget.polylines != null && widget.polylines!.isNotEmpty) {
      final polyline = widget.polylines!.first;
      final bounds = calculateBounds(polyline.points);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initPos,
              zoom: _defaultZoomLevel,
            ),
            minMaxZoomPreference: MinMaxZoomPreference(_minZoomLevel, _maxZoomLevel),
            zoomControlsEnabled: false,
            trafficEnabled: true,
            onTap: widget.onMapTap,
            markers: widget.markers ?? <Marker>{},
            polylines: widget.polylines ?? <Polyline>{},
            style: customMapStyle,
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 16,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _recenterMap,
                  icon: Icon(Icons.center_focus_strong, color: AppColors.red),
                  padding: EdgeInsets.all(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}