import 'package:flutter/material.dart';

import 'package:tultul/pages/route/route_details_page.dart';
import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/utils/time/format_time.dart';
import 'package:tultul/widgets/jeepney/jeepney_code_label.dart';

class RouteItem extends StatefulWidget {
  final CommuteRoute route;
  
  const RouteItem({
    super.key,
    required this.route,
  });

  @override
  State<RouteItem> createState() => _RouteItemState();
}

class _RouteItemState extends State<RouteItem> {
  void navigateToRouteDetailsPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: 
    (context) => RouteDetailsPage(route: widget.route)
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    final departureTime = formatTime(widget.route.departureTime);
    final arrivalTime = formatTime(widget.route.arrivalTime);

    final totalDuration = Duration(seconds: widget.route.totalDuration);
    final totalDurationInHours = totalDuration.inHours.toString().padLeft(1, '0');
    final totalDurationInMinutes = totalDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final formattedTotalDuration = '${totalDurationInHours}h ${totalDurationInMinutes}m';

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          createBoxShadow(),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        onPressed: navigateToRouteDetailsPage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  formattedTotalDuration,
                  style: AppTextStyles.label1,
                ),
                Text(
                  '₱${widget.route.totalFare.toStringAsFixed(2)}',
                  style: AppTextStyles.label2,
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$departureTime - $arrivalTime',
                  style: AppTextStyles.label5.copyWith(
                    color: AppColors.gray
                  ),
                ),
                Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/jeepney icon-small.png'),
                      width: 16,
                      height: 16,
                    ),
                  ] + widget.route.rides.asMap().entries.map((entry) {
                    String code = entry.value;

                    return Row(
                      children: <Widget>[
                        SizedBox(width: 4),
                        JeepneyCodeLabel(
                          code: code,
                        ),
                      ],
                    );
                  }).toList(),
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}