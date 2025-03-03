import 'package:flutter/material.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
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
      padding: const EdgeInsets.all(10),
      child: Wrap( 
        spacing: 10, 
        runSpacing: 8, 
        alignment: WrapAlignment.center, 
        children: widget.jeepRoutes.map((route) {
          return JeepCodeItem(
            jeepCode: route["jeepCode"],
            routePage: route["route"],
          );
        }).toList(),
      ),
    );
  }
}
