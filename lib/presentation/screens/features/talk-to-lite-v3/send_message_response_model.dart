class SendMessageResponseModel {
  final String conversationId;

  final String response;

  final String? emotionalTone;

  SendMessageResponseModel({
    required this.conversationId,
    required this.response,
    this.emotionalTone,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMessageResponseModel(
      conversationId: json["conversationId"] ?? "",

      response: json["response"] ?? "",

      emotionalTone: json["emotionalTone"],
    );
  }
}
