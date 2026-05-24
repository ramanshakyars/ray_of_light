import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_message_model.dart';

class PaginatedMessagesResponse {
  final String conversationId;
  final String title;
  final List<ChatMessageModel> messages;
  final String? nextCursor;
  final bool hasMore;
  final int? totalMessages;
  final int? pageSize;

  PaginatedMessagesResponse({
    required this.conversationId,
    required this.title,
    required this.messages,
    this.nextCursor,
    required this.hasMore,
    this.totalMessages,
    this.pageSize,
  });

  factory PaginatedMessagesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedMessagesResponse(
      conversationId: json["conversationId"] ?? "",
      title: json["title"] ?? "Conversation",
      messages: ((json["messages"] ?? []) as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ChatMessageModel.fromJson(e))
          .toList(),
      // Coerce nextCursor to string when possible (backend may return
      // non-string empty structures).
      nextCursor: json["nextCursor"] != null ? json["nextCursor"].toString() : null,
      // Normalize hasMore to a bool (may be returned as string/number).
      hasMore: json["hasMore"] is bool
          ? json["hasMore"]
          : (json["hasMore"] != null && json["hasMore"].toString().toLowerCase() == 'true'),
      totalMessages: json["totalMessages"],
      pageSize: json["pageSize"],
    );
  }
}