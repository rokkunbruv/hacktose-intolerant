import 'package:flutter/material.dart';

import 'package:hacktose_intolerant_app/pages/route/route_details_page.dart';
import 'package:hacktose_intolerant_app/classes/route/commute_route.dart';
import 'package:hacktose_intolerant_app/theme/colors.dart';
import 'package:hacktose_intolerant_app/theme/text_styles.dart';

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
          BoxShadow(
            color: AppColors.black.withAlpha(64),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
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