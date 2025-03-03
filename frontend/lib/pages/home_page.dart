import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tultul/pages/route/search_location_page.dart';
import 'package:tultul/widgets/map/map_view.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/utils/location/check_location_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PositionProvider positionProvider;
  bool _isLocationReady = false;

  void navigateToSearchDestinationPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchLocationPage(fromHome: true),
    ));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      positionProvider = Provider.of<PositionProvider>(context, listen: false);
      
      await checkLocationServices(context);
      
      if (mounted) {
        positionProvider.startPositionUpdates();
        setState(() => _isLocationReady = true);
      }
    });
  }

  @override
  void dispose() {
    positionProvider.stopPositionUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final positionProvider = Provider.of<PositionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/img/title.png',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.bg,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(64),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _isLocationReady && positionProvider.currentPositionMarker != null
              ? MapView(
                  markers: {positionProvider.currentPositionMarker!},
                  snapToCurrentPosition: true,
                )
              : Center(child: CircularProgressIndicator()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.red,
              ),
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Transform.translate(
                offset: Offset(0, -40),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: AppColors.red,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Where to?',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                  ),
                                  readOnly: true,
                                  onTap: navigateToSearchDestinationPage,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}