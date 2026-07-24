import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chat-history.dart';
import 'chat_message.dart';
import 'input_area.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;

  const ChatScreen({super.key, this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FlutterTts _tts = FlutterTts();
  bool _isLoading = false;
  bool isNewChat = false;
  late AnimationController _starController;
  String? conversationId;

  @override
  void initState() {
    super.initState();
    _initTTS();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (widget.chatId != null && widget.chatId!.isNotEmpty) {
      getChatById(widget.chatId!);
    }
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
  }

  clearMemory({String? chatId}) async {
    final result = await Talktolightservice.clearMemory(chatId!);
    if (result['success'] == true && result['data'] != null) {
      MessageService.showSuccess(context, 'Memory cleared successfully');
    }
  }

  getChatById(String chatId) async {
    final result = await Talktolightservice.getChatHistoryById(chatId);
    if (result['success'] == true && result['data'] != null) {
      final chatData = result['data'];
      final response = chatData['messages'] as List<dynamic>;
      setState(() {
        _messages.clear();
        _messages.addAll(
          response.map(
            (msg) => ChatMessage(
              text: msg['content'] ?? '',
              isUser: msg['role'].toString().toUpperCase() == 'USER',
              animate: false,
              timestamp: _parseTimestamp(msg['timestamp'] ?? msg['createdAt'] ?? msg['time']),
            ),
          ),
        );
        conversationId = chatData['id'];
      });
    }
  }

  DateTime? _parseTimestamp(dynamic ts) {
    if (ts == null) return null;
    if (ts is List) {
      return DateTime(
        ts[0],
        ts[1],
        ts[2],
        ts.length > 3 ? ts[3] : 0,
        ts.length > 4 ? ts[4] : 0,
        ts.length > 5 ? ts[5] : 0,
        ts.length > 6 ? (ts[6] ~/ 1000) : 0,
      );
    } else if (ts is String) {
      return DateTime.tryParse(ts);
    }
    return null;
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text.trim();
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true, timestamp: DateTime.now()));
      _isLoading = true;
      // if (_messages.length == 1) {
      _starController.repeat();
      // }
    });

    try {
      final chatRequest = {
        "message": message,
        "conversationId": conversationId ?? "",
      };
      final  chatResponse = await Talktolightservice.postChatHistory(
        chatRequest,
      );
      if (chatResponse != null) {
        setState(() {
          _messages.add(
            ChatMessage(
              // text: chatResponse.response,
              // isUser: false,
              animate: true,
              // this code for suggestion for feature which we developed
              text:
                  chatResponse.response +
                  (chatResponse.suggestion?.type == "BREATHING"
                      ? "\n\nWould you like to try a short breathing exercise?"
                      : chatResponse.suggestion?.type == "WALK"
                      ? "\n\nWould you like to go for a walk and set a goal?"
                      : chatResponse.suggestion?.type == "JOURNAL"
                      ? "\n\nWould you like to write in your journal?"
                      : ""),
              isUser: false,
              timestamp: chatResponse.timestamp,
              extraWidget: () {
                switch (chatResponse.suggestion?.type) {
                  case "BREATHING":
                    return TextButton(
                      onPressed: () {
                        GoRouter.of(context).push(
                          '${RouteNames.mainApp}/${RouteNames.breathingExercise}',
                        );
                      },
                      child: Text(
                        "Start Breathing Exercise",
                        style: TextStyle(
                          color: AppColors.getTextPrimaryColor(
                            Provider.of<ThemeProvider>(
                              context,
                              listen: false,
                            ).isDarkMode,
                          ),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  case "WALK":
                    return TextButton(
                      onPressed: () {
                        GoRouter.of(context).push(
                          '${RouteNames.mainApp}/${RouteNames.goalTracker}',
                        );
                      },
                      child: Text(
                        "Set Walk wish",
                        style: TextStyle(
                          color: AppColors.getTextPrimaryColor(
                            Provider.of<ThemeProvider>(
                              context,
                              listen: false,
                            ).isDarkMode,
                          ),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  case "JOURNAL":
                    return TextButton(
                      onPressed: () {
                        GoRouter.of(
                          context,
                        ).push('${RouteNames.mainApp}/${RouteNames.junerlism}');
                      },
                      child: Text(
                        "Try Nest",
                        style: TextStyle(
                          color: AppColors.getTextPrimaryColor(
                            Provider.of<ThemeProvider>(
                              context,
                              listen: false,
                            ).isDarkMode,
                          ),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  case "NONE":
                  default:
                    return null;
                }
              }(),
            ),
          );
          conversationId = chatResponse.conversationId;
        });
      } else {
        setState(() {
          _messages.add(
            ChatMessage(text: "No response from server", isUser: false, timestamp: DateTime.now()),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(text: "Oops! Error: ${e.toString()}", isUser: false, timestamp: DateTime.now()),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
        _starController.stop();
      });
    }
  }

  Widget _buildWelcomeMessage(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.wb_sunny,
          //   size: 60,
          //   color: AppColors.getIconColor(isDarkMode),
          // ),
          Image.asset(
            "assets/talk-to-light.png",
            height: 120,
            width: 120,
            color: AppColors.getIconColor(isDarkMode),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                "Ask me anything\nand I'll do my best to help you.",
                style: TextStyle(
                  color: AppColors.getTextPrimaryColor(isDarkMode),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _starController,
            child: Icon(
              Icons.auto_awesome,
              size: 60,
              color: AppColors.getTextPrimaryColor(isDarkMode),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Thinking...",
            style: TextStyle(color: AppColors.getTextPrimaryColor(isDarkMode)),
          ),
        ],
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      drawer: const ChatHistory(),
      appBar: AppBar(
        title: Text(
          'Talk to Light',
          style: TextStyle(color: AppColors.getTextPrimaryColor(isDarkMode)),
        ),
        backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
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
            icon: Icon(
              Icons.refresh,
              color: AppColors.getIconColor(isDarkMode),
            ),
            tooltip: "Clear Memory",
            onPressed: () {
              clearMemory();
            },
          ),
        ],
      ),
      body: Container(
        color: AppColors.getAppBackgroundColor(isDarkMode),
        child: Column(
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
                      if (_isLoading &&
                          _messages.isNotEmpty &&
                          index == _messages.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              RotationTransition(
                                turns: _starController,
                                child: Image.asset(
                                  "assets/talk-to-light.png",
                                  height: 50,
                                  width: 50,
                                  color: AppColors.getIconColor(isDarkMode),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Light is typing...",
                                style: TextStyle(
                                  color: AppColors.getTextPrimaryColor(
                                    isDarkMode,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return _messages[index];
                    },
                  ),
                  if (_messages.isEmpty && !_isLoading)
                    _buildWelcomeMessage(isDarkMode),
                  if (_messages.isEmpty && _isLoading)
                    _buildLoadingIndicator(isDarkMode),
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
      ),
    );
  }
}
