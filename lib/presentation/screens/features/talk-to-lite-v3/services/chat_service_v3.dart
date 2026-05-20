import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/active_conversation_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_history_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/send_message_response_model.dart';

class ChatServiceV3 {
  Future<ActiveConversationModel> getConversationById(String id) async {
    final result = await Talktolightservice.getChatHistoryById(id);

    if (result['success'] == true && result['data'] != null) {
      return ActiveConversationModel.fromJson(result['data']);
    }

    throw Exception(result['message'] ?? 'Unable to load conversation');
  }

  Future<SendMessageResponseModel> sendMessage({
    required String message,
    String? conversationId,
  }) async {
    final response = await Talktolightservice.postChatHistory({
      "message": message,
      "conversationId": conversationId ?? "",
    });

    if (response == null) {
      throw Exception('No response received');
    }

    return SendMessageResponseModel(
      conversationId: response.conversationId,
      response: response.response,
      emotionalTone: response.emotionalTone,
    );
  }

  Future<List<ChatHistoryModel>> getHistory() async {
    final result = await Talktolightservice.getConversationsList();

    if (result['success'] != true || result['data'] is! List) {
      return [];
    }

    final data = result['data'] as List;

    return data
        .whereType<Map<String, dynamic>>()
        .map(ChatHistoryModel.fromJson)
        .toList();
  }
}
