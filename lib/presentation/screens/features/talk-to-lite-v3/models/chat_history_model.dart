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
      conversationId: json["conversationId"] ?? json["id"] ?? "",

      title: json["title"] ?? "Conversation",

      lastMessage: json["lastMessage"] ?? json["preview"],

      messageCount: json["messageCount"],

      updatedAt: json["updatedAt"]?.toString(),
    );
  }
}
