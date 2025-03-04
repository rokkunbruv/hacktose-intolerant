import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> loadJeepneyIcon() async {
    try {
      // load the original image file
      final ByteData data = await rootBundle.load('assets/icons/jeepney_icon.png');
      final Uint8List bytes = data.buffer.asUint8List();
      
      // decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: 30, targetHeight: 50);  // very small size
      final ui.FrameInfo fi = await codec.getNextFrame();
      
      // convert to byte data
      final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedBytes = byteData!.buffer.asUint8List();
      
      // create the bitmap descriptor
      return BitmapDescriptor.bytes(resizedBytes);
    } catch (e) {
      debugPrint("Error loading jeepney icon: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }