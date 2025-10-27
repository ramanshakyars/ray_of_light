import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
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
    final result = await Talktolightservice.clearMemory({
      "chatId": chatId ?? "default",
    });
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
              text: msg['content'],
              isUser: msg['role'].toString().toUpperCase() == 'USER',
              animate: false,
            ),
          ),
        );
        conversationId = chatData['id'];
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text.trim();
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
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
      final chatResponse = await Talktolightservice.postChatHistory(
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
              extraWidget: () {
                switch (chatResponse.suggestion?.type) {
                  case "BREATHING":
                    return TextButton(
                      onPressed: () {
                        GoRouter.of(context).push(
                          '${RouteNames.mainApp}/${RouteNames.breathingExercise}',
                        );
                      },
                      child: const Text(
                        "Start Breathing Exercise",
                        style: TextStyle(
                          color: AppColors.textPrimaryColor,
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
                      child: const Text(
                        "Set Walk wish",
                        style: TextStyle(
                          color: AppColors.textPrimaryColor,
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
                      child: const Text(
                        "Try Nest",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
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
          const Icon(
            Icons.wb_sunny,
            size: 60,
            color: AppColors.iconBlackColor,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              // color: AppColors.appBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // const Text(
                //   "Welcome to Talk to Light!",
                //   style: TextStyle(
                //     color: Color.fromARGB(255, 0, 0, 0),
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 12),
                const Text(
                  "Ask me anything and I'll do my best to help you. ",
                  style: TextStyle(
                    color: Color.fromARGB(179, 0, 0, 0),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                // const SizedBox(height: 16),
                // _buildQuestionSuggestion("Hi, I was thinking about you"),
                // _buildQuestionSuggestion("What were you doing?"),
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
              color: AppColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Thinking...",
            style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 18),
          ),
        ],
      ),
    );
  }

  // this is for the suggestions cards

  // Widget _buildQuestionSuggestion(String question) {
  //   return GestureDetector(
  //     onTap: () {
  //       _textController.text = question;
  //       _sendMessage();
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 6),
  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  //       decoration: BoxDecoration(
  //         color: AppColors.appBackgroundColor,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3)),
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 0, 0, 0), size: 16),
  //           const SizedBox(width: 8),
  //           Text(question, style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0))),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _tts.stop();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.appBackgroundColor,
      drawer: const ChatHistory(),
      appBar: AppBar(
        title: const Text(
          'Talk to Light',
          style: TextStyle(color: AppColors.textPrimaryColor),
        ),
        // backgroundColor: AppColors.appBackgroundColor,
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
            icon: const Icon(Icons.refresh, color: AppColors.iconBlackColor),
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
                    if (_isLoading &&
                        _messages.isNotEmpty &&
                        index == _messages.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            RotationTransition(
                              turns: _starController,
                              child: const Icon(
                                Icons.wb_sunny,
                                size: 35,
                                color: Color.fromARGB(255, 234, 198, 152),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Light is typing...",
                              style: TextStyle(
                                color: AppColors.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return _messages[index];
                  },
                ),
                if (_messages.isEmpty && !_isLoading) _buildWelcomeMessage(),
                if (_messages.isEmpty && _isLoading) _buildLoadingIndicator(),
              ],
            ),
          ),

          // new chat is working but hide here

          // SafeArea(
          //   child:
          //       _messages.isNotEmpty
          //           ? Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Align(
          //               alignment: Alignment.center,
          //               child: ElevatedButton.icon(
          //                 style: ElevatedButton.styleFrom(
          //                   backgroundColor: const Color.fromARGB(255, 255, 236, 204),
          //                   shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(12),
          //                   ),
          //                   padding: const EdgeInsets.symmetric(
          //                     vertical: 10,
          //                     horizontal: 16,
          //                   ),
          //                 ),
          //                 onPressed: () {
          //                   setState(() {
          //                     _messages.clear();
          //                     _isLoading = false;
          //                     _textController.clear();
          //                     isNewChat = false; // reset flag
          //                   });
          //                 },
          //                 icon: const Icon(
          //                   Icons.add_comment,
          //                   color: Color.fromARGB(255, 0, 0, 0),
          //                   size: 20,
          //                 ),
          //                 label: const Text(
          //                   "New Chat",
          //                   style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
          //                 ),
          //               ),
          //             ),
          //           )
          //           : const SizedBox.shrink(),
          // ),

          /// Input area
          InputArea(
            controller: _textController,
            onSend: _sendMessage,
            isLoading: _isLoading,
          ),

          /// Bottom New Chat button
        ],
      ),
    );
  }
}
