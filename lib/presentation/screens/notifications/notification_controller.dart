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
  Future<void> markReadOffline(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("pending_read_sync", true);
  }

  /// 🔹 SYNC WHEN INTERNET BACK
  Future<void> _syncPendingReads() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("pending_read_sync") == true) {
      await NotificationService.markRead([]);
      prefs.remove("pending_read_sync");
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
