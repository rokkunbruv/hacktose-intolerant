import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/classes/location/location.dart';

class PlacesApi {
  static Future<List<Location>> getLocations(String address) async {
    Location placeholder = Location(address: 'Location 1', coordinates: LatLng(10, 10));
    
    return <Location>[placeholder];
  }
}