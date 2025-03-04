import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tultul/pages/jeeps/search_jeeps_page.dart';
import 'package:tultul/pages/route/search_location_page.dart';
import 'package:tultul/pages/route/search_routes_page.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/styles/widget/box_shadow_style.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';
import 'package:tultul/utils/location/check_location_services.dart';
import 'package:tultul/widgets/ai_assistant_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void navigateToSearchJeepsPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchJeepsPage(),
    ));
  }

  void navigateToSearchLocationPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchLocationPage(),
    ));
  }

  void toggleVoiceAssistant() {
    final positionProvider = Provider.of<PositionProvider>(context, listen: false);
    final routeProvider = Provider.of<RouteFinderProvider>(context, listen: false);
 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only( 
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AIAssistantWidget(
          onRouteSearch: (origin, destination) {
            if (origin == "current location") {
              if (positionProvider.currentLocation != null) {
                routeProvider.setOrigin(positionProvider.currentLocation!);
              }
            } else {
              routeProvider.originController.text = origin;
            }

            routeProvider.destinationController.text = destination;

            Navigator.pop(context);

            if (routeProvider.origin != null && routeProvider.destination != null) {
              routeProvider.findRoutes();
            }

            Navigator.of(context).push(MaterialPageRoute(builder: 
              (context) => SearchRoutesPage(),
            ));
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final positionProvider = Provider.of<PositionProvider>(context, listen: false);
      
      await checkLocationServices(context);
      
      if (mounted) {
        positionProvider.startPositionUpdates();
      }
    });
  }

  @override
  void dispose() {
    Provider.of<PositionProvider>(context, listen: false).stopPositionUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteFinderProvider>(context, listen: false);
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg1.png'),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: AppBar(
              toolbarHeight: 200,
              flexibleSpace: SizedBox(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                  ),
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'MABUHAY!',
                                    style: AppTextStyles.title.copyWith(
                                      color: AppColors.vanilla,
                                      height: 0,
                                      fontSize: 44,
                                    ),
                                  ),
                                  Text(
                                    'Welcome to Tultul.',
                                    style: AppTextStyles.label3.copyWith(
                                      color: AppColors.vanilla,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image(
                              image: AssetImage('assets/img/home-page-design.png'),
                              width: 140,
                              height: 160,
                              alignment: Alignment.bottomRight,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              clipBehavior: Clip.none,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                height: 300,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  color: AppColors.white,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Going somewhere?',
                              style: AppTextStyles.label3,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: navigateToSearchLocationPage,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [createBoxShadow()],
                              ),
                              child: Column(
                                children: <Widget>[
                                  IgnorePointer(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.location_on_outlined,
                                          color: AppColors.navy,
                                          size: 24,
                                        ),
                                        hintText: 'Current Location',
                                        hintStyle: AppTextStyles.label4,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                      ),
                                      readOnly: true,
                                      controller: routeProvider.originController,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  IgnorePointer(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.location_on,
                                          color: AppColors.red,
                                          size: 24,
                                        ),
                                        hintText: 'Where to?',
                                        hintStyle: AppTextStyles.label4,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                      ),
                                      readOnly: true,
                                      controller: routeProvider.destinationController,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.saffron,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: navigateToSearchJeepsPage,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage('assets/icons/jeepney-icon-small-navy.png'),
                                      height: 16,
                                      width: 16,
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'Discover Jeepney Routes',
                                      style: AppTextStyles.label4,
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.black,
                                  size: 24,
                                ),
                              ],
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
          Positioned(
            right: 24,
            bottom: 250,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.red,
                boxShadow: [createBoxShadow()],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.settings_voice,
                  color: AppColors.white,
                  size: 32,
                ),
                onPressed: toggleVoiceAssistant,
              ) 
            ),
          ),
        ],
      ),
    );
  }
}