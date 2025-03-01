class RouteModel {
  final String label;
  final String name;
  final List<List<double>> coordinates; // [latitude, longitude]

  RouteModel({required this.label, required this.name, required this.coordinates});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      label: json['label'] as String? ?? 'Unknown Label',
      name: json['name'] as String? ?? 'Unknown Route',
      coordinates: (json['path'] as List<dynamic>?)
              ?.map((coord) => [
                    (coord[0] as num?)?.toDouble() ?? 0.0, // Latitude
                    (coord[1] as num?)?.toDouble() ?? 0.0, // Longitude
                  ])
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'name': name,
      'coordinates': coordinates,
    };
  }
}
