import 'package:flutter/material.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

// import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/jeep_routes/jeep_code_item.dart';

class JeepCodeList extends StatefulWidget {
  final List<Map<String, dynamic>> jeepRoutes;

  const JeepCodeList({
    super.key,
    required this.jeepRoutes,
  });

  @override
  State<JeepCodeList> createState() => _JeepCodeListState();
}

class _JeepCodeListState extends State<JeepCodeList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: widget.jeepRoutes.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> route = entry.value;

          return Padding(
            padding: EdgeInsets.all(8),
            child: JeepCodeItem(
              jeepCode: route["jeepCode"],
              routePage: route["route"],
            ),
          );
        }).toList(),
      ),
    );
  }
}
