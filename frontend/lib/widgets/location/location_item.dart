import 'package:flutter/material.dart';
import 'package:tultul/pages/route/search_routes_page.dart';

import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/classes/location/location.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class LocationItem extends StatefulWidget {
  final Location location;
  final VoidCallback onPressed;
  
  const LocationItem({
    super.key,
    required this.location,
    required this.onPressed,
  });

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  void navigateBack() {
    widget.onPressed();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: 
      (context) => SearchRoutesPage()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
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
          alignment: Alignment.centerLeft,
        ),
        onPressed: navigateBack,
        child: Text(
          widget.location.address,
          style: AppTextStyles.label5,
        )
      ),
    );
  }
}