import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:tultul/services/ai_assistant_service.dart';
import 'package:tultul/provider/route_finder_provider.dart';
import 'package:tultul/api/google_maps_api/places_api.dart';
import 'package:tultul/classes/location/location.dart';
import 'package:tultul/theme/colors.dart';
import 'package:tultul/theme/text_styles.dart';

class AIAssistantWidget extends StatefulWidget {
  final Function(String, String) onRouteSearch;
  final Function(String) onJeepneyRouteRequest;

  const AIAssistantWidget({
    super.key,
    required this.onRouteSearch,
    required this.onJeepneyRouteRequest,
  });

  @override
  State<AIAssistantWidget> createState() => _AIAssistantWidgetState();
}

class _AIAssistantWidgetState extends State<AIAssistantWidget> {
  late AIAssistantService _aiAssistant;
  bool _isListening = false;
  String _transcription = '';
  String _aiResponse = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAIAssistant();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeAIAssistant() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      _aiAssistant = AIAssistantService(
        onTranscription: (text) {
          setState(() => _transcription = text);
        },
        onListeningStateChanged: (isListening) {
          setState(() => _isListening = isListening);
        },
        onRouteSearch: (origin, destination) async {
          try {
            final routeProvider = Provider.of<RouteFinderProvider>(context, listen: false);
            
            // First, set the text in the controllers
            widget.onRouteSearch(origin, destination);
            
            // Get coordinates for destination
            List<Location> destLocations = await PlacesApi.getLocations(destination);
            if (destLocations.isEmpty) {
              final errorMessage = "I couldn't find that destination. Please try again with a different location.";
              setState(() => _aiResponse = errorMessage);
              _aiAssistant.speak(errorMessage);
              return;
            }
            
            // If origin is not "current location", get its coordinates
            if (origin != "current location") {
              List<Location> originLocations = await PlacesApi.getLocations(origin);
              if (originLocations.isEmpty) {
                final errorMessage = "I couldn't find that starting location. Please try again with a different location.";
                setState(() => _aiResponse = errorMessage);
                _aiAssistant.speak(errorMessage);
                return;
              }
              routeProvider.setOrigin(originLocations[0]);
            }
            
            // Set destination and find routes
            routeProvider.setDestination(destLocations[0]);
            
            // Add a small delay to ensure UI updates
            await Future.delayed(Duration(milliseconds: 500));
            
            // Find routes
            await routeProvider.findRoutes();
          } catch (e) {
            debugPrint('Error in route search: $e');
            final errorMessage = "I had trouble finding that route. Please try again.";
            setState(() => _aiResponse = errorMessage);
            _aiAssistant.speak(errorMessage);
          }
        },
        onJeepneyRouteRequest: (jeepneyCode) {
          // Handle jeepney route request
          widget.onJeepneyRouteRequest(jeepneyCode);
        },
        onAIResponse: (response) {
          setState(() => _aiResponse = response);
          // Scroll to bottom after a short delay to ensure the new content is rendered
          Future.delayed(Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        },
      );
      
      // Initial greeting
      final greeting = "Hello! I'm your AI assistant. How can I help you today?";
      await _aiAssistant.addGreeting(greeting);
    } else {
      debugPrint('Microphone permission denied');
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _aiAssistant.stopListening();
    } else {
      _aiAssistant.startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Assistant',
                style: AppTextStyles.label3,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          // Conversation history
          Flexible(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Display conversation history
                  ..._aiAssistant.conversationHistory.map((interaction) {
                    final List<Widget> messageWidgets = [];
                    
                    // Add user message only if it's not empty
                    if (interaction['user']!.isNotEmpty) {
                      messageWidgets.add(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              interaction['user']!,
                              style: AppTextStyles.label5,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    // Add AI response if it exists
                    if (interaction['assistant']!.isNotEmpty) {
                      if (messageWidgets.isNotEmpty) {
                        messageWidgets.add(const SizedBox(height: 8));
                      }
                      messageWidgets.add(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.navy.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              interaction['assistant']!,
                              style: AppTextStyles.label5,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    if (messageWidgets.isNotEmpty) {
                      messageWidgets.add(const SizedBox(height: 16));
                    }
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: messageWidgets,
                    );
                  }).toList(),
                  // Current transcription if any
                  if (_transcription.isNotEmpty && !_aiAssistant.conversationHistory.any((m) => m['user'] == _transcription))
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _transcription,
                        style: AppTextStyles.label5,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Microphone button
          GestureDetector(
            onTap: _toggleListening,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? AppColors.saffron : AppColors.navy,
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: AppColors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isListening ? 'Tap to stop' : 'Tap to speak',
            style: AppTextStyles.label6,
          ),
        ],
      ),
    );
  }
}
