import 'package:flutter/material.dart';

// import 'package:tultul/styles/widget/box_shadow_style.dart';
// import 'package:tultul/theme/colors.dart';
// import 'package:tultul/theme/text_styles.dart';

import 'package:tultul/constants/step_types.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';

import 'package:tultul/widgets/route/route_steps.dart';

class RouteStepsPage extends StatefulWidget {
  const RouteStepsPage({super.key});

  @override
  State<RouteStepsPage> createState() => _RouteStepsPageState();
}

class _RouteStepsPageState extends State<RouteStepsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableContainer(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              StepDetails(type: StepType.start),
              StepDetails(
                  type: StepType.walk, duration: '1 min', distance: '3 km'),
              StepDetails(
                type: StepType.transport,
                type2: StepType.end,
                location: 'Insular Square',
                jeepCode: '24',
                fare: 'P 18.00',
                dropOff: 'Andoks, Mabolo, Cebu City',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
