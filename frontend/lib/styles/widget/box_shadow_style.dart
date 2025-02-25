import 'package:flutter/material.dart';

import 'package:tultul/theme/colors.dart';

BoxShadow createBoxShadow({
  Color color = AppColors.gray,
  double blurRadius = 4,
  Offset offset = const Offset(0, 2),
}) {
  return BoxShadow(
    color: color,
    blurRadius: blurRadius,
    offset: offset,
  );
}