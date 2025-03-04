import 'package:flutter/material.dart';
import '../services/ai_assistant_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../provider/route_finder_provider.dart';
import '../api/google_maps_api/places_api.dart';
import '../classes/location/location.dart';

class AIAssistantWidget extends StatefulWidget {
  final Function(String, String) onRouteSearch;

  const AIAssistantWidget({
    Key? key,
    required this.onRouteSearch,
  }) : super(key: key);

  @override
  State<AIAssistantWidget> createState() => _AIAssistantWidgetState();
}

class _AIAssistantWidgetState extends State<AIAssistantWidget> {
  late AIAssistantService _aiAssistant;
  bool _isListening = false;
  String _transcription = '';

  @override
  void initState() {
    super.initState();
    _initializeAIAssistant();
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
              _aiAssistant.speak("I couldn't find that destination. Please try again with a different location.");
              return;
            }
            
            // If origin is not "current location", get its coordinates
            if (origin != "current location") {
              List<Location> originLocations = await PlacesApi.getLocations(origin);
              if (originLocations.isEmpty) {
                _aiAssistant.speak("I couldn't find that starting location. Please try again with a different location.");
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
            _aiAssistant.speak("I had trouble finding that route. Please try again.");
          }
        },
      );
      
      // Initial greeting
      _aiAssistant.speak("Hello! I'm your AI assistant. How can I help you today?");
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
          // Transcription display
          if (_transcription.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _transcription,
                style: const TextStyle(fontSize: 16),
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
                color: _isListening ? Colors.green : Colors.blue,
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isListening ? 'Tap to stop' : 'Tap to speak',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
