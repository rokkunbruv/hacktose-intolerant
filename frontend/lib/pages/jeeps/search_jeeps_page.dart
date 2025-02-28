import 'package:flutter/material.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/pages/jeeps/temp_jeep1.dart';
import 'package:tultul/pages/jeeps/temp_jeep2.dart';

import 'package:tultul/widgets/jeep_routes/jeep_code_list.dart';

class SearchJeepsPage extends StatefulWidget {
  const SearchJeepsPage({super.key});

  @override
  State<SearchJeepsPage> createState() => _SearchJeepsPageState();
}

class _SearchJeepsPageState extends State<SearchJeepsPage> {
  List<Map<String, dynamic>> jeepRoutes = [
    {"jeepCode": "04L", "route": () => TempJeep1Page()},
    {"jeepCode": "01K", "route": () => TempJeep2Page()}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeepney Routes',
            style: AppTextStyles.title1.copyWith(
              color: AppColors.vanilla,
            )),
        backgroundColor: AppColors.red,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: DraggableContainer(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: JeepCodeList(jeepRoutes: jeepRoutes)),
        ),
      ),
    );
  }
}
