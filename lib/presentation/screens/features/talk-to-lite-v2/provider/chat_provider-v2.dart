import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';

class ChatMessageModel {
  final String text;
  final bool isUser;

  ChatMessageModel({
    required this.text,
    required this.isUser,
  });
}

class ChatProvider extends ChangeNotifier {
  /// ================= STATE =================

  List<dynamic> conversations = [];
  List<ChatMessageModel> messages = [];

  bool isTyping = false;

  String? conversationId;

  final ScrollController scrollController = ScrollController();

  /// ================= LOAD CONVERSATIONS =================

Future<void> loadConversations() async {
  print("🔄 Loading conversations...");

  final result =
      await Talktolightservice.getConversationsList();

  print("📦 API Result: $result");

  if (result['success'] == true &&
      result['data'] != null) {
    conversations = result['data'];
  } else {
    conversations = [];
  }

  notifyListeners();
}

  /// ================= GROUPING =================

  Map<String, List<dynamic>> get groupedConversations {
  final now = DateTime.now();

  final Map<String, List<dynamic>> grouped = {
    "Today": [],
    "Yesterday": [],
    "Earlier": [],
  };

  for (var convo in conversations) {
    final updated = convo['updatedAt'];

    if (updated == null) continue;

    DateTime date;

    if (updated is List) {
      // Handle [year, month, day, hour, minute, second, nano]
      date = DateTime(
        updated[0],
        updated[1],
        updated[2],
        updated.length > 3 ? updated[3] : 0,
        updated.length > 4 ? updated[4] : 0,
        updated.length > 5 ? updated[5] : 0,
      );
    } else if (updated is String) {
      date = DateTime.parse(updated);
    } else {
      continue;
    }

    final today = DateTime(now.year, now.month, now.day);
    final convoDay = DateTime(date.year, date.month, date.day);

    final difference = today.difference(convoDay).inDays;

    if (difference == 0) {
      grouped["Today"]!.add(convo);
    } else if (difference == 1) {
      grouped["Yesterday"]!.add(convo);
    } else {
      grouped["Earlier"]!.add(convo);
    }
  }

  return grouped;
}

  /// ================= LOAD CHAT BY ID =================

  Future<void> loadChatById(String id) async {
    final result =
        await Talktolightservice.getChatHistoryById(id);

    if (result['success'] == true &&
        result['data'] != null) {
      final chatData = result['data'];

      final response =
          chatData['messages'] as List<dynamic>;

      messages.clear();

      messages.addAll(response.map((msg) {
        return ChatMessageModel(
          text: msg['content'],
          isUser: msg['role']
                  .toString()
                  .toUpperCase() ==
              "USER",
        );
      }));

      conversationId = chatData['id'];

      notifyListeners();
      _scrollToBottom();
    }
  }

  /// ================= SEND MESSAGE =================

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    /// Optimistic UI
    messages.add(ChatMessageModel(
      text: text,
      isUser: true,
    ));

    isTyping = true;
    notifyListeners();
    _scrollToBottom();

    try {
      final response =
          await Talktolightservice.postChatHistory({
        "message": text,
        "conversationId": conversationId ?? "",
      });

      if (response != null) {
        messages.add(ChatMessageModel(
          text: response.response,
          isUser: false,
        ));

        conversationId = response.conversationId;

        await loadConversations(); // refresh list
      } else {
        messages.add(ChatMessageModel(
          text: "No response received.",
          isUser: false,
        ));
      }
    } catch (e) {
      messages.add(ChatMessageModel(
        text:
            "Something went wrong. Please check your internet.",
        isUser: false,
      ));
    }

    isTyping = false;
    notifyListeners();
    _scrollToBottom();
  }

  /// ================= RENAME =================

  Future<void> renameConversation(
      String id, String newTitle) async {
    final result =
        await Talktolightservice.renameChatHistory(
            newTitle, id);

    if (result['success'] == true) {
      await loadConversations();
    }
  }

  /// ================= DELETE =================

  Future<void> deleteConversation(String id) async {
    await Talktolightservice.deleteChatHistory(id);

    conversations
        .removeWhere((c) => c['id'] == id);

    notifyListeners();
  }

  /// ================= SCROLL =================

  void _scrollToBottom() {
    Future.delayed(
        const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration:
              const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}