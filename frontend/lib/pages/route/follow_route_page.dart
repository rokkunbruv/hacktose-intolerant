import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tultul/constants/step_types.dart';
import 'package:tultul/constants/travel_modes.dart';
import 'package:tultul/pages/route/finished_route_page.dart';

import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';

import 'package:tultul/widgets/steps/step_item.dart';
import 'package:tultul/widgets/steps/active_step_item.dart';

class FollowRoutePage extends StatefulWidget {
  final List<Widget> stepItems;
  const FollowRoutePage({super.key, required this.stepItems});

  @override
  State<FollowRoutePage> createState() => _FollowRoutePageState();
}

class _FollowRoutePageState extends State<FollowRoutePage> {
  // final List<Widget> containerList = ;

  int currentIndex = 0;
  int next = 1;

  void swapContent() {
    setState(() {
      // Move to the next index or loop back to 0
      if (currentIndex < widget.stepItems.length - 1) {
        currentIndex++;
        next = (currentIndex + 1) % widget.stepItems.length;
        print(currentIndex);
        print(next);
      }
    });
  }

  void navigateExitPage() {
    Navigator.of(context).pop();
  }

  void navigateToFinishedRoutePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FinishedRoutePage()));
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / widget.stepItems.length;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: (currentIndex == widget.stepItems.length - 1)
                  ? navigateToFinishedRoutePage
                  : swapContent,
              child: Text("Next"),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250,
              width: double.infinity,
              color: AppColors.bg,
              child: Expanded(
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 385,
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: (widget.stepItems.isNotEmpty &&
                                        (widget.stepItems[currentIndex]
                                                    as StepItem)
                                                .type ==
                                            StepType.walk)
                                    ? AppColors.skyBlue
                                    : AppColors.lightVanilla,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  createBoxShadow(),
                                ],
                              ),
                              child: ActiveStepItem(
                                type:
                                    (widget.stepItems[currentIndex] as StepItem)
                                        .type,
                                location:
                                    (widget.stepItems[currentIndex] as StepItem)
                                        .location,
                                jeepCode:
                                    (widget.stepItems[currentIndex] as StepItem)
                                        .jeepCode,
                                fare:
                                    (widget.stepItems[currentIndex] as StepItem)
                                        .fare,
                                dropOff:
                                    (widget.stepItems[currentIndex] as StepItem)
                                        .dropOff,
                                duration:
                                    (widget.stepItems[currentIndex] as StepItem)
                                        .duration,
                                distance:
                                    (widget.stepItems[currentIndex] as StepItem)
                                        .distance,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (next != 0 && next < widget.stepItems.length)
                      SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            boxShadow: [
                              createBoxShadow(),
                            ],
                          ),
                          child: widget.stepItems[next],
                        ),
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bg,
          boxShadow: [createBoxShadow()],
        ),
        padding: EdgeInsets.only(top: 15, bottom: 20, right: 6),
        child: SizedBox(
          height: 120,
          child: Column(
            children: [
              BottomAppBar(
                color: AppColors.bg,
                notchMargin: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Wrap(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 80,
                          child: TextButton(
                            onPressed: navigateExitPage,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text('Exit',
                                      style: AppTextStyles.label3.copyWith(
                                        color: AppColors.bg,
                                      )),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
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
                                    .copyWith(color: AppColors.gray)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Wrap(
                      children: [
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
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: LinearProgressIndicator(
                  value: progress, // Updates based on step progress
                  backgroundColor: AppColors.skyBlue, // Background color
                  valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.saffron), // Progress color
                  minHeight: 8, // Thickness
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
