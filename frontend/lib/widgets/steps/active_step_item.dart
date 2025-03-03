import 'package:flutter/material.dart';
import 'package:tultul/constants/step_types.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class ActiveStepItem extends StatelessWidget {
  final StepType type;
  final String? location;
  final String? jeepCode;
  final String? fare;
  final String? dropOff;
  final String? duration;
  final String? distance;

  const ActiveStepItem({
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
    return _generateContainer(); // Removed Expanded to prevent ParentDataWidget error
  }

  Widget _generateContainer() {
    switch (type) {
      case StepType.walk:
        return _createWalkContainer();
      case StepType.transport:
        return _createTransportContainer();
      case StepType.end:
        return _createDropOffContainer();
      case StepType.start: //use type 'start' for wait for jeep containers
        return _createWaitingContainer();
    }
  }

  Widget _createWalkContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.directions_walk, color: AppColors.red, size: 20),
                const SizedBox(width: 5),
                Expanded( // Ensures the text doesn't overflow
                  child: Text(
                    'Walking to $dropOff',
                    style: AppTextStyles.label3.copyWith(color: AppColors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$duration',
            style: AppTextStyles.label5.copyWith(color: AppColors.lightNavy),
          ),
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
            color: AppColors.red,
          ),
          const SizedBox(width: 5),
          Wrap(
            children: [
              Row(
                children: [
                  Text(
                    'Riding',
                    style: AppTextStyles.label3.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(width: 5.5),
                  Text(
                    '$jeepCode',
                    style: AppTextStyles.label3.copyWith(color: AppColors.saffron),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₱$fare',
                    style: AppTextStyles.label4.copyWith(color: AppColors.red),
                  ),
                  Flexible( // Ensures text does not overflow
                    child: Text(
                      'From $location',
                      style: AppTextStyles.label5.copyWith(color: AppColors.black),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/icons/jeepney icon-small.png',
                width: 20,
                height: 20,
                color: AppColors.red,
              ),
              const SizedBox(width: 10),
              Expanded( // Prevents text overflow
                child: Text(
                  'Getting off at $dropOff',
                  style: AppTextStyles.label4.copyWith(color: AppColors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createWaitingContainer() {
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
                    'Waiting for',
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
}
