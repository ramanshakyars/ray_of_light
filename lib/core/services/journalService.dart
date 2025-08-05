import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';

class JournalService {
  static Future<Map<String, dynamic>> getJournalsHistory() async {
    try {
      final raw = await HttpService.get(PathConfig.getJournals);
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
