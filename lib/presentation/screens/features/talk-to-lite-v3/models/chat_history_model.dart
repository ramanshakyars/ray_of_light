class ChatHistoryModel {
  final String conversationId;

  final String title;

  final String? lastMessage;

  final int? messageCount;

  final String? updatedAt;

  ChatHistoryModel({
    required this.conversationId,
    required this.title,
    this.lastMessage,
    this.messageCount,
    this.updatedAt,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      conversationId: (json["conversationId"] ?? json["id"] ?? "").toString(),

      title: (json["title"] ?? "Conversation").toString(),

      lastMessage: json["lastMessage"] != null ? json["lastMessage"].toString() : (json["preview"] != null ? json["preview"].toString() : null),

      messageCount: json["messageCount"],

      updatedAt: json["updatedAt"] != null ? json["updatedAt"].toString() : null,
    );
  }
}
