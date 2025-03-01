import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/classes/direction/direction_step.dart';
import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/classes/route/jeepney_ride.dart';
import 'package:tultul/constants/step_types.dart';
import 'package:tultul/constants/travel_modes.dart';
import 'package:tultul/main.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/utils/route/decode_polyline.dart';
import 'package:tultul/pages/route/follow_route_page.dart';
import 'package:tultul/widgets/route/route_steps.dart';

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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FollowRoutePage()));
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

        Expanded(
          child: DraggableContainer(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                  children: <Widget>[
                        StepDetails(type: StepType.start),
                      ] +
                      steps.asMap().entries.map((entry) {
                        DirectionStep step = entry.value;
                        StepType type = (step.travelMode == transit)
                            ? StepType.transport
                            : StepType.walk;
                        StepType? type2 = (entry.key == steps.length - 1)
                            ? StepType.end
                            : null;

                        return StepDetails(
                          type: type,
                          type2: type2,
                          location: step.origin,
                          jeepCode: step.jeepneyCode,
                          fare: step.jeepneyFare.toStringAsFixed(2),
                          dropOff: step.destination,
                          distance: step.distance.toStringAsFixed(2),
                        );
                      }).toList()),
            ),
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
                        Text('1 h 14 mins',
                            style: AppTextStyles.label2.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold)),
                        Text('Arrive at 8:00 PM',
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
                    Text('₱30.00',
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
