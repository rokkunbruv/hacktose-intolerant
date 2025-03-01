import 'package:flutter/material.dart';
// import 'package:tultul/main.dart';

import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

import 'package:tultul/constants/step_types.dart';

// Custom widget for each step with connecting lines
class StepDetails extends StatelessWidget {
  final StepType type;
  final StepType? type2;
  final String? location;
  final String? jeepCode;
  final String? fare;
  final String? dropOff;
  final String? duration;
  final String? distance;
  final IconData? icon;

  const StepDetails({
    super.key,
    required this.type,
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
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (type2 == StepType.end)
              Container(width: 2, height: 50, color: AppColors.lightNavy),
            if (type2 == StepType.end)
              const Icon(Icons.location_pin, color: AppColors.red, size: 20),
            if (type != StepType.end && type2 != StepType.end)
              const Icon(Icons.circle, color: AppColors.lightNavy, size: 20),
            if (type != StepType.end && type2 != StepType.end)
              Container(width: 2, height: 50, color: AppColors.lightNavy),
          ],
        ),
        const SizedBox(width: 10),

        // STEP CONTENT
        Expanded(
          child: _createStepContent(),
        ),
      ],
    );
  }

  Widget _createStepContent() {
    switch (type) {
      case StepType.start:
        return _baseContainer();
      case StepType.walk:
        return Row(
          children: [
            const Icon(Icons.directions_walk, color: AppColors.red, size: 25),
            Text('Walk $duration ($distance)',
                style:
                    AppTextStyles.label5.copyWith(color: AppColors.lightNavy)),
          ],
        );
      case StepType.transport:
        return _createTransportContainer();
      case StepType.end:
        return Container();
    }
  }

  Widget _baseContainer() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [createBoxShadow()],
      ),
      child: Text("Your Location",
          style: AppTextStyles.label5
              .copyWith(color: AppColors.black, fontWeight: FontWeight.bold)),
    );
  }

  Widget _createTransportContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          createBoxShadow(),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LOCATION OF THE BUS/JEEPNEY STOP
          Row(
            children: [
              // const Icon(Icons.directions_bus, color: AppColors.red, size: 25),
              Image.asset(
                'assets/icons/jeepney icon-small.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 7.0),

              Text('From $location',
                  style: AppTextStyles.label5.copyWith(
                      color: AppColors.black, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15.0),

          // JEEPNEY TO RIDE + FARE DETAILS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.saffron,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                createBoxShadow(),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Take $jeepCode Jeepney',
                    style: AppTextStyles.label5.copyWith(
                        color: AppColors.black, fontWeight: FontWeight.bold)),
                Text('₱${fare!}',
                    style: AppTextStyles.label5.copyWith(
                        color: AppColors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8.0),

          // DROP OFF DETAILS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                createBoxShadow(),
              ],
            ),
            child: Text('Get off at $dropOff',
                style: AppTextStyles.label5.copyWith(
                    color: AppColors.bg, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
