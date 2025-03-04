import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tultul/classes/direction/direction_step.dart';
import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/constants/step_types.dart';
import 'package:tultul/constants/travel_modes.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/route/route_steps.dart';
import 'package:tultul/widgets/steps/step_item.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/pages/route/follow_route_page.dart';
import 'package:tultul/utils/time/format_time.dart';

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

  void navigateFollowRoutePage() {
    List<Widget> stepItems = [];

    for (int i = 0; i < widget.route.path.legs[0].steps.length; i++) {
      DirectionStep step = widget.route.path.legs[0].steps[i];
      StepType type =
          (step.travelMode == transit) ? StepType.transport : StepType.walk;

      // ADD STEP FOR WAITING JEEPNEYS
      if (type == StepType.transport) {
        stepItems.add(StepItem(
          type: StepType.start,
          location: step.origin?.address,
          jeepCode: step.jeepneyCode,
          fare: step.jeepneyFare?.toStringAsFixed(2),
          dropOff: step.destination?.address,
          distance: step.distance.toStringAsFixed(2),
        ));
      }
      
      stepItems.add(StepItem(
        type: type,
        location: step.origin?.address,
        jeepCode: step.jeepneyCode,
        fare: step.jeepneyFare?.toStringAsFixed(2),
        dropOff: step.destination?.address,
        duration: '${(step.duration / 60).round().toString()}m',
        distance: step.distance.toStringAsFixed(2),
        polyline: step.polyline
      ));


      // ADD STEP FOR DROP OFFS
      if (type == StepType.transport) {
        stepItems.add(StepItem(
          type: StepType.end,
          location: step.origin?.address,
          jeepCode: step.jeepneyCode,
          fare: step.jeepneyFare?.toStringAsFixed(2),
          dropOff: step.destination?.address,
          duration: '${(step.duration / 60).round().toString()}m',
          distance: step.distance.toStringAsFixed(2),
          polyline: step.polyline,
        ));
      }
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FollowRoutePage(
        route: widget.route,
        stepItems: stepItems
      )));
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteFinderProvider>(context);
    final positionProvider = Provider.of<PositionProvider>(context);

    final steps = widget.route.path.legs[0].steps;

    final totalDuration = Duration(seconds: widget.route.totalDuration);
    final totalDurationInHours = totalDuration.inHours.toString().padLeft(1, '0');
    final totalDurationInMinutes = totalDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final formattedTotalDuration = '${totalDurationInHours}h ${totalDurationInMinutes}m';

    final arrivalTime = formatTime(widget.route.arrivalTime);

    return Scaffold(
      body: Stack(children: <Widget>[
        // MAP VIEW
        MapView(
          markers: routeProvider.getMarkers().union(
            {positionProvider.currentPositionMarker!}
          ),
          polylines: {widget.route.path.polyline},
          snapToPolyline: true,
        ),

        DraggableContainer(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                children: <Widget>[     
                  // SUGGESTED ROUTES HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  SizedBox(height: 16),
        
                  RouteSteps(type: StepType.start),
                ] +
                steps.asMap().entries.map((entry) {
                  DirectionStep step = entry.value;
                  StepType type = (step.travelMode == transit)
                      ? StepType.transport
                      : StepType.walk;
                  StepType? type2 = (entry.key == steps.length - 1)
                      ? StepType.end
                      : null;
        
                  return RouteSteps(
                    type: type,
                    type2: type2,
                    location: step.origin?.address,
                    jeepCode: step.jeepneyCode,
                    fare: step.jeepneyFare?.toStringAsFixed(2),
                    dropOff: step.destination?.address,
                    duration: (step.duration / 60).round().toString(),
                    distance: step.distance.toStringAsFixed(0),
                  );
                }).toList()),
          ),
        ),
      ]),

      // DEETS+TARA NA BUTTON
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg,
            boxShadow: [createBoxShadow()],
          ),
          padding: EdgeInsets.only(top: 15, bottom: 30, left: 10),
          child: BottomAppBar(
            color: AppColors.bg,
            notchMargin: 20,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Wrap(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Travel Time:',
                            style: AppTextStyles.label5
                                .copyWith(color: AppColors.black)),
                        Text(formattedTotalDuration,
                            style: AppTextStyles.label2.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold)),
                        Text('Arrive at $arrivalTime',
                            style: AppTextStyles.label5
                                .copyWith(color: AppColors.gray))
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Fare:',
                        style: AppTextStyles.label5
                            .copyWith(color: AppColors.black)),
                    Text('₱${widget.route.totalFare.toStringAsFixed(2)}',
                        style: AppTextStyles.label2.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(width: 10),
                Wrap(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 80,
                      child: TextButton(
                        onPressed: navigateFollowRoutePage,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text('Tara!',
                                  style: AppTextStyles.label3.copyWith(
                                    color: AppColors.bg,
                                  )),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
