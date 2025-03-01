import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/classes/direction/direction_step.dart';
import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/classes/route/jeepney_ride.dart';
import 'package:tultul/constants/step_types.dart';
import 'package:tultul/constants/travel_modes.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/route/route_steps.dart';
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

    final steps = widget.route.path.legs[0].steps;

    return Scaffold(
      body: Stack(children: <Widget>[
        // MAP VIEW
        MapView(
          markers: routeProvider.getMarkers(),
          polylines: {widget.route.path.polyline},
        ),

        DraggableContainer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 4, 40, 16),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(height: 4, width: 64),
              ),
              SizedBox(height: 32),
              
              // ROUTE DETAILS HEADER
              Row(
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
              SizedBox(height: 16),

              // ROUTE STEPS
              Column(
                children: <Widget>[
                  RouteSteps(type: StepType.start),
                ] + steps.asMap().entries.map((entry) {
                  DirectionStep step = entry.value;
                  StepType type = (step.travelMode == transit) ? StepType.transport : StepType.walk;
                  StepType? type2 = (entry.key == steps.length - 1) ? StepType.end : null;
              
                  return RouteSteps(
                    type: type,
                    type2: type2,
                    location: step.origin,
                    jeepCode: step.jeepneyCode,
                    fare: step.jeepneyFare?.toStringAsFixed(2),
                    dropOff: step.destination,
                    duration: (step.duration / 60).round().toString(),
                    distance: step.distance.toStringAsFixed(0),
                  );
                }).toList()
              ),
            ],
          ),
        ),
      ),
      ]),
    );
  }
}
