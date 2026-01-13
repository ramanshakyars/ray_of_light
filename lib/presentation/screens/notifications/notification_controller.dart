import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rayoflite/presentation/screens/notifications/notification-service.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends ChangeNotifier {
  List<AppNotification> notifications = [];
  bool loading = false;
  final NotificationService _service = NotificationService();
  NotificationController() {
    _listenConnectivity();
  }

  /// 🔹 CONNECTIVITY LISTENER
  void _listenConnectivity() {
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        _syncPendingReads();
      }
    });
  }

  /// 🔹 MARK READ OFFLINE SAFE
  Future<void> markReadOffline(List<String> ids, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    // store pending ids
    final existing = prefs.getStringList("pending_read_ids") ?? [];
    existing.addAll(ids);
    await prefs.setStringList("pending_read_ids", existing);
    await prefs.setBool("pending_read_sync", true);
    await prefs.setString("pending_read_user", userId);
  }

  /// 🔹 SYNC WHEN INTERNET BACK
  Future<void> _syncPendingReads() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("pending_read_sync") == true) {
      final ids = prefs.getStringList("pending_read_ids") ?? [];
      final userId = prefs.getString("pending_read_user") ?? "";
      if (ids.isNotEmpty) {
        final ok = await NotificationService.markRead(userId, ids);
        if (ok) {
          prefs.remove("pending_read_ids");
          prefs.remove("pending_read_user");
          prefs.remove("pending_read_sync");
        }
      } else {
        prefs.remove("pending_read_sync");
      }
    }
  }

  Future<void> load(String userId) async {
    loading = true;
    notifyListeners();

    try {
      notifications = await _service.fetch(userId);
    } catch (e) {
      debugPrint("Notification load error: $e");
      notifications = [];
    }

    loading = false;
    notifyListeners();
  }
}
