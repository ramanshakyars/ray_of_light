import 'dart:convert';

import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_model.dart';

/// HTTP client for the notification backend API.
class NotificationService {

  /// Fetch paginated notifications for a user.
  Future<List<AppNotification>> fetch(
    String userId, {
    int page = 0,
    int size = 20,
  }) async {
    final url =
        '${PathConfig.getNotifications}?userId=$userId&page=$page&size=$size';
    final res = await HttpService.get(url);
    final data = jsonDecode(res.body);
    return (data['notifications'] as List)
        .map((e) => AppNotification.fromJson(e))
        .toList();
  }

  /// Get unread notification count for a user.
  static Future<int> getUnreadCount(String userId) async {
    try {
      final url = '${PathConfig.notificationUnreadCount}?userId=$userId';
      final res = await HttpService.get(url);
      final data = jsonDecode(res.body);
      return data['count'] ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Mark specific notification IDs as read.
  static Future<bool> markRead(String userId, List<String> ids) async {
    try {
      final url = '${PathConfig.readNotifications}?userId=$userId';
      final res = await HttpService.put(url, {'notificationIds': ids});
      return res != null;
    } catch (_) {
      return false;
    }
  }

  /// Mark all notifications as read for a user.
  static Future<bool> markAllRead(String userId) async {
    try {
      final url = '${PathConfig.markAllReadNotifications}?userId=$userId';
      final res = await HttpService.put(url, {});
      return res != null;
    } catch (_) {
      return false;
    }
  }
}
