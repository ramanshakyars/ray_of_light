import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chatResponse.dart';

class Talktolightservice {
  static Future<Map<String, dynamic>> getChatHistory() async {
    try {
      final response = await HttpService.get(PathConfig.getChatHistory);
      if (response != null && response is List) {
        return {'success': true, 'data': response};
      } else {
        return {'success': false, 'message': 'No chat history found'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  static Future<ChatResponse?> postChatHistory(Map<String, dynamic> payload) async {
    try {     
      final response = await HttpService.post(PathConfig.sendChat, payload);
      if (response != null) {
        return ChatResponse.fromJson(response);
      }
      return null;
    } catch (e) {
      print("Error posting chat: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> renameChatHistory(
    String newTitle,
    String chatId,
  ) async {
    try {
      final url = "${PathConfig.renameChat}/$chatId";
      final response = await HttpService.put(url, {"title": newTitle});

      if (response != null && response['id'] != null) {
        return {'success': true, 'data': response};
      } else {
        return {'success': false, 'message': 'Rename failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteChatHistory(String chatId) async {
    try {
      final url = "${PathConfig.deletechat}/$chatId";
      final response = await HttpService.delete(url);

      if (response != null) {
        return {
          'success': true,
          'message': response['message'] ?? 'Chat deleted successfully',
          'data': response,
        };
      } else {
        return {'success': false, 'message': 'Failed to delete chat history'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> getChatHistoryById(String chatId) async {
    try {
      final url = "${PathConfig.getChatHistoryById}/$chatId";
      final response = await HttpService.get(url);
      if (response != null) {
        return {'success': true, 'data': response};
      } else {
        return {'success': false, 'message': 'Chat history Loaded'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> clearMemory(String chatId) async {
    try {
      final url = "${PathConfig.clearChatsMemory}/$chatId";
      final response = await HttpService.post(url,{});
      if (response != null && response['type'] != null) {
        return {'success': true, 'data': response};
      } else {
        return {'success': false, 'message': 'Chat history Loaded'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> getConversationsList() async {
    try {
      final response = await HttpService.get(PathConfig.getConversationsList);
      if (response != null && response['type'] != null) {
        return {'success': true, 'data': response};
      } else {
        return {'success': false, 'message': 'Chat history Loaded'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }
}
