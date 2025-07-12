import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
// import 'package:rayoflite/presentation/screens/features/talk-to-light.dart';
import 'chat_message.dart';
import 'typing_indicator.dart';
import 'input_area.dart';
import 'api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

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

    // Simulate API delay
    await Future.delayed(Duration(seconds: 2));

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
        title: Text('Talk to Lite', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 243, 246, 255),
        elevation: 10,
        automaticallyImplyLeading: false, // This removes the default back arrow
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Add your menu functionality here
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'), // Replace with your logo path
            onPressed: () {
              GoRouter.of(context).push(RouteNames.home);
            },
          ),
        ],
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
