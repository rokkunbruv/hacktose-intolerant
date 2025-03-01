import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:provider/provider.dart';

import 'package:tultul/pages/home_page.dart';
import 'package:tultul/pages/route/search_routes_page.dart';
import 'package:tultul/pages/route/route_details_page.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/provider/position_provider.dart';
import 'package:tultul/provider/search_locations_provider.dart';
import 'package:tultul/utils/location/request_location_services.dart';
import 'package:tultul/utils/location/check_location_services.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: '.env'); // load .env file
  } catch (e) {
    debugPrint(e.toString());
  }

  await requestLocationServices();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouteFinderProvider()),
        ChangeNotifierProvider(create: (_) => PositionProvider()),
        ChangeNotifierProvider(create: (_) => SearchLocationsProvider()),
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
      debugShowCheckedModeBanner: false,
      title: 'Hacktose Intolerant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
