
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'YOUR_API_ENDPOINT';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': message}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['response'];
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      throw Exception('API Error: ${e.toString()}');
    }
  }
}