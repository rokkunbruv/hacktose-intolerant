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

  bool isLoading = false;

  /// fetch routes using the directions api.
  Future<void> searchLocations() async {
    if (locationController.text.isEmpty) {
      locations = [];
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      print('Searching for: ${locationController.text}');

      locations = await PlacesApi.getLocations(
        locationController.text
      );

      print('Found ${locations.length} locations');

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in searchLocations: $e');
      isLoading = false;
      locations = [];
      notifyListeners();
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

  void resetSearch() {
    locations = [];
    locationController.clear();
    selectedLocation = null;
    isLoading = false;
    notifyListeners();
  }

}
