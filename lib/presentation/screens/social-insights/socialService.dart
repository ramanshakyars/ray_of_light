import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';

class SocialService {
  static Future<Map<String, dynamic>> postInsight(
    Map<String, dynamic> goalData,
  ) async {
    try {
      final data = await HttpService.post(PathConfig.createGoal, goalData);
      if (data['id'] != null) {
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

  static Future<Map<String, dynamic>> getPostInsights() async {
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

  static Future<Map<String, dynamic>> updateGoalStatus(String url) async {
    try {
      final raw = await HttpService.put(url, {});

      if (raw is! Map) {
        return {
          'success': false,
          'message': 'Unexpected response format: ${raw.runtimeType}',
        };
      }

      return {'success': true, 'data': raw};
    } catch (e) {
      return {
        'success': false,
        'message': 'Exception in updateGoalStatus(): $e',
      };
    }
  }
}
