import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tultul/widgets/ai_assistant_widget.dart';
import 'package:tultul/constants/jeepney_types.dart';
import 'package:tultul/constants/passenger_types.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/styles/map/marker_styles.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/widgets/generic/dropdown_select_button.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/generic/loading.dart';
import 'package:tultul/widgets/route/route_list.dart';
import 'package:tultul/pages/route/search_location_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import for Google Maps

class SearchRoutesPage extends StatefulWidget {
  const SearchRoutesPage({
    super.key,
  });

  @override
  State<SearchRoutesPage> createState() => _SearchRoutesPageState();
}

class _SearchRoutesPageState extends State<SearchRoutesPage> {
  final List<String> _passengerTypes = [regular, student, seniorCitizen, pwd];
  final List<String> _jeepneyTypes = [traditional, modern];
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; 

      final routeFinderProvider = Provider.of<RouteFinderProvider>(context, listen: false);
      final positionProvider = Provider.of<PositionProvider>(context, listen: false);

      // set default origin to current location if available
      if (routeFinderProvider.origin == null && positionProvider.currentLocation != null) {
        routeFinderProvider.setOrigin(positionProvider.currentLocation!);
      }
      
      if (routeFinderProvider.origin != null && routeFinderProvider.destination != null) {
        routeFinderProvider.findRoutes();
      }
    });
  }

  // update the camera position to include all markers
  void _updateCameraPosition() {
    if (_mapController == null || !mounted) return;

    final routeProvider = Provider.of<RouteFinderProvider>(context, listen: false);
    final positionProvider = Provider.of<PositionProvider>(context, listen: false);

    final markers = routeProvider.getMarkers().union({positionProvider.currentPositionMarker!});
    if (markers.isEmpty) return;

    LatLngBounds bounds = _boundsFromLatLngList(markers.map((marker) => marker.position).toList());
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // 50 is padding
  }

  // calculate bounds from a list of LatLng
  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  @override
  void dispose() {
    // cancel any ongoing asynchronous operations here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final positionProvider = Provider.of<PositionProvider>(context, listen: false);
    
    return Consumer<RouteFinderProvider>(
      builder: (context, routeProvider, child) {
        // Update camera position whenever markers change
        if (_mapController != null && (routeProvider.originMarker != null || routeProvider.destinationMarker != null)) {
          _updateCameraPosition();
        }

        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: <Widget>[
                        // BACK BUTTON
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.chevron_left,
                              color: AppColors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(height: 0),

                        // SET ORIGIN AND DESTINATION FIELDS
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 32), // Add padding to move fields left
                                child: Column(
                                  children: <Widget>[
                                    // Origin TextField
                                    TextField(
                                      controller: routeProvider.originController,
                                      readOnly: true,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SearchLocationPage(isOrigin: true),
                                          ),
                                        );
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Current Location',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: const Color.fromARGB(255, 219, 138, 15),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),

                                    // Destination TextField
                                    TextField(
                                      controller: routeProvider.destinationController,
                                      readOnly: true,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SearchLocationPage(isOrigin: false),
                                          ),
                                        );
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Where to?',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: AppColors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 38, 
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.bg,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.black,
                                      width: 0.8,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withAlpha(16),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Transform.rotate(
                                      angle: 4.71239, // 270 degrees in radians (3π/2)
                                      child: Icon(
                                        Icons.compare_arrows,
                                        color: AppColors.navy,
                                        size: 24,
                                      ),
                                    ),
                                    onPressed: () {
                                      // Swap origin and destination
                                      final tempLocation = routeProvider.origin;
                                      final tempAddress = routeProvider.originController.text;

                                      routeProvider.origin = routeProvider.destination;
                                      routeProvider.originController.text = routeProvider.destinationController.text;

                                      routeProvider.destination = tempLocation;
                                      routeProvider.destinationController.text = tempAddress;

                                      // Update markers
                                      if (routeProvider.origin != null) {
                                        routeProvider.originMarker = createOriginMarker(routeProvider.origin!);
                                      } else {
                                        routeProvider.originMarker = null;
                                      }

                                      if (routeProvider.destination != null) {
                                        routeProvider.destinationMarker = createDestinationMarker(routeProvider.destination!);
                                      } else {
                                        routeProvider.destinationMarker = null;
                                      }

                                      if (routeProvider.origin != null && routeProvider.destination != null) {
                                        routeProvider.findRoutes();
                                      }
                                    },
                                  ),
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
                      onMapCreated: (controller) {
                        _mapController = controller; // Store the map controller
                        _updateCameraPosition(); // Update camera position when the map is created
                      },
                      onMapTap: (latLng) {
                        routeProvider.setMarker(latLng);
                      },
                      markers: routeProvider.getMarkers().union(
                        {positionProvider.currentPositionMarker!}),
                      polylines: (routeProvider.selectedRoute != null)
                          ? {routeProvider.selectedRoute!.path.polyline}
                          : null,
                      snapToMarkers: true,
                    ),

                    // SUGGESTED ROUTES
                    DraggableContainer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
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

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    child: DropdownSelectButton(
                                      items: _passengerTypes,
                                      onChanged: (type) =>
                                          routeProvider.setPassengerType(type),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  SizedBox(
                                    child: DropdownSelectButton(
                                      items: _jeepneyTypes,
                                      onChanged: (type) =>
                                          routeProvider.setJeepneyType(type),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32),

                            // ROUTES
                            (routeProvider.isLoading) ? 
                            Center(
                              child: Loading(
                                loadingMessage: 'Searching for routes',
                              ),
                            ) :
                            RouteList(
                              routes: routeProvider.routes,
                              onRouteSelected: (route) {
                                routeProvider.selectRoute(route);
                              },
                            )
                          ],
                        ),
                      ),
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