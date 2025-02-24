/// models a single transit step.
class DirectionStep {
  final String travelMode;
  final double distanceValue; // in meters
  final String? transitLineName;

  DirectionStep({
    required this.travelMode, 
    required this.distanceValue, 
    this.transitLineName
  });

  factory DirectionStep.fromJson(Map<String, dynamic> json) {
    String mode = json['travel_mode'];
    double dist = json['distance']['value'].toDouble();
    String? transitName;

    if (mode == 'TRANSIT' && json['transit_details'] != null) {
      transitName = json['transit_details']['line']['name'];
    }
    
    return DirectionStep(
      travelMode: mode,
      distanceValue: dist,
      transitLineName: transitName,
    );
  }
}