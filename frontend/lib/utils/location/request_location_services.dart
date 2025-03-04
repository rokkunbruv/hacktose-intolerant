import 'package:flutter/foundation.dart';

import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationServices() async {
  // Check if location permissions are granted
  var status = await Permission.location.status;
  
  if (!status.isGranted) {
    // Request location permissions
    status = await Permission.location.request();
    
    if (status.isDenied) {
      debugPrint("Location permissions are denied");
    } else if (status.isPermanentlyDenied) {
      debugPrint("Location permissions are permanently denied");
      openAppSettings();
    }
  }
}
