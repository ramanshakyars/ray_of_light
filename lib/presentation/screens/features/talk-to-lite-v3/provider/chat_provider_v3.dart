import 'package:flutter/material.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_history_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_message_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/services/ChatServiceV3.dart';

class ChatProviderV3 extends ChangeNotifier {
  final ChatServiceV3 service;
  final String? initialChatId;

  ChatProviderV3({required this.service, this.initialChatId}) {
    scrollController.addListener(_onScroll);
  }

  final ScrollController scrollController = ScrollController();

  List<ChatMessageModel> messages = [];
  List<ChatHistoryModel> history = [];

  bool isTyping = false;
  bool isLoading = true; // Start in loading state to prevent flash of welcome state
  bool isHistoryLoading = false;
  bool isLoadingMoreMessages = false;

  String? activeConversationId;
  String? nextMessagesCursor;
  bool hasMoreMessages = false;

  Future<void> initializeChat() async {
    isLoading = true;
    notifyListeners();

    try {
      if (initialChatId != null && initialChatId!.isNotEmpty) {
        await _fetchConversationData(initialChatId!);
        await _fetchHistoryData();
      } else {
        await _fetchHistoryData();
        if (history.isNotEmpty) {
          final latestChatId = history.first.conversationId;
          if (latestChatId.isNotEmpty) {
            await _fetchConversationData(latestChatId);
          }
        }
      }
    } catch (e) {
      debugPrint("INITIALIZE CHAT ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
      jumpToBottomInstant();
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels <= 100) {
      if (hasMoreMessages && !isLoadingMoreMessages) {
        loadMoreMessages();
      }
    }
  }

  Future<void> _fetchHistoryData() async {
    try {
      history = await service.getHistory();
      history.sort((a, b) {
        final aTime = a.updatedAt != null ? DateTime.tryParse(a.updatedAt!) : null;
        final bTime = b.updatedAt != null ? DateTime.tryParse(b.updatedAt!) : null;

        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
    } catch (e) {
      debugPrint("FETCH HISTORY ERROR: $e");
    }
  }

  Future<void> _fetchConversationData(String conversationId) async {
    try {
      final response = await service.getPaginatedMessages(
        conversationId: conversationId,
        cursor: null,
        pageSize: 20,
      );

      activeConversationId = response.conversationId;
      messages = response.messages;
      nextMessagesCursor = response.nextCursor;
      hasMoreMessages = response.hasMore;
    } catch (e) {
      debugPrint("FETCH CONVERSATION ERROR: $e");
    }
  }

  Future<void> loadConversation(String conversationId) async {
    isLoading = true;
    notifyListeners();

    await _fetchConversationData(conversationId);

    isLoading = false;
    notifyListeners();

    jumpToBottomInstant();
  }

  Future<void> loadMoreMessages() async {
    if (activeConversationId == null) return;
    if (isLoadingMoreMessages) return;
    if (!hasMoreMessages) return;

    isLoadingMoreMessages = true;
    notifyListeners();

    // Capture scroll offset BEFORE we prepend messages so we can
    // restore the visible position afterwards (WhatsApp-style).
    final prevOffset =
        scrollController.hasClients ? scrollController.offset : 0.0;
    final prevMax = scrollController.hasClients
        ? scrollController.position.maxScrollExtent
        : 0.0;

    try {
      final response = await service.getPaginatedMessages(
        conversationId: activeConversationId!,
        cursor: nextMessagesCursor,
        pageSize: 20,
      );

      messages.insertAll(0, response.messages);
      nextMessagesCursor = response.nextCursor;
      hasMoreMessages = response.hasMore;

      notifyListeners();

      // After the list rebuilds, jump so the previously visible
      // content stays in the same screen position.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;
        final newMax = scrollController.position.maxScrollExtent;
        final addedHeight = newMax - prevMax;
        scrollController.jumpTo(prevOffset + addedHeight);
      });
    } catch (e) {
      debugPrint("LOAD MORE ERROR: $e");
    }

    isLoadingMoreMessages = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    text = text.trim();

    // Capitalize first letter
    if (text.isNotEmpty) {
      text = text[0].toUpperCase() + text.substring(1);
    }

    messages.add(
      ChatMessageModel(
        content: text,
        isUser: true,
        timestamp: DateTime.now().toUtc().toIso8601String(),
      ),
    );

    isTyping = true;

    notifyListeners();

    scrollToBottom();

    try {
      final response = await service.sendMessage(
        message: text,
        conversationId: activeConversationId,
      );

      activeConversationId = response.conversationId;

      messages.add(
        ChatMessageModel(
          content: "",
          isUser: false,
          timestamp: DateTime.now().toUtc().toIso8601String(),
        ),
      );

      notifyListeners();

      await _animateAiResponse(response.response);

      await loadHistory(forceRefresh: true);
    } catch (e) {
      debugPrint("SEND MESSAGE ERROR: $e");

      messages.add(
        ChatMessageModel(
          content: "Something went wrong. Please check your internet.",
          isUser: false,
        ),
      );
    }

    isTyping = false;

    notifyListeners();

    scrollToBottom();
  }

  Future<void> _animateAiResponse(String fullText) async {
    final index = messages.length - 1;

    String currentText = "";

    for (int i = 0; i < fullText.length; i++) {
      currentText += fullText[i];

      messages[index] = ChatMessageModel(
        content: currentText,
        isUser: false,
        timestamp: messages[index].timestamp,
      );

      notifyListeners();

      // smooth scroll while AI types (throttle to every few chars)
      if (i % 3 == 0) smoothScrollToBottom(duration: const Duration(milliseconds: 220));

      await Future.delayed(const Duration(milliseconds: 10));
    }

    // ensure fully at bottom when done
    jumpToBottomInstant();
  }

  Future<void> loadHistory({bool forceRefresh = false}) async {
    if (isHistoryLoading) return;

    if (history.isNotEmpty && !forceRefresh) return;

    isHistoryLoading = true;

    notifyListeners();

    try {
      history = await service.getHistory();

      // Sort history by updatedAt (most recent first) when possible
      history.sort((a, b) {
        final aTime = a.updatedAt != null ? DateTime.tryParse(a.updatedAt!) : null;
        final bTime = b.updatedAt != null ? DateTime.tryParse(b.updatedAt!) : null;

        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
    } catch (e) {
      debugPrint("HISTORY ERROR: $e");
    }

    isHistoryLoading = false;

    notifyListeners();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  /// Scroll helpers
  void jumpToBottomInstant() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      try {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } catch (_) {}
    });
  }

  void smoothScrollToBottom({Duration duration = const Duration(milliseconds: 220)}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final target = scrollController.position.maxScrollExtent;
      final current = scrollController.offset;

      // Only animate if there's meaningful distance
      if ((target - current).abs() > 2) {
        scrollController.animateTo(target, duration: duration, curve: Curves.easeOut);
      }
    });
  }

  void clearChat() {
    messages.clear();
    activeConversationId = null;
    nextMessagesCursor = null;
    hasMoreMessages = false;

    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
