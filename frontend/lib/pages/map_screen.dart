import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tultul/provider/jeepney_provider.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedRouteFile = "04L"; // Default to 04L.json
  GoogleMapController? _mapController;

  void _centerCamera(LatLngBounds bounds) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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
                setState(() {
                  selectedRouteFile = newValue;
                  Provider.of<JeepneyProvider>(context, listen: false)
                      .loadRoute("$newValue");
                });
              }
            },
            items: ['04L', '01B', '17C', '17B', '03L', '04C', '04I', '04H', '24', '62B', '62C', '25' ].map<DropdownMenuItem<String>>((String value) {
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
          if (provider.routeBounds != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _centerCamera(provider.routeBounds!);
            });
          }

          return MapView(
            markers: provider.jeepneys.isNotEmpty
                ? provider.jeepneys.map((jeepney) {
                    return Marker(
                      markerId: MarkerId("jeepney_${jeepney['index']}"),
                      position: jeepney['position'],
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<JeepneyProvider>(context, listen: false)
              .loadRoute("$selectedRouteFile");
        },
        child: Icon(Icons.directions_bus),
      ),
    );
  }
}
