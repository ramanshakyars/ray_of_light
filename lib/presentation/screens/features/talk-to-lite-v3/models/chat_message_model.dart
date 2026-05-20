class ChatMessageModel {
  final String content;

  final bool isUser;

  final String? timestamp;

  ChatMessageModel({
    required this.content,
    required this.isUser,
    this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      content: json["content"] ?? "",

      isUser: json["role"] == "USER",

      timestamp: json["timestamp"],
    );
  }
}
