import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

import 'package:tultul/pages/home_page.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/provider/jeepney_provider.dart'; 
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/provider/search_locations_provider.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/utils/location/request_location_services.dart';
import 'package:tultul/utils/navigation/navigator_key.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: '.env'); // load .env file
  } catch (e) {
    debugPrint(e.toString());
  }

  // Request location services
  await requestLocationServices();
  
  // Request audio permission
  await Permission.microphone.request();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouteFinderProvider()),
        ChangeNotifierProvider(create: (_) => PositionProvider()),
        ChangeNotifierProvider(create: (_) => SearchLocationsProvider()),
        ChangeNotifierProvider(create: (_) => JeepneyProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Hacktose Intolerant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.red),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

