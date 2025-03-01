import 'package:flutter/material.dart';

import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';

class FollowRoutePage extends StatefulWidget {
  const FollowRoutePage({super.key});

  @override
  State<FollowRoutePage> createState() => _FollowRoutePageState();
}

class _FollowRoutePageState extends State<FollowRoutePage> {
  final List<Widget> containerList = ;

  // int currentIndex = 0;
  // int next = 1;

  // void swapContent() {
  //   setState(() {
  //     // Move to the next index or loop back to 0
  //     currentIndex = (currentIndex + 1) % detailsList.length;
  //     next = (currentIndex + 1) % detailsList.length;
  //     print(currentIndex);
  //     print(next);
  //   });
  // }

  void navigateExitPage() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Stack(
      //   children: [
      //     DraggableContainer(
      //       child: Column(
      //         children: [
      //           Column(
      //             children: [
      //               Text(
      //                 detailsList[currentIndex]["title"]!,
      //                 style:
      //                     TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      //               ),
      //               SizedBox(height: 10),
      //               Text(
      //                 detailsList[currentIndex]["description"]!,
      //                 textAlign: TextAlign.center,
      //               ),
      //             ],
      //           ),
      //           if (next != 0)
      //             Column(
      //               children: [
      //                 Text(
      //                   detailsList[next]["title"]!,
      //                   style: TextStyle(
      //                       fontSize: 22, fontWeight: FontWeight.bold),
      //                 ),
      //                 SizedBox(height: 10),
      //                 Text(
      //                   detailsList[next]["description"]!,
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ],
      //             ),
      //           SizedBox(height: 20),
      //           ElevatedButton(
      //             onPressed: swapContent,
      //             child: Text("Next"),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Container(
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
      ),
    );
  }
}
