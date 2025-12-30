import 'dart:convert';

import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_model.dart';

class NotificationService {
  Future<List<AppNotification>> fetch(String userId) async {
    final res = await HttpService.get(PathConfig.doCommentOnPost);
    final data = jsonDecode(res.body);
    return (data['notifications'] as List)
        .map((e) => AppNotification.fromJson(e))
        .toList();
  }

  static Future<bool> markRead(List<String> ids) async {
    try {
      final res = await HttpService.put(PathConfig.readNotifications, {
        "notificationIds": ids,
      });
      return res != null;
    } catch (_) {
      return false;
    }
  }
}
