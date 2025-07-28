import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';

class GoalService {
  static Future<Map<String, dynamic>> addGoal(
    Map<String, dynamic> goalData,
  ) async {
    try {
      final uri = Uri.parse(PathConfig.createGoal);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(goalData),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Goal added successfully',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to add goal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong: $e'};
    }
  }

  static Future<Map<String, dynamic>> getGoals() async {
    try {
      final raw = await HttpService.get(PathConfig.getGoals);
      if (raw is List<dynamic>) {
        return {'success': true, 'data': raw};
      } else {
        return {
          'success': false,
          'message': 'Unexpected response format: ${raw.runtimeType}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception in getGoals(): $e'};
    }
  }
}
