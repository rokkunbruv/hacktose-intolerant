import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tultul/provider/jeepney_provider.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedRouteFile = "04L";
  GoogleMapController? _mapController;
  bool _isInitialLoad = true;
  BitmapDescriptor? jeepneyIcon;

  @override
  void initState() {
    super.initState();
    _loadJeepneyIcon();
  }

  Future<void> _loadJeepneyIcon() async {
    try {
      debugPrint("Loading jeepney icon...");
      
      // Load the original image file
      final ByteData data = await rootBundle.load('assets/icons/jeepney_icon.png');
      final Uint8List bytes = data.buffer.asUint8List();
      
      // Decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: 30, targetHeight: 50);  // Very small size
      final ui.FrameInfo fi = await codec.getNextFrame();
      
      // Convert to byte data
      final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedBytes = byteData!.buffer.asUint8List();
      
      // Create the bitmap descriptor
      jeepneyIcon = BitmapDescriptor.fromBytes(resizedBytes);
      
      debugPrint("Jeepney icon loaded successfully");
      setState(() {});
    } catch (e) {
      debugPrint("Error loading jeepney icon: $e");
      jeepneyIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      setState(() {});
    }
  }

  void _centerCamera(LatLngBounds bounds) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  void _handleRouteChange(String newRoute) async {
    setState(() {
      selectedRouteFile = newRoute;
    });
    
    await Provider.of<JeepneyProvider>(context, listen: false)
        .loadRoute(newRoute);
    
    final provider = Provider.of<JeepneyProvider>(context, listen: false);
    if (provider.routeBounds != null) {
      _centerCamera(provider.routeBounds!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeepney Route Simulation'),
        actions: [
          DropdownButton<String>(
            value: selectedRouteFile,
            onChanged: (String? newValue) {
              if (newValue != null) {
                _handleRouteChange(newValue);
              }
            },
            items: ['04L', '01B', '17C', '17B', '03L', '04C', '04I', '04H', '24', '62B', '62C', '25' ]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Consumer<JeepneyProvider>(
        builder: (context, provider, child) {
          if (provider.routeBounds != null && _isInitialLoad) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _centerCamera(provider.routeBounds!);
              _isInitialLoad = false;
            });
          }

          return MapView(
            markers: provider.jeepneys.isNotEmpty
                ? provider.jeepneys.map((jeepney) {
                    return Marker(
                      markerId: MarkerId("jeepney_${jeepney['index']}"),
                      position: jeepney['position'],
                      icon: jeepneyIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                      rotation: jeepney['bearing'] ?? 0.0,
                      flat: true,
                      visible: true,
                      anchor: const Offset(0.5, 0.5),
                    );
                  }).toSet()
                : {},
            polylines: {
              if (provider.firstRoute.isNotEmpty) 
                Polyline(
                  polylineId: PolylineId("route_1"),
                  points: provider.firstRoute,
                  color: Colors.green,
                  width: 5,
                ),
              if (provider.secondRoute.isNotEmpty) 
                Polyline(
                  polylineId: PolylineId("route_2"),
                  points: provider.secondRoute,
                  color: Colors.blue,
                  width: 5,
                ),
            },
            onMapCreated: (controller) {
              _mapController = controller;
              if (provider.routeBounds != null) {
                _centerCamera(provider.routeBounds!);
                _isInitialLoad = false;
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              final provider = Provider.of<JeepneyProvider>(context, listen: false);
              if (provider.routeBounds != null) {
                _centerCamera(provider.routeBounds!);
              }
            },
            child: Icon(Icons.center_focus_strong),
            heroTag: 'center',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Provider.of<JeepneyProvider>(context, listen: false)
                  .loadRoute("$selectedRouteFile");
            },
            child: Icon(Icons.directions_bus),
            heroTag: 'reload',
          ),
        ],
      ),
    );
  }
}
