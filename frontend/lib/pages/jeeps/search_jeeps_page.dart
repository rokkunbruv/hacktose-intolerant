import 'package:flutter/material.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/jeep_routes/jeep_code_list.dart';
import 'package:tultul/pages/jeeps/JeepRoute.dart';

class SearchJeepsPage extends StatefulWidget {
  const SearchJeepsPage({super.key});

  @override
  State<SearchJeepsPage> createState() => _SearchJeepsPageState();
}

class _SearchJeepsPageState extends State<SearchJeepsPage> {
  final List<Map<String, dynamic>> jeepRoutes = [
    
    {"jeepCode": "04L"},
    {"jeepCode": "01B"},
    {"jeepCode": "17B"},
    {"jeepCode": "17C"},
    {"jeepCode": "03L"},
    {"jeepCode": "04C"},
    {"jeepCode": "04I"},
    {"jeepCode": "04H"},
    {"jeepCode": "24"},
    {"jeepCode": "62B"},
    {"jeepCode": "62C"},
    {"jeepCode": "25"}
  ];

  late final List<Map<String, dynamic>> formattedRoutes;

  @override
  void initState() {
    super.initState();
    formattedRoutes = jeepRoutes.map((route) {
      return {
        "jeepCode": route["jeepCode"],
        "route": () => JeepRoutePage(routeCode: route["jeepCode"]),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jeepney Routes',
          style: AppTextStyles.title1.copyWith(
            color: AppColors.vanilla,
          ),
        ),
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
        child: Column(
          children: [
            SizedBox(height: 150), // Keeps spacing from the top

            Center(
              child: Image.asset(
                'assets/img/jeep_big_logo.png',
                width: 300,
                height: 300,
              ),
            ),

            SizedBox(height: 20), // Spacing before DraggableContainer

            // Ensure DraggableContainer is inside a SizedBox to prevent layout issues
            SizedBox(
              height: 300, // Keep this if DraggableContainer has a fixed height
              child: DraggableContainer(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: JeepCodeList(jeepRoutes: formattedRoutes),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
