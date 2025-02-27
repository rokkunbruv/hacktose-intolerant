import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tultul/theme/colors.dart';
import 'package:tultul/provider/search_locations_provider.dart';
import 'package:tultul/widgets/location/locations_list.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  Timer? _debounce;

  void navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<SearchLocationsProvider>(context);
    
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
                  // BACK BUTTON
                  Row(
                    children: <Widget>[
                      SizedBox(width: 32),
                      Expanded(
                        child: TextField(
                          controller: locationProvider.locationController,
                          onChanged: (_) {
                            if (_debounce?.isActive ?? false) _debounce?.cancel();
                              _debounce = Timer(const Duration(milliseconds: 500), () {
                              locationProvider.searchLocations();
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
        child:LocationsList(
          locations: locationProvider.locations, 
          onLocationSelected: (location) {
            locationProvider.selectLocation(location);
          },
        ),
      ),
    );
  }
}