import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/api/google_maps_api/places_api.dart';
import 'package:tultul/classes/location/location.dart';

class SearchLocationsProvider extends ChangeNotifier {
  // controllers for text fields.
  final TextEditingController locationController = TextEditingController();

  // search result of locations
  List<Location> locations = [];

  Location? selectedLocation;

  /// fetch routes using the directions api.
  Future<void> searchLocations() async {
    if (locationController.text.isEmpty) {
      throw('Location is not set.');
    }

    try {
      locations = await PlacesApi.getLocations(
        locationController.text
      );

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// select a location
  void selectLocation(Location location) {
    selectedLocation = location;

    notifyListeners();
  }

  /// clears all locations
  void clearAll() {
    locationController.clear();
    selectedLocation = null;
    locations = [];
    
    notifyListeners();
  }
}
