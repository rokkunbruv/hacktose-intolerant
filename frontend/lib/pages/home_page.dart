import 'package:flutter/material.dart';

import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void navigateToSearchDestinationPage() {}

  void navigateToRecentTripsPage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/img/title.png',
            ),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
            color: AppColors.bg,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(64),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          )),
        ),
        body: Stack(children: <Widget>[
          // MAP VIEW
          MapView(),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.red,
                ),
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Transform.translate(
                  offset: Offset(0, -40),
                  child: Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Column(children: <Widget>[
                            // WHERE TO
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.red,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Where to?',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    readOnly: true,
                                    onTap: navigateToSearchDestinationPage,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(height: 8),

                            // HOME, WORK, MORE
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: <Widget>[
                            //     // HOME BUTTON
                            //     TextButton(
                            //       onPressed: () {},
                            //       child: Row(
                            //         children: <Widget>[
                            //           CircleAvatar(
                            //             backgroundColor: AppColors.navy,
                            //             radius: 10,
                            //             child: Icon(
                            //               Icons.home,
                            //               color: AppColors.white,
                            //               size: 10,
                            //             ),
                            //           ),
                            //           SizedBox(width: 8),
                            //           Column(
                            //               mainAxisAlignment: MainAxisAlignment.center,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: <Widget>[
                            //                 Text(
                            //                   'Home',
                            //                   style: AppTextStyles.label5
                            //                 ),
                            //                 Text(
                            //                   'Cebu',
                            //                   style: AppTextStyles.label6.copyWith(
                            //                     color: AppColors.gray
                            //                   )
                            //                 ),
                            //               ]
                            //             )
                            //         ]
                            //       )
                            //     ),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //         color: AppColors.lightGray
                            //       ),
                            //       child: SizedBox(height: 32, width: 2)
                            //     ),

                            //     // WORK BUTTON
                            //     TextButton(
                            //       onPressed: () {},
                            //       child: Row(
                            //         children: <Widget>[
                            //           CircleAvatar(
                            //             backgroundColor: AppColors.navy,
                            //             radius: 10,
                            //             child: Icon(
                            //               Icons.work,
                            //               color: AppColors.white,
                            //               size: 10,
                            //             ),
                            //           ),
                            //           SizedBox(width: 8),
                            //           Column(
                            //               mainAxisAlignment: MainAxisAlignment.center,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: <Widget>[
                            //                 Text(
                            //                   'Work',
                            //                   style: AppTextStyles.label5
                            //                 ),
                            //                 Text(
                            //                   'Set Location',
                            //                   style: AppTextStyles.label6.copyWith(
                            //                     color: AppColors.gray
                            //                   )
                            //                 ),
                            //               ]
                            //             )
                            //         ]
                            //       )
                            //     ),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //         color: AppColors.lightGray
                            //       ),
                            //       child: SizedBox(height: 32, width: 2)
                            //     ),

                            //     // MORE BUTTON
                            //     TextButton(
                            //       onPressed: () {},
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: <Widget>[
                            //           Container(
                            //             decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.circular(10),
                            //               boxShadow: [
                            //                 BoxShadow(
                            //                   color: AppColors.black.withAlpha(64),
                            //                   blurRadius: 2,
                            //                   offset: Offset(0, 2),
                            //                 ),
                            //               ],
                            //             ),
                            //             child: CircleAvatar(
                            //               backgroundColor: AppColors.white,
                            //               radius: 10,
                            //               child: Icon(
                            //                 Icons.more_horiz,
                            //                 color: AppColors.black,
                            //                 size: 10,
                            //               ),
                            //             ),
                            //           ),
                            //           SizedBox(width: 8),
                            //           Text(
                            //             'More',
                            //             style: AppTextStyles.label5
                            //           )
                            //         ]
                            //       )
                            //     ),
                            //   ]
                            // )
                          ])),
                      // SizedBox(height: 16),

                      // // RECENT TRIPS
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Text(
                      //       'Recent trips',
                      //       style: AppTextStyles.label4.copyWith(
                      //         color: AppColors.vanilla,
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       onTap: navigateToRecentTripsPage,
                      //       child: Text(
                      //         'More',
                      //         style: AppTextStyles.label4.copyWith(
                      //           color: AppColors.saffron,
                      //         ),
                      //       ),
                      //     ),
                      //   ]
                      // )
                    ],
                  ),
                )),
          )
        ]));
  }
}
