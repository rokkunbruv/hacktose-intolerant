import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';

import 'package:tultul/widgets/generic/action_dialog_prompt.dart';

Future<void> checkLocationServices(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled && context.mounted) {
    bool? enableService = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ActionDialogPrompt(
          title: 'Location Services Disabled',
          content: 'Please enable location services to use the app.',
          acceptButtonLabel: 'Enable',
        );
      },
    );

    if (enableService == true) {
      await Geolocator.openLocationSettings();
    } else {
      SystemNavigator.pop();
    }
  }
}