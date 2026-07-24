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
    DateTime parsedTimestamp;

    if (json['timestamp'] != null) {
      if (json['timestamp'] is List) {
        final ts = json['timestamp'] as List;
        parsedTimestamp = DateTime(
          ts[0],
          ts[1],
          ts[2],
          ts.length > 3 ? ts[3] : 0,
          ts.length > 4 ? ts[4] : 0,
          ts.length > 5 ? ts[5] : 0,
          ts.length > 6 ? (ts[6] ~/ 1000) : 0,
        );
      } else if (json['timestamp'] is String) {
        parsedTimestamp = DateTime.tryParse(json['timestamp']) ?? DateTime.now();
      } else {
        parsedTimestamp = DateTime.now();
      }
    } else if (json['lastMessageAt'] != null) {
      if (json['lastMessageAt'] is List) {
        final ts = json['lastMessageAt'] as List;
        parsedTimestamp = DateTime(
          ts[0],
          ts[1],
          ts[2],
          ts.length > 3 ? ts[3] : 0,
          ts.length > 4 ? ts[4] : 0,
          ts.length > 5 ? ts[5] : 0,
          ts.length > 6 ? (ts[6] ~/ 1000) : 0,
        );
      } else if (json['lastMessageAt'] is String) {
        parsedTimestamp = DateTime.tryParse(json['lastMessageAt']) ?? DateTime.now();
      } else {
        parsedTimestamp = DateTime.now();
      }
    } else {
      parsedTimestamp = DateTime.now();
    }

    return ChatResponse(
      conversationId: json['conversationId'] ?? '',
      response: json['response'] ?? '',
      emotionalTone: json['emotionalTone'] ?? '',
      timestamp: parsedTimestamp,
      suggestion:
          json['suggestion'] != null
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
