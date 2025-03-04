import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:tultul/api/jeepney_api/jeepney_api.dart';
import 'package:tultul/provider/jeepney_provider.dart';
import 'package:tultul/widgets/generic/draggable_container.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class JeepRoutePage extends StatefulWidget {
  final String jsonFile;

  const JeepRoutePage({super.key, required this.jsonFile});

  @override
  State<JeepRoutePage> createState() => _JeepRoutePageState();
}

class _JeepRoutePageState extends State<JeepRoutePage> {
  Set<Polyline> _polylines = {};
  List<String> _routeNames = [];
  bool _isMapLoaded = false;

  void navigateBack() {
    Navigator.of(context).pop();
  }

  Future<void> loadRoute() async {
    Map<String, dynamic> jsonRouteData = await JeepneyApi.getJeepneyRoute(widget.jsonFile);

    _polylines = jsonRouteData['polylines'];
    _routeNames = jsonRouteData['routeNames'];

    if (jsonRouteData != {}) {
      setState(() => _isMapLoaded = true);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jeepneyProvider = Provider.of<JeepneyProvider>(context, listen: false);

      jeepneyProvider.initializeJeepneyMarker();
      jeepneyProvider.loadRoute(widget.jsonFile);
    });

    loadRoute();
  }

  @override
  Widget build(BuildContext context) {
    final jeepneyProvider = Provider.of<JeepneyProvider>(context);

    Set<Marker> markers = jeepneyProvider.jeepneyMarkers;

    return Scaffold(
      appBar: AppBar(
        title: Text('Jeepney Routes',
            style: AppTextStyles.title1.copyWith(color: AppColors.vanilla)),
        centerTitle: true,
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // MAP VIEW
          _isMapLoaded
              ? MapView(
                markers: markers,
                polylines: _polylines,
                snapToPolyline: true,
              )
              : Center(child: CircularProgressIndicator()),

          // ROUTE DETAILS
          if (_isMapLoaded)
            DraggableContainer(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.lightGray),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center, 
                        children: [
                          Align(
                            alignment: Alignment.centerLeft, 
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: navigateBack,
                            ),
                          ),
                          Center( 
                            child: Text(
                              widget.jsonFile,
                              style: AppTextStyles.label1.copyWith(color: AppColors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Column(
                      children: _routeNames.asMap().entries.map((entry) {
                        int index = entry.key;
                        String name = entry.value;
                        Image icon = index == 0
                            ? Image.asset('assets/icons/route_legend_yellow.png', width: 30, height: 30)
                            : Image.asset('assets/icons/route_legend_blue.png', width: 30, height: 30);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              icon,
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  name, 
                                  style: AppTextStyles.label4.copyWith(
                                    color: AppColors.black
                                  ),
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}