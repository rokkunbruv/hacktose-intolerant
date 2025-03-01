import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/classes/route/jeepney_ride.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/utils/route/decode_polyline.dart';

class RouteDetailsPage extends StatefulWidget {
  final CommuteRoute route;
  
  const RouteDetailsPage({
    super.key,
    required this.route,
  });

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  void navigateBack() {
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteFinderProvider>(context);
    Set<Polyline> polylines = decodePolyline(widget.route.path.overviewPolyline);
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // MAP VIEW
          MapView(
            markers: routeProvider.getMarkers(),
            polylines: polylines,
          ),

          // ROUTE DETAILS PANEL
          DraggableContainer(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: <Widget>[
                  // SUGGESTED ROUTES HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Route Details',
                          style: AppTextStyles.label2.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: AppColors.lightGray,
                          ),
                          onPressed: navigateBack,
                        ),
                      ],
                    ),
                  ),
                  
                  Column(
                    children: widget.route.rides.asMap().entries.map((entry) {
                      JeepneyRide ride = entry.value;

                      return Column(
                        children: <Widget>[
                          Text(
                            '${ride.route} - ${ride.type} - Php${ride.fare}',
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
                  )
                ]
              )
            )
          )
        ]
      ),
    );
  }
}