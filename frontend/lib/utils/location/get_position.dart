import 'package:geolocator/geolocator.dart';

Future<bool> checkLocationPermissions() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false; 

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }
  
  if (permission == LocationPermission.deniedForever) return false; 

  return true;
}

Stream<Position> getPositionStream() {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy for real-time tracking
      distanceFilter: 5, // Minimum movement (
    ),
  );
}
