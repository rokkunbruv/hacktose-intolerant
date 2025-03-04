import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
        model: 'gemini-1.5-pro-002',  
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
    try {
      await _flutterTts.stop(); // Stop any ongoing speech
      await _flutterTts.awaitSpeakCompletion(true); // Wait for speech to complete
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('Error in text-to-speech: $e');
    }
  }

  Future<void> processUserInput(String input) async {
    if (_model == null) {
      await speak("I'm sorry, but I'm not properly configured. Please check the Gemini API key.");
      return;
    }

    // Check if input contains location-related keywords
    if (input.toLowerCase().contains('route to') || 
        input.toLowerCase().contains('direction') ||
        input.toLowerCase().contains('how to get') ||
        input.toLowerCase().contains('take me to') ||
        input.toLowerCase().contains('from') && input.toLowerCase().contains('to')) {
      await _handleRouteRequest(input);
    } else {
      await _handleGeneralQuery(input);
    }
  }

  Future<void> _handleRouteRequest(String input) async {
    try {
      // First, acknowledge that we're processing a route request
      await speak("I'll help you find that route.");

      // Use Gemini to extract locations
      final prompt = '''Extract the origin and destination locations from this navigation request: "$input"
      If no origin is specified, use "current location".
      Format your response exactly like this example, with no other text:
      Origin: Parkmall (or use "current location" if user did not specify an origin location)
      Destination: SM City Cebu

      Common location mappings to use:
      - "SM City Cebu" -> "SM City Cebu, North Reclamation Area, Cebu City"
      - "UP Cebu" or "University of the Philippines" -> "University of the Philippines Cebu, Gorordo Avenue, Lahug, Cebu City"
      - "Ayala" or "Ayala Center" -> "Ayala Center Cebu, Archbishop Reyes Avenue, Cebu City"
      - "Carbon Market" -> "Carbon Market, Cebu City"
      - "IT Park" -> "Cebu IT Park, Lahug, Cebu City"
      - "SM Seaside" -> "SM Seaside, Cebu South Coastal Rd, Antuwanga, Cebu City"

      Important Notes:
      - If the user does not specify an origin, use "current location".
      - The destination must always match the location specified by the user. Do not assume or default to "SM City Cebu".
      ''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      final responseText = response.text;
      print(responseText);

      if (responseText == null || responseText.isEmpty) {
        await speak("I had trouble understanding the locations. Could you please try again?");
        return;
      }

      // Parse the AI response
      final lines = responseText.split('\n');
      String origin = "current location";
      String destination = "";

      for (var line in lines) {
        if (line.startsWith('Origin:')) {
          final extractedOrigin = line.substring(7).trim();
          if (extractedOrigin != "current location") {
            origin = extractedOrigin;
          }
        } else if (line.startsWith('Destination:')) {
          destination = line.substring(12).trim();
        }
      }

      // Validate and proceed
      if (destination.isNotEmpty) {
        if (origin == "current location") {
          await speak("I'll find directions to $destination from your current location.");
        } else {
          await speak("I'll find directions from $origin to $destination.");
        }
        
        // Trigger the route search with a slight delay to ensure form fields are populated
        await Future.delayed(Duration(milliseconds: 500));
        onRouteSearch(origin, destination);
      } else {
        await speak("I couldn't understand where you want to go. Could you please specify your destination more clearly? For example, say 'Take me to SM City Cebu' or 'Route to Ayala Center'.");
      }
    } catch (e) {
      debugPrint('Error in route request: $e');
      await speak("I had trouble understanding the locations. Could you please try again with clearer location names?");
    }
  }

  Future<void> _handleGeneralQuery(String input) async {
    try {
      if (input.trim().isEmpty) {
        await speak("I didn't catch that. Could you please repeat?");
        return;
      }

      // Handle common queries without using AI
      final lowerInput = input.toLowerCase();
      if (lowerInput.contains('hello') || lowerInput.contains('hi ')) {
        await speak("Hello! I'm here to help you find routes or answer your questions.");
        return;
      }
      if (lowerInput.contains('how are you')) {
        await speak("I'm doing well, thank you! How can I assist you today?");
        return;
      }
      if (lowerInput.contains('thank you') || lowerInput.contains('thanks')) {
        await speak("You're welcome! Let me know if you need anything else.");
        return;
      }
      
      // For other queries, use Gemini
      final prompt = '''Act as a helpful AI assistant. Provide a natural, conversational response to: "$input"
      Keep it concise and friendly. If unsure, ask for clarification.
      If it's about locations, provide helpful navigation-related information.''';
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      final responseText = response.text;
      
      if (responseText != null && responseText.isNotEmpty) {
        String cleanResponse = responseText
            .replaceAll(RegExp(r'\*\*|\*|`|#|>'), '')
            .replaceAll(RegExp(r'\n{2,}'), ' ')
            .trim();
        await speak(cleanResponse);
      } else {
        await speak("I'm not sure about that. Could you please rephrase your question?");
      }
    } catch (e) {
      debugPrint('Error in general query: $e');
      await speak("I'm having trouble processing that request. Could you try asking in a different way?");
    }
  }

  bool get isListening => _isListening;
}
