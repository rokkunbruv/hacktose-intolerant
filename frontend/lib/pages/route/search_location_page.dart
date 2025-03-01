import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tultul/theme/colors.dart';
import 'package:tultul/provider/search_locations_provider.dart';
import 'package:tultul/widgets/location/locations_list.dart';
import 'package:tultul/pages/route/search_routes_page.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  late SearchLocationsProvider locationProvider;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    locationProvider = Provider.of<SearchLocationsProvider>(context, listen: false);
    locationProvider.resetSearch();
  }

  void navigateBack() {
    if (locationProvider.selectedLocation != null) {
      final selected = locationProvider.selectedLocation;
      print('Selected location: ${selected?.address}');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchRoutesPage(
            selectedLocation: selected!,
          ),
        ),
      );
    } else {
      locationProvider.resetSearch();
      Navigator.pop(context);
    }
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
                                  print('Searching...');
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
                      navigateBack();
                    },
                  ),
          ),
        );
      },
    );
  }
}