import 'package:flutter/material.dart';

import 'package:tultul/widgets/location/location_item.dart';
import 'package:tultul/classes/location/location.dart';

class LocationsList extends StatelessWidget {
  final List<Location> locations;
  final Function(Location) onLocationSelected;

  const LocationsList({
    super.key, 
    required this.locations, 
    required this.onLocationSelected
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        Location location = locations[index];
        return LocationItem(
          location: location,
          onPressed: () => onLocationSelected(location), 
        );
      },
    );
  }
}
