import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tultul/provider/jeepney_provider.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jeepney Route Simulation')),
      body: Consumer<JeepneyProvider>(
        builder: (context, provider, child) {
          Set<Polyline> polylines = {};

          if (provider.routes.isNotEmpty) {
            for (int i = 0; i < provider.routes.length; i++) {
              polylines.add(
                Polyline(
                  polylineId: PolylineId("route_$i"),
                  points: provider.routes[i].coordinates
                      .map((c) => LatLng(c[0], c[1]))
                      .toList(),
                  color: i == 0 ? Colors.green : Colors.blue, // Green for first, Blue for second
                  width: 5,
                ),
              );
            }
          }

          return MapView(
            markers: provider.currentPosition != null
                ? {
                    Marker(
                      markerId: MarkerId("jeepney"),
                      position: provider.currentPosition!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                    ),
                  }
                : {},
            polylines: polylines,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<JeepneyProvider>(context, listen: false).startSimulation();
        },
        child: Icon(Icons.directions_bus),
      ),
    );
  }
}
