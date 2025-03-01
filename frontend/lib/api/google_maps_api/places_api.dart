import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:tultul/classes/location/location.dart';

class PlacesApi {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String _placeDetailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
  static final String _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  
  // Cebu City bounds
  static const LatLng _southWest = LatLng(10.225, 123.775);
  static const LatLng _northEast = LatLng(10.425, 123.975);

  static final Dio _dio = Dio();

  static const String _geocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  static const String _nearbySearchUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static Future<List<Location>> getLocations(String query) async {
    print('PlacesApi - Searching for: $query'); // Debug print
    if (query.isEmpty) return [];

    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'input': query,
          'key': _apiKey,
          'components': 'country:ph',
          'location': '10.3157,123.8854', // Cebu City center
          'radius': '15000',
          'strictbounds': 'true',
        },
      );

      print('PlacesApi - Response: ${response.data}'); // Debug print

      if (response.data['status'] == 'REQUEST_DENIED') {
        print('PlacesApi - Error: ${response.data['error_message']}'); // Debug print
        throw Exception('Google Maps API key is invalid.');
      }

      if (response.data['predictions'] != null) {
        List<Location> locations = [];
        for (var prediction in response.data['predictions']) {
          locations.add(
            Location(
              address: prediction['description'],
              coordinates: LatLng(10.3157, 123.8854), // Default to Cebu City center for now
            ),
          );
        }
        return locations;
      }
      
      return [];
    } catch (e) {
      print('PlacesApi - Error: $e'); // Debug print
      throw Exception('Failed to fetch locations: $e');
    }
  }

  static Future<Location?> getNearestPlace(LatLng coordinates) async {
    try {
      print('Getting nearest place for: ${coordinates.latitude}, ${coordinates.longitude}');
      
      // First, search for nearby places
      final nearbyResponse = await _dio.get(
        _nearbySearchUrl,
        queryParameters: {
          'location': '${coordinates.latitude},${coordinates.longitude}',
          'radius': '100', // Search within 100 meters
          'key': _apiKey,
          'rankby': 'distance', // Get the closest place
          'language': 'en',
        },
      );

      print('Nearby search response: ${nearbyResponse.data}');

      if (nearbyResponse.data['status'] == 'OK' && nearbyResponse.data['results'].isNotEmpty) {
        final nearestPlace = nearbyResponse.data['results'][0];
        
        // Get the place details for more accurate information
        final location = Location(
          address: nearestPlace['name'] ?? nearestPlace['vicinity'] ?? 'Unknown Place',
          coordinates: LatLng(
            nearestPlace['geometry']['location']['lat'],
            nearestPlace['geometry']['location']['lng'],
          ),
        );

        print('Found nearest place: ${location.address} at ${location.coordinates}');
        return location;
      }

      // Fallback to geocoding if no places found nearby
      final geocodeResponse = await _dio.get(
        _geocodeUrl,
        queryParameters: {
          'latlng': '${coordinates.latitude},${coordinates.longitude}',
          'key': _apiKey,
          'language': 'en',
        },
      );

      if (geocodeResponse.data['status'] == 'OK' && geocodeResponse.data['results'].isNotEmpty) {
        final result = geocodeResponse.data['results'][0];
        
        // Try to get a meaningful name
        String address = '';
        var components = result['address_components'];
        for (var component in components) {
          var types = component['types'] as List;
          if (types.contains('point_of_interest') || 
              types.contains('establishment') ||
              types.contains('premise')) {
            address = component['long_name'];
            break;
          }
        }
        
        if (address.isEmpty) {
          address = result['formatted_address'];
        }

        return Location(
          address: address,
          coordinates: LatLng(
            result['geometry']['location']['lat'],
            result['geometry']['location']['lng'],
          ),
        );
      }
      
      return null;
    } catch (e) {
      print('Error getting nearest place: $e');
      return null;
    }
  }
}