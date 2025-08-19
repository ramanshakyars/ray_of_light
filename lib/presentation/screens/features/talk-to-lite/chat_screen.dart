import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chat-history.dart';
import 'chat_message.dart';
import 'input_area.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _initTTS();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
  }

  clearMemory({String? chatId}) async {
    final result = await Talktolightservice.clearMemory({
      "chatId": chatId ?? "default",
    });
    if (result['success'] == true && result['data'] != null) {
      MessageService.showSuccess(context, 'Memory cleared successfully');
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text.trim();
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;

      // ✅ Agar pehla hi message hai to star loader chalu karna
      if (_messages.length == 1) {
        _starController.repeat();
      }
    });

    try {
      final chatResponse = await Talktolightservice.postChatHistory(message);
      if (chatResponse != null) {
        setState(() {
          _messages.add(
            ChatMessage(
              text:
                  chatResponse.response +
                  (chatResponse.suggestion?.type == "BREATHING"
                      ? "\n\nWould you like to try a short breathing exercise?"
                      : ""),
              isUser: false,
              extraWidget:
                  chatResponse.suggestion?.type == "BREATHING"
                      ? TextButton(
                        onPressed: () {
                          GoRouter.of(
                            context,
                          ).push(RouteNames.breathingExercise);
                        },
                        child: const Text(
                          "👉 Start Breathing Exercise",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                      : null,
            ),
          );
        });
      } else {
        setState(() {
          _messages.add(
            const ChatMessage(text: "No response from server", isUser: false),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(text: "Oops! Error: ${e.toString()}", isUser: false),
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
          const Icon(Icons.auto_awesome, size: 60, color: Colors.blueAccent),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "Welcome to Talk to Light!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Ask me anything and I'll do my best to help you. "
                  "Here are some things you can ask:",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
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
            child: const Icon(
              Icons.auto_awesome,
              size: 60,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
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
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F3460),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_forward, color: Colors.blueAccent, size: 16),
            const SizedBox(width: 8),
            Text(question, style: const TextStyle(color: Colors.white70)),
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
      backgroundColor: const Color(0xFF1A1A2E),
      drawer: const ChatHistory(),
      appBar: AppBar(
        title: const Text(
          'Talk to Light',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 39, 74),
        elevation: 10,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed: () {
              GoRouter.of(
                context,
              ).push('${RouteNames.mainApp}/${RouteNames.home}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Clear Memory",
            onPressed: () {
              clearMemory();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount:
                      _messages.length +
                      ((_isLoading && _messages.isNotEmpty) ? 1 : 0),
                  itemBuilder: (context, index) {
                    // 👇 Small loader only after first message
                    if (_isLoading &&
                        _messages.isNotEmpty &&
                        index == _messages.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            CircularProgressIndicator(strokeWidth: 2),
                            SizedBox(width: 10),
                            Text(
                              "Light is typing...",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      );
                    }

                    return _messages[index];
                  },
                ),

                // 👇 Welcome screen only if nothing asked yet
                if (_messages.isEmpty && !_isLoading) _buildWelcomeMessage(),

                // 👇 Big loader only on very first question
                if (_messages.isEmpty && _isLoading) _buildLoadingIndicator(),
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
