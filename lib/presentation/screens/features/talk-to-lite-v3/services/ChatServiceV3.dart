import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/PaginatedMessagesResponse.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/active_conversation_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_message_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_history_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/send_message_response_model.dart';

class ChatServiceV3 {
  Future<ActiveConversationModel> getConversationById(String id) async {
    final result = await Talktolightservice.getChatHistoryById(id);
    if (result['success'] == true && result['data'] != null) {
      final data = result['data'];

      // Some API responses return the conversation as a List with a single
      // item; handle both Map and List shapes defensively.
      if (data is Map<String, dynamic>) {
        return ActiveConversationModel.fromJson(data);
      } else if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        return ActiveConversationModel.fromJson(data.first as Map<String, dynamic>);
      } else {
        throw Exception('Unexpected conversation payload');
      }
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

  /// NEW: Get paginated messages for a conversation
  Future<PaginatedMessagesResponse> getPaginatedMessages({
    required String conversationId,
    String? cursor,
    int pageSize = 10,
  }) async {
    try {
      final queryParams = {
        'pageSize': pageSize.toString(),
        if (cursor != null) 'cursor': cursor,
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final url = 
        '/api/v1/chat/paginated/conversation/$conversationId/messages?$queryString';
      
      final result = await Talktolightservice.get(url);

      if (result['success'] == true && result['data'] != null) {
        final data = result['data'];

        // If the API returns a Map, parse normally. If it returns a List
        // (messages only), wrap into a response object.
        if (data is Map<String, dynamic>) {
          return PaginatedMessagesResponse.fromJson(data);
        } else if (data is List) {
          final messages = data
              .whereType<Map<String, dynamic>>()
              .map((e) => ChatMessageModel.fromJson(e))
              .toList();

          return PaginatedMessagesResponse(
            conversationId: conversationId,
            title: 'Conversation',
            messages: messages,
            nextCursor: null,
            hasMore: false,
            totalMessages: messages.length,
            pageSize: pageSize,
          );
        }
      }

      throw Exception(result['message'] ?? 'Unable to load messages');
    } catch (e) {
      throw Exception('Failed to load paginated messages: $e');
    }
  }
}