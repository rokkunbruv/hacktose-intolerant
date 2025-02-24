import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hacktose_intolerant_app/pages/route/search_routes_page.dart';

import 'package:provider/provider.dart';

// import 'package:hacktose_intolerant_app/pages/home_page.dart';
// import 'package:hacktose_intolerant_app/pages/jeepnery_route_finder_page.dart';
import 'package:hacktose_intolerant_app/provider/route_finder_provider.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: '.env'); // Load .env file
  } catch (e) {
    debugPrint(e.toString());
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouteFinderProvider()),
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
      title: 'Hacktose Intolerant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const JeepneyRouteFinderPage(),
      home: const SearchRoutesPage(),
    );
  }
}