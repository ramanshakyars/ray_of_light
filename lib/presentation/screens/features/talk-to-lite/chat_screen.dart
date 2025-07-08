import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'chat_message.dart';
import 'typing_indicator.dart';
import 'input_area.dart';
import 'api_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FlutterTts _tts = FlutterTts();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text;
    _textController.clear();

    // Add user message
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });

    try {
      // Call your AI model API
      final response = await ApiService.sendMessage(message);

      // Add AI response
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });

      // Read response aloud
      await _tts.speak(response);
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Sorry, I encountered an error. Please try again.",
            isUser: false,
          ),
        );
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text('AI Assistant', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF16213E),
        elevation: 10,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return _messages[index];
                } else {
                  return TypingIndicator();
                }
              },
            ),
          ),
          InputArea(
            controller: _textController,
            onSend: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
