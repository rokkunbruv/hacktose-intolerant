import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

class StepItem extends StatelessWidget {
  final StepType type;
  final String? location;
  final String? jeepCode;
  final String? fare;
  final String? dropOff;
  final String? duration;
  final String? distance;

  const StepItem({
    super.key,
    required this.type,
    this.location,
    this.jeepCode,
    this.fare,
    this.dropOff,
    this.duration,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: _generateContainer());
  }

  Widget _generateContainer() {
    switch (type) {
      case StepType.walk:
        return _createWalkContainer();
      case StepType.transport:
        return _createTransportContainer();
      case StepType.end: //use type 'end' for drop off containers
        return _createDropOffContainer();
      default:
        return SizedBox();
    }
  }

  Widget _createWalkContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.directions_walk,
                  color: AppColors.gray, size: 20),
              Text('Walk to $location',
                  style: AppTextStyles.label3.copyWith(color: AppColors.black)),
            ],
          ),
          Text('$duration',
              style: AppTextStyles.label5.copyWith(color: AppColors.lightNavy)),
        ],
      ),
    );
  }

  Widget _createTransportContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/jeepney icon-small.png',
            width: 20,
            height: 20,
            color: AppColors.gray,
          ),
          const SizedBox(
            width: 5,
          ),
          Wrap(
            children: [
              Row(
                children: [
                  Text(
                    'Ride',
                    style:
                        AppTextStyles.label3.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(
                    width: 5.5,
                  ),
                  Text(
                    '$jeepCode',
                    style:
                        AppTextStyles.label3.copyWith(color: AppColors.saffron),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₱$fare',
                      style:
                          AppTextStyles.label4.copyWith(color: AppColors.red)),
                  Expanded(
                    child: Text(
                      'From $location',
                      style:
                          AppTextStyles.label5.copyWith(color: AppColors.black),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _createDropOffContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      // decoration: BoxDecoration(
      //   color: AppColors.bg,
      //   borderRadius: BorderRadius.circular(10),
      //   boxShadow: [
      //     createBoxShadow(),
      //   ],
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/icons/jeepney icon-small.png',
                width: 20,
                height: 20,
                color: AppColors.gray,
              ),
              const SizedBox(
                width: 10,
              ),
              Text('Get off in',
                  style: AppTextStyles.label3.copyWith(color: AppColors.black)),
              const SizedBox(
                width: 5,
              ),
              Text('$duration',
                  style: AppTextStyles.label3.copyWith(color: AppColors.red)),
            ],
          ),
          Expanded(child: Text('Get off at $dropOff')),
        ],
      ),
    );
  }
}
