class ChatResponse {
  final String conversationId;
  final String response;
  final String emotionalTone;
  final DateTime timestamp;
  final ChatSuggestion? suggestion;
  final bool moderationFlagged;

  ChatResponse({
    required this.conversationId,
    required this.response,
    required this.emotionalTone,
    required this.timestamp,
    this.suggestion,
    required this.moderationFlagged,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversationId: json['conversationId'] ?? '',
      response: json['response'] ?? '',
      emotionalTone: json['emotionalTone'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      suggestion: json['suggestion'] != null
          ? ChatSuggestion.fromJson(json['suggestion'])
          : null,
      moderationFlagged: json['moderationFlagged'] ?? false,
    );
  }
}

class ChatSuggestion {
  final String type;
  final String message;
  final bool actionRequired;

  ChatSuggestion({
    required this.type,
    required this.message,
    required this.actionRequired,
  });

  factory ChatSuggestion.fromJson(Map<String, dynamic> json) {
    return ChatSuggestion(
      type: json['type'] ?? "NONE",
      message: json['message'] ?? '',
      actionRequired: json['actionRequired'] ?? false,
    );
  }
}
