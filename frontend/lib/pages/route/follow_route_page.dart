import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/constants/step_types.dart';
import 'package:tultul/pages/route/finished_route_page.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/provider/jeepney_provider.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/utils/time/format_time.dart';
import 'package:tultul/widgets/steps/step_item.dart';
import 'package:tultul/widgets/steps/active_step_item.dart';
import 'package:tultul/widgets/map/map_view.dart';

class FollowRoutePage extends StatefulWidget {
  final CommuteRoute route;
  final List<Widget> stepItems;
  
  const FollowRoutePage({
    super.key, 
    required this.route,
    required this.stepItems
  });

  @override
  State<FollowRoutePage> createState() => _FollowRoutePageState();
}

class _FollowRoutePageState extends State<FollowRoutePage> {
  int currentIndex = 0;
  int next = 1;

  Polyline? polyline;

  void nextStep() {
    setState(() {
      if (currentIndex < widget.stepItems.length - 1) {
        currentIndex++;
        next = (currentIndex + 1 < widget.stepItems.length) ? currentIndex + 1 : currentIndex;
      }
    });

    setPolyline();
  }

  void previousStep() {
    setState(() {
      if (currentIndex > 0) { // Prevent going below 0
        currentIndex--;
        next = (currentIndex - 1 >= 1) ? currentIndex - 1 : 1; // Prevent 0
      }
    });

    setPolyline();
  }


  void navigateExitPage() {
    Navigator.of(context).pop();
  }

  void navigateToFinishedRoutePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FinishedRoutePage()),
    );
  }

  StepItem? getCurrentStepItem() {
    if (widget.stepItems.isNotEmpty && currentIndex >= 0 && currentIndex < widget.stepItems.length) {
      return widget.stepItems[currentIndex] as StepItem;
    }
    return null;
  }

  void setPolyline() {
    final jeepneyProvider = Provider.of<JeepneyProvider>(context, listen: false);
    final currentStepItem = getCurrentStepItem();

    if (currentStepItem?.type == StepType.start) {
      jeepneyProvider.loadRoute(currentStepItem?.jeepCode ?? '');
    }

    setState(() => polyline = currentStepItem?.polyline);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jeepneyProvider = Provider.of<JeepneyProvider>(context, listen: false);
      jeepneyProvider.initializeJeepneyMarker();

      if (getCurrentStepItem()?.type == StepType.start && !jeepneyProvider.isRouteLoaded) {
        jeepneyProvider.loadRoute(getCurrentStepItem()?.jeepCode ?? '');
      }

      setPolyline();
    });
  }

  @override
  Widget build(BuildContext context) {
    final PositionProvider positionProvider = Provider.of<PositionProvider>(context);
    final JeepneyProvider jeepneyProvider = Provider.of<JeepneyProvider>(context);
    
    if (widget.stepItems.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No steps available'),
        ),
      );
    }

    double progress = (currentIndex + 1) / widget.stepItems.length;

    final totalDuration = Duration(seconds: widget.route.totalDuration);
    final totalDurationInHours = totalDuration.inHours.toString().padLeft(2, '0');
    final totalDurationInMinutes = totalDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final formattedTotalDuration = '${totalDurationInHours}h ${totalDurationInMinutes}m';

    final arrivalTime = formatTime(widget.route.arrivalTime);

    final currentStepItem = getCurrentStepItem();

    Set<Marker> markers = {positionProvider.currentPositionMarker!};

    // display jeepney locations when current step is to wait for a jeepney
    if (currentStepItem?.type == StepType.start) {
      markers = markers.union(jeepneyProvider.jeepneyMarkers);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // MAP VIEW
          MapView(
            markers: markers,
            polylines: (polyline != null)
                ? {polyline!}
                : null,
          ),

          // STEP WIDGETS ABOVE THE BOTTOM NAVIGATION BAR
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                        ),
                        onPressed: (currentIndex > 0) ? previousStep : navigateExitPage,
                        child: Text(
                          "Back",
                          style: AppTextStyles.label5,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                        ),
                        onPressed: (currentIndex == widget.stepItems.length - 1)
                            ? navigateToFinishedRoutePage
                            : nextStep,
                        child: Text(
                          "Next",
                          style: AppTextStyles.label5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // CURRENT STEP
                Container(
                  height: 90,
                  width: 385,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: (currentStepItem != null && currentStepItem.type == StepType.walk)
                        ? AppColors.skyBlue
                        : AppColors.lightVanilla,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [createBoxShadow()],
                  ),
                  child: currentStepItem != null
                      ? ActiveStepItem(
                          type: currentStepItem.type,
                          location: currentStepItem.location,
                          jeepCode: currentStepItem.jeepCode,
                          fare: currentStepItem.fare,
                          dropOff: currentStepItem.dropOff,
                          duration: currentStepItem.duration,
                          distance: currentStepItem.distance,
                        )
                      : SizedBox(),
                ),
                SizedBox(height: 10),

                // NEXT STEP
                if (next > 0 && next < widget.stepItems.length)
                  Container(
                    height: 80,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      boxShadow: [createBoxShadow()],
                    ),
                    child: widget.stepItems[next],
                  ),
              ],
            ),
          ),
        ],
      ),

      // BOTTOM NAVIGATION BAR
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
                                child: Text(
                                  'Exit',
                                  style: AppTextStyles.label3.copyWith(
                                    color: AppColors.bg,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Travel Time:',
                              style: AppTextStyles.label5.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              formattedTotalDuration,
                              style: AppTextStyles.label2.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Arrive at $arrivalTime',
                              style: AppTextStyles.label5.copyWith(
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Fare:',
                              style: AppTextStyles.label5.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              '₱${widget.route.totalFare.toStringAsFixed(2)}',
                              style: AppTextStyles.label2.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.skyBlue,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.saffron,
                  ),
                  minHeight: 8,
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