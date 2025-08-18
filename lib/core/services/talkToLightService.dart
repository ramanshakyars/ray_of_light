import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chatResponse.dart';

class Talktolightservice {
  static Future<Map<String, dynamic>> getChatHistory() async {
    try {
      final respose = await HttpService.get(PathConfig.getChatHistory);
      if (respose != null && respose['type'] != null) {
        return {'success': true, 'data': respose};
      } else {
        return {'success': false, 'message': 'Chat history Loaded'};
      }
    } catch (e) {
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
}
