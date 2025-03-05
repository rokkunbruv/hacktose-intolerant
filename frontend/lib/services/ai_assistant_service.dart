import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:tultul/constants/jeepney_codes.dart';

class AIAssistantService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  GenerativeModel? _model;
  bool _isListening = false;
  
  // Add conversation history and current location tracking
  final List<Map<String, String>> _conversationHistory = [];
  static const int _maxHistoryLength = 5; // Keep last 5 interactions
  String? _userCurrentLocation; // Track user's stated location
  
  // Callbacks for UI updates
  final Function(String) onTranscription;
  final Function(bool) onListeningStateChanged;
  final Function(String, String) onRouteSearch;
  final Function(String) onJeepneyRouteRequest;
  final Function(String) onAIResponse; // Add callback for AI responses

  AIAssistantService({
    required this.onTranscription,
    required this.onListeningStateChanged,
    required this.onRouteSearch,
    required this.onJeepneyRouteRequest,
    required this.onAIResponse,
  }) {
    _initializeServices();
  }

  // Add method to update conversation history
  void _updateConversationHistory(String userInput, String assistantResponse) {
    // If there's a pending user message, update its response
    if (_conversationHistory.isNotEmpty && _conversationHistory.last['assistant']!.isEmpty) {
      _conversationHistory.last['assistant'] = assistantResponse;
    } else {
      // Otherwise add a new entry
      _conversationHistory.add({
        'user': userInput,
        'assistant': assistantResponse,
      });
    }
    
    // Keep only the last N interactions
    if (_conversationHistory.length > _maxHistoryLength) {
      _conversationHistory.removeAt(0);
    }
    
    // Notify UI of new AI response
    onAIResponse(assistantResponse);
  }

  // Add getter for conversation history
  List<Map<String, String>> get conversationHistory => _conversationHistory;

  // Add method to get conversation context
  String _getConversationContext() {
    if (_conversationHistory.isEmpty) return '';
    
    String context = 'Previous conversation:\n';
    for (var interaction in _conversationHistory) {
      context += 'User: ${interaction['user']}\n';
      context += 'Assistant: ${interaction['assistant']}\n\n';
    }
    return context;
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
        model: 'gemini-2.0-flash',  // Use the correct model name
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
      
      // Only update the UI, don't add to history (that's handled by _updateConversationHistory)
      onAIResponse(text);
    } catch (e) {
      debugPrint('Error in text-to-speech: $e');
    }
  }

  Future<void> processUserInput(String input) async {
    if (_model == null) {
      await speak("I'm sorry, but I'm not properly configured. Please check the Gemini API key.");
      return;
    }

    // Add the user's input to conversation history first
    _conversationHistory.add({
      'user': input,
      'assistant': ''  // Will be updated when AI responds
    });

    // Check if input contains jeepney route query
    final jeepneyPattern = RegExp(r'(what is|show me|tell me about) (the )?route (of )?(jeepney )?(\d{1,2}[A-Za-z]?)');
    final jeepneyMatch = jeepneyPattern.firstMatch(input.toLowerCase());

    if (jeepneyMatch != null) {
      final jeepneyCode = jeepneyMatch.group(5)?.toUpperCase(); // Extract jeepney code
      if (jeepneyCode != null && jeepCodesList.contains(jeepneyCode)) {
        // Notify the widget to handle the jeepney route request
        onJeepneyRouteRequest(jeepneyCode);
        return;
      } else {
        final errorMessage = "I couldn't find a route for jeepney $jeepneyCode. Please try again with a valid jeepney code.";
        _updateConversationHistory(input, errorMessage);
        await speak(errorMessage);
        return;
      }
    }

    // Check if input contains location-related keywords
    if (input.toLowerCase().contains('route to') || 
        input.toLowerCase().contains('direction') ||
        input.toLowerCase().contains('how to get') ||
        input.toLowerCase().contains('take me to') ||
        input.toLowerCase().contains('to go to') ||
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
      final prompt = '''${_getConversationContext()}Extract the origin and destination locations from this navigation request: "$input"
      If no origin is specified, use "current location".
      Format your response exactly like this example, with no other text:
      Origin: current location
      Destination: SM City Cebu

      Common location mappings to use:
      - "SM City Cebu" -> "SM City Cebu, North Reclamation Area, Cebu City"
      - "UP Cebu" or "University of the Philippines" -> "University of the Philippines Cebu, Gorordo Avenue, Lahug, Cebu City"
      - "Ayala" or "Ayala Center" -> "Ayala Center Cebu, Archbishop Reyes Avenue, Cebu City"
      - "Carbon Market" -> "Carbon Market, Cebu City"
      - "IT Park" -> "Cebu IT Park, Lahug, Cebu City"

      Guidelines for extraction:
      1. Look for location indicators like "from", "to", "take me to", "route to", "directions to", "how to get to"
      2. If origin is not specified, use "current location"
      3. Handle variations in location names (e.g., "SM", "SM Cebu", "SM City" all map to "SM City Cebu")
      4. Extract the most specific location name possible
      5. If multiple locations are mentioned, the last one is usually the destination
      6. Ignore any time-related or other non-location information
      7. Standardize location names using the mappings above

      Use these standardized names in your response.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        final errorMessage = "I had trouble understanding the locations. Could you please try again?";
        _updateConversationHistory(input, errorMessage);
        await speak(errorMessage);
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
        String responseMessage;
        if (origin == "current location") {
          responseMessage = "I'll find directions to $destination from your current location.";
        } else {
          responseMessage = "I'll find directions from $origin to $destination.";
        }
        
        _updateConversationHistory(input, responseMessage);
        await speak(responseMessage);
        
        // Trigger the route search with a slight delay to ensure form fields are populated
        await Future.delayed(Duration(milliseconds: 500));
        onRouteSearch(origin, destination);
      } else {
        final errorMessage = "I couldn't understand where you want to go. Could you please specify your destination more clearly? For example, say 'Take me to SM City Cebu' or 'Route to Ayala Center'.";
        _updateConversationHistory(input, errorMessage);
        await speak(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in route request: $e');
      final errorMessage = "I had trouble understanding the locations. Could you please try again with clearer location names?";
      _updateConversationHistory(input, errorMessage);
      await speak(errorMessage);
    }
  }

  Future<void> _handleGeneralQuery(String input) async {
    try {
      if (input.trim().isEmpty) {
        final errorMessage = "I didn't catch that. Could you please repeat?";
        _updateConversationHistory(input, errorMessage);
        await speak(errorMessage);
        return;
      }

      // Handle common queries without AI
      final lowerInput = input.toLowerCase();
      String responseMessage;
      
      if (lowerInput.contains('hello') || lowerInput.contains('hi ')) {
        responseMessage = "Hello! I'm here to help you find routes or answer your questions.";
      } else if (lowerInput.contains('how are you')) {
        responseMessage = "I'm doing well, thank you! How can I assist you today?";
      } else if (lowerInput.contains('thank you') || lowerInput.contains('thanks')) {
        responseMessage = "You're welcome! Let me know if you need anything else.";
      } else {
        // Check if the query is outside the app's scope
        final isOutOfScope = !lowerInput.contains('route') &&
                            !lowerInput.contains('direction') &&
                            !lowerInput.contains('how to get') &&
                            !lowerInput.contains('take me to') &&
                            !lowerInput.contains('to go to') &&
                            !lowerInput.contains('from') &&
                            !lowerInput.contains('jeepney');

        if (isOutOfScope) {
          responseMessage = "I'm sorry, I cannot help with your request as I am merely an assistant to help you reach your destination. But if you have questions on how to go to a certain location or what is the route of a jeepney, you can always tap on me!";
        } else {
          // For other queries, use Gemini with location extraction
          final prompt = '''${_getConversationContext()}Based on the conversation context and this message: "$input"
          Determine the intent and extract location information. Consider these cases:
          1. User is stating their current location (e.g., "I'm at", "I am in", "I'm currently at")
          2. User is asking for directions (needs both origin and destination)
          3. General query (no location information)

          Format the response in one of these ways:

          For current location statements:
          CURRENT_LOCATION
          Location: [standardized location name]

          For route requests:
          ROUTE_REQUEST
          Origin: [origin]
          Destination: [destination]

          For general queries:
          GENERAL_RESPONSE
          [Your helpful response here]

          Common location mappings to use:
          - "SM City Cebu" -> "SM City Cebu, North Reclamation Area, Cebu City"
          - "UP Cebu" or "University of the Philippines" -> "University of the Philippines Cebu, Gorordo Avenue, Lahug, Cebu City"
          - "Ayala" or "Ayala Center" -> "Ayala Center Cebu, Archbishop Reyes Avenue, Cebu City"
          - "Carbon Market" -> "Carbon Market, Cebu City"
          - "IT Park" -> "Cebu IT Park, Lahug, Cebu City"''';
          
          final content = [Content.text(prompt)];
          final response = await _model!.generateContent(content);
          final responseText = response.text;
          
          if (responseText != null && responseText.isNotEmpty) {
            final lines = responseText.split('\n');
            final responseType = lines[0].trim();
            
            if (responseType == 'CURRENT_LOCATION') {
              // User is stating their current location
              responseMessage = "I'm not sure where you are. Could you please be more specific?"; // Default message
              for (var line in lines) {
                if (line.startsWith('Location:')) {
                  final location = line.substring(9).trim();
                  _userCurrentLocation = location; // Store the location
                  responseMessage = "I understand you're at $location. Where would you like to go?";
                  break;
                }
              }
            } else if (responseType == 'ROUTE_REQUEST') {
              String origin = _userCurrentLocation ?? "current location";
              String destination = "";
              responseMessage = "I couldn't understand your route request. Could you please specify where you want to go?"; // Default message
              
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
              
              if (destination.isNotEmpty) {
                // We have both origin and destination, proceed with route search
                if (origin == "current location") {
                  responseMessage = "I'll find directions to $destination from your current location.";
                } else {
                  responseMessage = "I'll find directions from $origin to $destination.";
                }
                
                _updateConversationHistory(input, responseMessage);
                await speak(responseMessage);
                
                // Trigger route search
                await Future.delayed(Duration(milliseconds: 500));
                onRouteSearch(origin, destination);
                return;
              }
            } else {
              // General response
              responseMessage = responseText
                  .replaceAll('GENERAL_RESPONSE\n', '')
                  .replaceAll(RegExp(r'\*\*|\*|`|#|>'), '')
                  .replaceAll(RegExp(r'\n{2,}'), ' ')
                  .trim();
            }
          } else {
            responseMessage = "I'm not sure about that. Could you please rephrase your question?";
          }
        }
      }
      
      _updateConversationHistory(input, responseMessage);
      await speak(responseMessage);
    } catch (e) {
      debugPrint('Error in general query: $e');
      final errorMessage = "I'm having trouble processing that request. Could you try asking in a different way?";
      _updateConversationHistory(input, errorMessage);
      await speak(errorMessage);
    }
  }

  // Add method to add greeting
  Future<void> addGreeting(String greeting) async {
    _conversationHistory.add({
      'user': '',
      'assistant': greeting
    });
    onAIResponse(greeting);
    await speak(greeting);
  }

  bool get isListening => _isListening;
}
