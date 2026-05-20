import 'package:flutter/material.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_history_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_message_model.dart';

import '../services/chat_service_v3.dart';

class ChatProviderV3 extends ChangeNotifier {

  final ChatServiceV3 service;

  final String? initialChatId;

  ChatProviderV3({
    required this.service,
    this.initialChatId,
  });

  final ScrollController scrollController =
      ScrollController();

  List<ChatMessageModel> messages = [];

  List<ChatHistoryModel> history = [];

  bool isTyping = false;

  bool isLoading = false;

  bool isHistoryLoading = false;

  String? activeConversationId;

  Future<void> initializeChat() async {

    if (initialChatId == null ||
        initialChatId!.isEmpty) {

      await loadHistory();

      return;
    }

    await loadConversation(
      initialChatId!,
    );

    await loadHistory();
  }

  Future<void> loadConversation(
      String id,
  ) async {

    isLoading = true;

    notifyListeners();

    try {

      final response =
          await service.getConversationById(
              id);

      activeConversationId =
          response.conversationId;

      messages =
          response.messages;

      scrollToBottom();

    } catch (e) {

      debugPrint(e.toString());
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> sendMessage(
      String text,
  ) async {

    if (text.trim().isEmpty) return;

    /// First letter capital
    text = text.trim();

    text =
        text[0].toUpperCase() +
        text.substring(1);

    /// User message
    messages.add(

      ChatMessageModel(

        content: text,

        isUser: true,
      ),
    );

    isTyping = true;

    notifyListeners();

    scrollToBottom();

    try {

      final response =
          await service.sendMessage(

        message: text,

        conversationId:
            activeConversationId,
      );

      /// Empty AI message
      messages.add(

        ChatMessageModel(

          content: "",

          isUser: false,
        ),
      );

      notifyListeners();

      /// Animate AI response
      await _animateAiResponse(
        response.response,
      );

      activeConversationId =
          response.conversationId;

      await loadHistory(
        forceRefresh: true,
      );

    } catch (e) {

      debugPrint(e.toString());

      messages.add(

        ChatMessageModel(

          content:
              "Something went wrong. Please check your internet.",

          isUser: false,
        ),
      );
    }

    isTyping = false;

    notifyListeners();

    scrollToBottom();
  }

  /// =========================
  /// AI Typing Animation
  /// =========================

  Future<void> _animateAiResponse(
      String fullText,
  ) async {

    int index =
        messages.length - 1;

    String current = "";

    for (int i = 0;
        i < fullText.length;
        i++) {

      current += fullText[i];

      messages[index] =
          ChatMessageModel(

        content: current,

        isUser: false,
      );

      notifyListeners();

      scrollToBottom();

      await Future.delayed(

        Duration(
          milliseconds:
              8 + (i % 4) * 6,
        ),
      );
    }
  }

  Future<void> loadHistory({
    bool forceRefresh = false,
  }) async {

    if (isHistoryLoading) return;

    if (history.isNotEmpty &&
        !forceRefresh) return;

    isHistoryLoading = true;

    notifyListeners();

    try {

      history =
          await service.getHistory();

    } catch (e) {

      debugPrint(e.toString());
    }

    isHistoryLoading = false;

    notifyListeners();
  }

  void scrollToBottom() {

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (scrollController.hasClients) {

        scrollController.animateTo(

          scrollController
              .position
              .maxScrollExtent,

          duration:
              const Duration(
            milliseconds: 300,
          ),

          curve:
              Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {

    scrollController.dispose();

    super.dispose();
  }
}