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
import 'package:tultul/constants/step_types.dart';

class StepItem extends StatefulWidget {
  final StepType type1;
  final StepType? type2;
  final String? location;
  final String? jeepCode;
  final String? fare;
  final String? dropOff;
  final String? duration;
  final String? distance;
  final IconData? icon;

  const StepItem({
    super.key,
    required this.type1,
    this.type2,
    this.location,
    this.jeepCode,
    this.fare,
    this.dropOff,
    this.duration,
    this.distance,
    this.icon,
  });

  @override
  State<StepItem> createState() => _StepItemState();
}

class _StepItemState extends State<StepItem> {
  List<Widget> stepContainers = [];

  @override
  void initState() {
    super.initState();
    createStepContainer();
  }

  void createStepContainer() {
    stepContainers = [generateContainer()];
  }

  Widget generateContainer() {
    switch (widget.type1) {
      case StepType.walk:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Row(
            children: [
              const Icon(Icons.directions_walk, color: AppColors.red, size: 25),
              Text('Walk to $widget.location',
                  style: AppTextStyles.label3.copyWith(color: AppColors.black)),
              Text('$widget.duration',
                  style: AppTextStyles.label5
                      .copyWith(color: AppColors.lightNavy)),
            ],
          ),
        );
      case StepType.transport:
        return _createTransportContainer();
    }
  }

  Widget _createTransportContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          createBoxShadow(),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/jeepney icon-small.png',
            width: 20,
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Ride',
                style: AppTextStyles.label,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
