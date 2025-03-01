import 'package:flutter/material.dart';

import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class JeepneyCodeLabel extends StatefulWidget {
  final String code;
  
  const JeepneyCodeLabel({
    super.key,
    required this.code,
  });

  @override
  State<JeepneyCodeLabel> createState() => _JeepneyCodeLabelState();
}

class _JeepneyCodeLabelState extends State<JeepneyCodeLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.black,
          width: 1,
        )
      ),
      child: Text(
        widget.code,
        style: AppTextStyles.label5,
      )
    );
  }
}