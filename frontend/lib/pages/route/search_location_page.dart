import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tultul/theme/colors.dart';
import 'package:tultul/provider/route_finder_provider.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteFinderProvider>(context);
    final textController = routeProvider.originController;
    
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80, 
          flexibleSpace: SizedBox(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bg,
              ),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    // BACK BUTTON
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.chevron_left,
                            color: AppColors.black,
                          )
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              labelText: 'Where to?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: AppColors.red,
                                size: 20,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: AppColors.white,
          child: Column(

          )
        )
      ),
    );
  }
}