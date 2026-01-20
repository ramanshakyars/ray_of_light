import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class VoiceInputScreen extends StatefulWidget {
  final bool isDarkMode;
  const VoiceInputScreen({super.key, required this.isDarkMode});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Listening...";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _startListening();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
          if (val.finalResult) {
            // Auto-close and return text when user stops speaking
            Future.delayed(const Duration(milliseconds: 800), () {
              Navigator.pop(context, _text);
            });
          }
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isListening ? "I'm listening..." : "Tap the mic",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 60),
          AvatarGlow(
            animate: _isListening,
            glowColor: Colors.blue,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: Material(
              elevation: 8.0,
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 40,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          IconButton(
            icon: const Icon(Icons.close, size: 30, color: Colors.redAccent),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}