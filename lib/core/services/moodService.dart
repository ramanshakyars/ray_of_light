// mood_service.dart
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/MoodRequest.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/UserMood.dart';

class MoodService {
  static Future<Map<String, dynamic>> setMood(MoodRequest request) async {
    try {
      final data = await HttpService.post(PathConfig.setMood,request.toJson());
      
      if (data != null && data['type'] != null) {
        return {
          'success': true,
          'message': 'Mood updated successfully',
          'data': UserMood.fromJson(data),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update mood',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong: $e'};
    }
  }

  static Future<Map<String, dynamic>> getCurrentMood() async {
    try {
      final raw = await HttpService.get(PathConfig.getCurrentMood); // Define this
      if (raw != null && raw['type'] != null) {
        return {
          'success': true,
          'data': UserMood.fromJson(raw),
        };
      } else {
        return {
          'success': false,
          'message': 'No mood data available',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception in getCurrentMood(): $e'};
    }
  }
}