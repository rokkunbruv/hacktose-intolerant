import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tultul/theme/colors.dart';
import 'package:tultul/provider/search_locations_provider.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/widgets/location/locations_list.dart';
import 'package:tultul/widgets/generic/loading.dart';
import 'package:tultul/pages/route/search_routes_page.dart';

class SearchLocationPage extends StatefulWidget {
  final bool? fromHome; // true if pushed by home page
  final bool? isOrigin; // true if selecting origin location, false if selecting destination
  
  const SearchLocationPage({
    super.key,
    this.fromHome,
    this.isOrigin,
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
      // if page is pushed from search routes page
      if (locationProvider.selectedLocation != null) {
        if (widget.isOrigin == true) {
          routeFinderProvider.setOrigin(locationProvider.selectedLocation!);
        } else {
          routeFinderProvider.setDestination(locationProvider.selectedLocation!);
        }
      }
    }

    locationProvider.resetSearch();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SearchRoutesPage(),
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
                                labelText: widget.isOrigin == true ? 'Start at?' : 'Where to?',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: AppColors.red,
                                  size: 20,
                                ),
                                suffixIcon: provider.locationController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.grey[600],
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        provider.locationController.clear();
                                        provider.searchLocations();
                                      },
                                    )
                                  : null,
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
          body: Column(
            children: [
              // Use current location button
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (positionProvider.currentLocation != null) {
                        provider.selectLocation(positionProvider.currentLocation!);
                        navigateToSearchRoutesPage();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.my_location_outlined,
                            color: AppColors.navy,
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Use Current Location',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: AppColors.gray),
              // Search results
              Expanded(
                child: Container(
                  color: AppColors.bg,
                  child: provider.isLoading
                    ? Center(
                      child: Loading(
                        loadingMessage: 'Searching for locations'
                      ),
                    )
                    : provider.locations.isEmpty && provider.locationController.text.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.grey[400],
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Connection timed out',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Please try again',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : provider.locationController.text.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.matrix([
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0, 0, 0, 1, 0,
                                  ]),
                                  child: Image.asset(
                                    'assets/img/empty_search.png',
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Where would you like to go?',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Type a location to start searching',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
              ),
            ],
          ),
        );
      },
    );
  }
}