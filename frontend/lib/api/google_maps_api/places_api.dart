import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:tultul/classes/location/location.dart';

class PlacesApi {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String _placeDetailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
  static final String _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  
  // Cebu City bounds
  // static const LatLng _southWest = LatLng(10.225, 123.775);
  // static const LatLng _northEast = LatLng(10.425, 123.975);

  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 3),
    sendTimeout: Duration(seconds: 3),
  ));

  static const String _geocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  static const String _nearbySearchUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<List<Location>> getLocations(String query) async {
    if (query.isEmpty) return [];

    if (!await _checkInternetConnection()) {
      throw Exception('No internet connection available');
    }

    try {
      // fetch predictions using place autocomplete api
      final autocompleteResponse = await _dio.get(
        _baseUrl,
        queryParameters: {
          'input': query,
          'key': _apiKey,
          'components': 'country:ph',
          'location': '10.3157,123.8854', // set Cebu City as center
          'radius': '15000',
          'strictbounds': 'true',
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('The connection has timed out, please try again.');
        },
      );

      if (autocompleteResponse.data['status'] == 'REQUEST_DENIED') {
        debugPrint('PlacesApi - Error: ${autocompleteResponse.data['error_message']}'); 
        throw Exception('Google Maps API key is invalid.');
      }

      if (autocompleteResponse.data['predictions'] == null) {
        return [];
      }

      List<Location> locations = [];

      // Step 2: Fetch coordinates for each prediction using Place Details API
      for (var prediction in autocompleteResponse.data['predictions']) {
        final placeId = prediction['place_id'];
        if (placeId == null) continue;

        // Fetch place details
        final placeDetailsResponse = await _dio.get(
          _placeDetailsUrl,
          queryParameters: {
            'place_id': placeId,
            'key': _apiKey,
          },
        );

        if (placeDetailsResponse.data['status'] == 'OK') {
          final result = placeDetailsResponse.data['result'];
          final lat = result['geometry']['location']['lat'];
          final lng = result['geometry']['location']['lng'];

          locations.add(
            Location(
              address: prediction['description'],
              coordinates: LatLng(lat, lng),
            ),
          );
        }
      }

      return locations;
    } on DioException catch (e) {
      debugPrint('PlacesApi - DioError: ${e.message}'); // Debug print
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Unable to connect to Google Maps. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timed out. Please try again.');
      }
      throw Exception('Failed to fetch locations: ${e.message}');
    } catch (e) {
      debugPrint('PlacesApi - Error: $e'); // Debug print
      throw Exception('Failed to fetch locations: $e');
    }
  }

  static Future<Location?> getNearestPlace(LatLng coordinates) async {
    try {
      debugPrint('Getting nearest place for: ${coordinates.latitude}, ${coordinates.longitude}');
      
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

      debugPrint('Nearby search response: ${nearbyResponse.data}');

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

        debugPrint('Found nearest place: ${location.address} at ${location.coordinates}');
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
      debugPrint('Error getting nearest place: $e');
      return null;
    }
  }
}