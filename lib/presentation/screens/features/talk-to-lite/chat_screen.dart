import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chat-history.dart';
import 'chat_message.dart';
import 'input_area.dart';
import 'api_service.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FlutterTts _tts = FlutterTts();
  bool _isLoading = false;
  late AnimationController _starController;
  List<ChatHistory> _chatHistory = [];

  @override
  void initState() {
    super.initState();
    _initTTS();
    _starController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat();
    _loadChatHistory();
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _loadChatHistory() async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _chatHistory = ChatHistory.simulatedHistory;
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF16213E),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0F3460),
            ),
            child: Center(
              child: Text(
                'Chat History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final history = _chatHistory[index];
                return ListTile(
                  leading: Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
                  title: Text(
                    history.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    history.lastMessage,
                    style: TextStyle(color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${history.timestamp.hour}:${history.timestamp.minute}',
                    style: TextStyle(color: Colors.white54),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackbar('Loading conversation ${history.id}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text;
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
      _starController.repeat();
    });

    // Update chat history if this is the first message
    if (_messages.length == 1) {
      setState(() {
        _chatHistory.insert(0, ChatHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'New Chat ${_chatHistory.length + 1}',
          timestamp: DateTime.now(),
          lastMessage: message,
        ));
      });
    }

    // Simulate API delay (1-3 seconds)
    final randomDelay = Duration(milliseconds: 1000 + Random().nextInt(2000));
    await Future.delayed(randomDelay);

    try {
      final responses = [
        "Great question! Here's what I think about '$message'...",
        "Interesting! Regarding '$message', my analysis suggests...",
        "I'd be happy to help! For '$message', consider this...",
        "Hmm, '$message' is a fascinating topic. My thoughts...",
      ];
      final response = responses[Random().nextInt(responses.length)];

      setState(() => _messages.add(ChatMessage(text: response, isUser: false)));
      // await _tts.speak(response);
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(text: "⚠️ Oops! Error: ${e.toString()}", isUser: false),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
        _starController.stop();
      });
    }
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 60, color: Colors.blueAccent),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  "Welcome to Talk to Light!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Ask me anything and I'll do my best to help you. "
                  "Here are some things you can ask:",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _buildQuestionSuggestion("Hi, I was thinking about you"),
                _buildQuestionSuggestion("What were you doing?"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _starController,
            child: Icon(Icons.auto_awesome, size: 60, color: Colors.blueAccent),
          ),
          SizedBox(height: 16),
          Text(
            "Thinking...",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSuggestion(String question) {
    return GestureDetector(
      onTap: () {
        _textController.text = question;
        _sendMessage();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFF0F3460),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withValues()),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_forward, color: Colors.blueAccent, size: 16),
            SizedBox(width: 8),
            Text(question, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text('Talk to Light', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 27, 39, 74),
        elevation: 10,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed: () {
              GoRouter.of(context).push('${RouteNames.mainApp}/${RouteNames.home}');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_messages.isNotEmpty)
                  ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _messages[index],
                  ),
                if (_messages.isEmpty && !_isLoading) _buildWelcomeMessage(),
                if (_isLoading) _buildLoadingIndicator(),
              ],
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