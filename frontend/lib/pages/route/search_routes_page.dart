import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:hacktose_intolerant_app/widgets/map/map_view.dart';
import 'package:hacktose_intolerant_app/widgets/generic/dropdown_select_button.dart';
import 'package:hacktose_intolerant_app/widgets/route/route_list.dart';
import 'package:hacktose_intolerant_app/provider/route_finder_provider.dart';
import 'package:hacktose_intolerant_app/theme/colors.dart';
import 'package:hacktose_intolerant_app/theme/text_styles.dart';

class SearchRoutesPage extends StatefulWidget {
  const SearchRoutesPage({super.key});

  @override
  State<SearchRoutesPage> createState() => _SearchRoutesPageState();
}

class _SearchRoutesPageState extends State<SearchRoutesPage> {
  final List<String> _passengerTypes = ['Regular', 'Student', 'Senior Citizen', 'PWD'];
  final List<String> _jeepneyTypes = ['Traditional', 'Modern'];

  String? _selectedPassengerType;
  String? _selectedJeepneyType;
  
  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteFinderProvider>(context);
    final originController = routeProvider.originController;
    final destinationController = routeProvider.destinationController;

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
                            controller: originController,
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
                            controller: destinationController,
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
  }
}

class DraggableContainer extends StatefulWidget {
  final Widget child;
  const DraggableContainer({
    super.key,
    required this.child,
  });
  
  @override
  State<DraggableContainer> createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragPosition = 0.0;
  double _targetPosition = 0.0; // The final target position

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Adjust for smoothness
    )..addListener(() {
        setState(() {
          _dragPosition = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToPosition(double newPosition) {
    _targetPosition = newPosition.clamp(0.0, MediaQuery.of(context).size.height - 100);
    // _animation = Tween<double>(begin: _dragPosition, end: _targetPosition)
    //     .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animation = Tween<double>(begin: _dragPosition, end: _targetPosition)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    _controller.forward(from: 0.0); // Restart animation
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: _dragPosition,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragPosition += details.delta.dy;
            _dragPosition = _dragPosition.clamp(0.0, MediaQuery.of(context).size.height - 100);
          });
        },
        onVerticalDragEnd: (details) {
          // Smoothly animate to the nearest resting position
          _animateToPosition(_dragPosition);
        },
        child: widget.child,
      ),
    );
  }
}
