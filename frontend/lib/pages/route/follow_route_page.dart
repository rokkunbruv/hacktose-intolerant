import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tultul/constants/travel_modes.dart';
import 'package:tultul/pages/route/finished_route_page.dart';

import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';

import 'package:tultul/widgets/steps/step_item.dart';
import 'package:tultul/constants/follow_types.dart';
import 'package:tultul/provider/step_provider.dart';

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
      currentIndex = (currentIndex + 1) % widget.stepItems.length;
      next = (currentIndex + 1) % widget.stepItems.length;
      print(currentIndex);
      print(next);
    });
  }

  void navigateExitPage() {
    Navigator.of(context).pop();
  }

  void navigateToFinishedRoutePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FinishedRoutePage()));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   final stepProvider = Provider.of<StepProvider>(context, listen: false);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (stepProvider.stepContainers.isEmpty) {
  //       addNewStep(context);
  //     }
  //   });
  // }

  // void addNewStep(BuildContext context) {
  //   print("addNewStep() called");
  //   final stepProvider = Provider.of<StepProvider>(context, listen: false);

  //   stepProvider.addStepContainer(StepItem(
  //     type1: FollowType.walk,
  //     location: 'insular',
  //     duration: '3 mins',
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableContainer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: widget.stepItems[currentIndex],
            ),
            if (next != 0)
              Container(
                padding: EdgeInsets.all(20),
                child: widget.stepItems[next],
              ),
            ElevatedButton(
              onPressed: (currentIndex == widget.stepItems.length - 1)
                  ? navigateToFinishedRoutePage
                  : swapContent,
              child: Text("Next"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bg,
          boxShadow: [createBoxShadow()],
        ),
        padding: EdgeInsets.only(top: 15, bottom: 50, right: 6),
        child: BottomAppBar(
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
                      Text('Arrive at 8:00 PM',
                          style: AppTextStyles.label5
                              .copyWith(color: AppColors.gray)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
