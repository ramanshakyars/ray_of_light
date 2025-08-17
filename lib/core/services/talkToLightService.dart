import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';

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

  static Future<Map<String, dynamic>> postChatHistory(Map<String, dynamic> data) async {
    try {
      final respose = await HttpService.post(PathConfig.sendChat, data);
      if (respose != null && respose['type'] != null) {
        return {'success': true, 'data': respose};
      } else {
        return {'success': false, 'message': 'Chat history Loaded'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  
}
