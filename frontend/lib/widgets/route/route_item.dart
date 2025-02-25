import 'package:flutter/material.dart';

import 'package:tultul/pages/route/route_details_page.dart';
import 'package:tultul/classes/route/commute_route.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

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
                  '${widget.route.totalDistance.toStringAsFixed(2)}km',
                  style: AppTextStyles.label1,
                ),
                Text(
                  '₱${widget.route.totalFare.toStringAsFixed(2)}',
                  style: AppTextStyles.label2,
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}