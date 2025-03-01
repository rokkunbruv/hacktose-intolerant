import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tultul/api/google_maps_api/places_api.dart';
import 'package:tultul/classes/location/location.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/widgets/generic/dropdown_select_button.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/route/route_list.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/styles/map/marker_styles.dart';

class SearchRoutesPage extends StatefulWidget {
  final Location? selectedLocation;
  
  const SearchRoutesPage({
    super.key,
    this.selectedLocation,
    });

  @override
  State<SearchRoutesPage> createState() => _SearchRoutesPageState();
}

class _SearchRoutesPageState extends State<SearchRoutesPage> {
  final List<String> _passengerTypes = ['Regular', 'Student', 'Senior Citizen', 'PWD'];
  final List<String> _jeepneyTypes = ['Traditional', 'Modern'];

  String? _selectedPassengerType;
  String? _selectedJeepneyType;
  
  Timer? _originDebounce;
  Timer? _destinationDebounce;
  List<Location> originSuggestions = [];
  List<Location> destinationSuggestions = [];
  bool isLoadingOrigin = false;
  bool isLoadingDestination = false;

  @override
  void initState() {
    super.initState();
    // Set the destination when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedLocation != null) {
        print('Setting destination: ${widget.selectedLocation?.address}'); // Debug print
        final routeProvider = Provider.of<RouteFinderProvider>(context, listen: false);
        routeProvider.destinationController.text = widget.selectedLocation!.address;
        routeProvider.destination = widget.selectedLocation!.coordinates;
        routeProvider.destinationMarker = createDestinationMarker(widget.selectedLocation!.coordinates);
        routeProvider.notifyListeners();
      }
    });
  }

  Future<void> searchOriginLocations(String query) async {
    if (_originDebounce?.isActive ?? false) _originDebounce?.cancel();
    _originDebounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        isLoadingOrigin = true;
      });
      try {
        originSuggestions = await PlacesApi.getLocations(query);
      } catch (e) {
        print('Error searching origin: $e');
      }
      setState(() {
        isLoadingOrigin = false;
      });
    });
  }

  Future<void> searchDestinationLocations(String query) async {
    if (_destinationDebounce?.isActive ?? false) _destinationDebounce?.cancel();
    _destinationDebounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        isLoadingDestination = true;
      });
      try {
        destinationSuggestions = await PlacesApi.getLocations(query);
      } catch (e) {
        print('Error searching destination: $e');
      }
      setState(() {
        isLoadingDestination = false;
      });
    });
  }

  @override
  void dispose() {
    _originDebounce?.cancel();
    _destinationDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteFinderProvider>(
      builder: (context, routeProvider, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                  ),
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        // BACK BUTTON
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: AppColors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          )
                        ),
                        SizedBox(height: 8),

                        // SET ORIGIN AND DESTINATION FIELDS
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: <Widget>[
                              // Origin TextField
                              TextField(
                                controller: routeProvider.originController,
                                onChanged: (value) {
                                  searchOriginLocations(value);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Current Location',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  suffixIcon: routeProvider.originController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          routeProvider.clearOrigin();
                                          setState(() {
                                            originSuggestions = [];
                                          });
                                        },
                                      )
                                    : null,
                                ),
                              ),
                              if (isLoadingOrigin)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              if (originSuggestions.isNotEmpty)
                                Container(
                                  constraints: BoxConstraints(maxHeight: 200),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: originSuggestions.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(originSuggestions[index].address),
                                        onTap: () {
                                          routeProvider.setOrigin(originSuggestions[index]);
                                          setState(() {
                                            originSuggestions = [];
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: 6),

                              // Destination TextField
                              TextField(
                                controller: routeProvider.destinationController,
                                onChanged: (value) {
                                  searchDestinationLocations(value);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Where to?',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  suffixIcon: routeProvider.destinationController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          routeProvider.clearDestination();
                                          setState(() {
                                            destinationSuggestions = [];
                                          });
                                        },
                                      )
                                    : null,
                                ),
                              ),
                              if (isLoadingDestination)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              if (destinationSuggestions.isNotEmpty)
                                Container(
                                  constraints: BoxConstraints(maxHeight: 200),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: destinationSuggestions.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(destinationSuggestions[index].address),
                                        onTap: () {
                                          routeProvider.setDestination(destinationSuggestions[index]);
                                          setState(() {
                                            destinationSuggestions = [];
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // MAP VIEW
                    MapView(
                      onMapTap: (latLng) {
                        routeProvider.setMarker(latLng);
                      },
                      markers: routeProvider.getMarkers(),
                      polylines: routeProvider.getSelectedRoutePolylines(),
                    ),

                    // SUGGESTED ROUTES
                    DraggableContainer(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.gray,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: SizedBox(height: 4, width: 64),
                            ),
                            SizedBox(height: 16),

                            // SUGGESTED ROUTES HEADER
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Suggested Routes',
                                    style: AppTextStyles.label2.copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: AppColors.lightGray,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),

                            // ROUTES OPTIONS
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    child: DropdownSelectButton(
                                      items: _passengerTypes,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  SizedBox(
                                    child: DropdownSelectButton(
                                      items: _jeepneyTypes,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32),

                            // ROUTE ITEMS
                            RouteList(
                              routes: routeProvider.routes,
                              onRouteSelected: (route) {
                                routeProvider.selectRoute(route);
                              },
                            ),
                          ],
                        )
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}