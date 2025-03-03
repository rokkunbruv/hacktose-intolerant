import 'package:flutter/material.dart';
import '../services/ai_assistant_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
        onRouteSearch: widget.onRouteSearch,
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
