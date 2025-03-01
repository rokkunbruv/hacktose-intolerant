class JeepneyRide {
  final String route;
  // final String code;
  final String type;
  final double fare;

  JeepneyRide({
    required this.route,
    // required this.code,
    required this.type,
    required this.fare,
  });

  // getters
  String get getRoute => route;
  // String get getCode => code; 
  String get getType => type;
  double get getFare => fare;
}