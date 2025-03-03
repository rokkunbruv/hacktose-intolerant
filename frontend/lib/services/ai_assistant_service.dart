import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIAssistantService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  GenerativeModel? _model;
  bool _isListening = false;
  
  // Callbacks for UI updates
  final Function(String) onTranscription;
  final Function(bool) onListeningStateChanged;
  final Function(String, String) onRouteSearch;

  AIAssistantService({
    required this.onTranscription,
    required this.onListeningStateChanged,
    required this.onRouteSearch,
  }) {
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Initialize Speech to Text
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done') {
          _isListening = false;
          onListeningStateChanged(false);
        }
      },
    );

    if (!available) {
      debugPrint('Speech recognition not available');
      return;
    }

    // Initialize Text to Speech
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);

    // Initialize Gemini AI
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null) {
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
    }
  }

  Future<void> startListening() async {
    if (!_isListening && await _speechToText.initialize()) {
      await _speechToText.listen(
        onResult: (result) {
          String text = result.recognizedWords;
          onTranscription(text);
          if (result.finalResult) {
            processUserInput(text);
          }
        },
      );
      _isListening = true;
      onListeningStateChanged(true);
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
      onListeningStateChanged(false);
    }
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> processUserInput(String input) async {
    if (_model == null) {
      speak("I'm sorry, but I'm not properly configured. Please check the Gemini API key.");
      return;
    }

    // Check if input contains location-related keywords
    if (input.toLowerCase().contains('route') || 
        input.toLowerCase().contains('direction') ||
        input.toLowerCase().contains('how to get') ||
        input.toLowerCase().contains('take me to')) {
      await _handleRouteRequest(input);
    } else {
      await _handleGeneralQuery(input);
    }
  }

  Future<void> _handleRouteRequest(String input) async {
    // Prompt Gemini to extract locations
    final prompt = '''Extract the origin and destination locations from this request: "$input". 
    Return only two locations in JSON format like this: {"origin": "location1", "destination": "location2"}. 
    If origin is not specified, return "current location" as origin.''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      final responseText = response.text;

      // Parse the JSON response to extract locations
      if (responseText != null && responseText.contains('{') && responseText.contains('}')) {
        final jsonStr = responseText.substring(
          responseText.indexOf('{'),
          responseText.lastIndexOf('}') + 1
        );
        
        // Validate locations using Google Places (implementation needed)
        await speak("I'll help you find the route. Let me validate those locations.");
        
        // Call the route search callback with the extracted locations
        onRouteSearch(
          jsonStr.contains('"origin"') ? jsonStr.split('"origin":"')[1].split('"')[1] : "current location",
          jsonStr.contains('"destination"') ? jsonStr.split('"destination":"')[1].split('"')[1] : ""
        );
        
        await speak("I've found the route for you.");
      } else {
        await speak("I couldn't understand the locations. Could you please try again?");
      }
    } catch (e) {
      await speak("I'm sorry, I encountered an error processing your request.");
      debugPrint('Error processing route request: $e');
    }
  }

  Future<void> _handleGeneralQuery(String input) async {
    try {
      final content = [Content.text(input)];
      final response = await _model!.generateContent(content);
      final responseText = response.text;
      
      if (responseText != null) {
        await speak(responseText);
      } else {
        await speak("I'm sorry, I couldn't generate a response.");
      }
    } catch (e) {
      await speak("I'm sorry, I encountered an error processing your request.");
      debugPrint('Error processing general query: $e');
    }
  }

  bool get isListening => _isListening;
}
