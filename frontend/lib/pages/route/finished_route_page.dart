import 'package:flutter/material.dart';

class FinishedRoutePage extends StatefulWidget {
  const FinishedRoutePage({super.key});

  @override
  State<FinishedRoutePage> createState() => _FinishedRoutePageState();
}

class _FinishedRoutePageState extends State<FinishedRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('YIPPIE!'),
      ),
    );
  }
}
