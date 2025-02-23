import 'package:flutter/material.dart';

import 'package:hacktose_intolerant_app/widgets/map/map_view.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MapView(),
      ),
    );
  }
}