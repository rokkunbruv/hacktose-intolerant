import 'package:flutter/material.dart';
// import 'package:tultul/theme/colors.dart';
// import 'package:tultul/theme/text_styles.dart';

class StepProvider extends ChangeNotifier {
  List<Widget> _stepContainers = [];

  List<Widget> get stepContainers => _stepContainers;

  void addStepContainer(Widget step) {
    _stepContainers.add(step);
    print("Total Steps: ${_stepContainers.length}"); // Debugging
    notifyListeners();
  }

  // access the list containing containers of each step
  List<Widget> getSteps() {
    return _stepContainers;
  }

  void clearSteps() {
    _stepContainers.clear();
    notifyListeners();
  }
}
