import 'chat_message_model.dart';

class ActiveConversationModel {
  final String conversationId;

  final String? title;

  final List<ChatMessageModel> messages;

  ActiveConversationModel({
    required this.conversationId,
    required this.messages,
    this.title,
  });

  factory ActiveConversationModel.fromJson(Map<String, dynamic> json) {
    return ActiveConversationModel(
      conversationId: json["conversationId"] ?? json["id"] ?? "",

      title: json["title"],

      messages:
          ((json["messages"] ?? []) as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => ChatMessageModel.fromJson(e))
              .toList(),
    );
  }
}
