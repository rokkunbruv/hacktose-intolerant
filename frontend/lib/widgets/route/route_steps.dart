import 'package:flutter/material.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/constants/step_types.dart';

class RouteSteps extends StatelessWidget {
  final StepType type;
  final StepType? type2;
  final String? location;
  final String? jeepCode;
  final String? fare;
  final String? dropOff;
  final String? duration;
  final String? distance;
  final IconData? icon;

  const RouteSteps({
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
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                type == StepType.start
                    ? Expanded(child: Container())
                    : Expanded(
                        child: VerticalDivider(
                          color: AppColors.lightNavy,
                          thickness: 2,
                          width: 2,
                        ),
                      ),
                if (type2 == StepType.end)
                  SizedBox(
                    height: 70,
                    child: VerticalDivider(
                      color: AppColors.lightNavy,
                      thickness: 2,
                      width: 2,
                    ),
                  ),
                if (type2 != StepType.end)
                  const Icon(Icons.circle, color: AppColors.lightNavy, size: 20)
                else
                  const Icon(Icons.circle, color: AppColors.red, size: 20),
                if (type2 != StepType.end)
                  Expanded(
                    child: VerticalDivider(
                      color: AppColors.lightNavy,
                      thickness: 2,
                      width: 2,
                    ),
                  )
                else
                  Expanded(child: Container()),
              ],
            ),
          ),
          Expanded(
            child: _createStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _createStepContent() {
    switch (type) {
      case StepType.start:
        return _baseContainer();
      case StepType.walk:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Row(
            children: [
              const Icon(Icons.directions_walk, color: AppColors.red, size: 25),
              Text('Walk $duration min (${distance}m)',
                  style: AppTextStyles.label5
                      .copyWith(color: AppColors.lightNavy)),
            ],
          ),
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
      margin: const EdgeInsets.symmetric(vertical: 5),
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
          Row(
            children: [
              Image.asset(
                'assets/icons/jeepney icon-small.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 7.0),
              Expanded(
                child: Text(
                  'From $location',
                  style: AppTextStyles.label5.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.saffron,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(3),
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(3),
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
              boxShadow: [
                createBoxShadow(),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Get off at $dropOff',
                      style: AppTextStyles.label5.copyWith(
                          color: AppColors.bg, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}