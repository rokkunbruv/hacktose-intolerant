import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/widgets/generic/dropdown_select_button.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/route/route_list.dart';
import 'package:tultul/constants/jeepney_types.dart';
import 'package:tultul/constants/passenger_types.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class SearchRoutesPage extends StatefulWidget {
  const SearchRoutesPage({super.key});

  @override
  State<SearchRoutesPage> createState() => _SearchRoutesPageState();
}

class _SearchRoutesPageState extends State<SearchRoutesPage> {
  final List<String> _passengerTypes = [regular, student, seniorCitizen, pwd];
  final List<String> _jeepneyTypes = [traditional, modern];
  
  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteFinderProvider>(context);

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
                      child: Icon(
                        Icons.chevron_left,
                        color: AppColors.white,
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
                          TextField(
                            controller: routeProvider.originController,
                            decoration: InputDecoration(
                              labelText: 'Current Location',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          ),
                          SizedBox(height: 6),
                          TextField(
                            controller: routeProvider.destinationController,
                            decoration: InputDecoration(
                              labelText: 'Where to?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                polylines: (routeProvider.selectedRoute != null) ?
                  {routeProvider.selectedRoute!.path.polyline} : null,
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
  }
}