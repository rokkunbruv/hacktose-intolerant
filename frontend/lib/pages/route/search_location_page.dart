import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tultul/api/google_maps_api/places_api.dart';
import 'package:tultul/classes/location/location.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/provider/search_locations_provider.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/widgets/location/locations_list.dart';
import 'package:tultul/pages/route/search_routes_page.dart';

class SearchLocationPage extends StatefulWidget {
  final bool? fromHome; // true if pushed by home page
  
  const SearchLocationPage({
    super.key,
    this.fromHome,
  });

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  late SearchLocationsProvider locationProvider;
  late PositionProvider positionProvider;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    locationProvider = Provider.of<SearchLocationsProvider>(context, listen: false);
    positionProvider = Provider.of<PositionProvider>(context, listen: false);
  }

  void navigateBack() {
    locationProvider = Provider.of<SearchLocationsProvider>(context, listen: false);
    locationProvider.resetSearch();

    Navigator.of(context).pop();
  }

  void navigateToSearchRoutesPage() {
    final routeFinderProvider = Provider.of<RouteFinderProvider>(context, listen: false);
    final positionProvider = Provider.of<PositionProvider>(context, listen: false);
    
    if (widget.fromHome != null && widget.fromHome! == true) {
      // if page is pushed from home page, then
      // set origin to be user's current location
      // and destination to be selected location
      if (positionProvider.currentLocation != null) {
        routeFinderProvider.setOrigin(positionProvider.currentLocation!);
      }

      if (locationProvider.selectedLocation != null) {
      routeFinderProvider.setDestination(locationProvider.selectedLocation!);
    }
    } else {
      // enter logic here when this page is pushed from search routes page
    }

    locationProvider.resetSearch();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
          SearchRoutesPage(),
      )
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchLocationsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80, 
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: AppColors.black,
              ),
              onPressed: navigateBack,
            ),
            flexibleSpace: SizedBox(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                ),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 32),
                          Expanded(
                            child: TextField(
                              controller: provider.locationController,
                              onChanged: (_) {
                                if (_debounce?.isActive ?? false) _debounce?.cancel();
                                _debounce = Timer(const Duration(milliseconds: 500), () {
                                  provider.searchLocations();
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Where to?',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: AppColors.red,
                                  size: 20,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            color: AppColors.white,
            child: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.locations.isEmpty && provider.locationController.text.isNotEmpty
                ? Center(
                    child: Text(
                      'No locations found',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
                : LocationsList(
                    locations: provider.locations,
                    onLocationSelected: (location) {
                      provider.selectLocation(location);
                      navigateToSearchRoutesPage();
                    },
                  ),
          ),
        );
      },
    );
  }
}