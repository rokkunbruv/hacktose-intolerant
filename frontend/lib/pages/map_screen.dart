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
                      .loadRoute("$newValue.json");
                });
              }
            },
            items: ['04L', '01B', '17C'].map<DropdownMenuItem<String>>((String value) {
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
