import 'package:flutter/material.dart';

import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';

class LocationItem extends StatefulWidget {
  const LocationItem({super.key});

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      decoration: BoxDecoration(
        boxShadow: [
          createBoxShadow(),
        ],
      )
    );
  }
}