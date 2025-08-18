import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chatResponse.dart';

class Talktolightservice {
  static Future<Map<String, dynamic>> getChatHistory() async {
    try {
      final response = await HttpService.get(PathConfig.getChatHistory);

      print("🔎 API Raw Response: $response"); // सिर्फ debug के लिए

      if (response != null && response is List) {
        return {
          'success': true,
          'data': response, // ✅ direct list return
        };
      } else {
        return {'success': false, 'message': 'No chat history found'};
      }
    } catch (e) {
      print("❌ Error in getChatHistory: $e");
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  static Future<ChatResponse?> postChatHistory(String message) async {
    try {
      final payload = {"message": message};
      final response = await HttpService.post(PathConfig.sendChat, payload);
      //   print(response);
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
    body,
    String chatId,
  ) async {
    try {
      final url = "${PathConfig.renameChat}/$chatId";
      final respose = await HttpService.put(url, body);
      if (respose != null && respose['type'] != null) {
        return {'success': true, 'data': respose};
      } else {
        return {'success': false, 'message': 'Chat history Loaded'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
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
      if (response != null && response['type'] != null) {
        return {'success': true, 'data': response};
      } else {
        return {'success': false, 'message': 'Chat history Loaded'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  static Future<Map<String, dynamic>> clearMemory(body) async {
    try {
      final response = await HttpService.post(
        PathConfig.clearChatsMemory,
        body,
      );
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
