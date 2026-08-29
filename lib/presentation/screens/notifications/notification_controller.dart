import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rayoflite/presentation/screens/notifications/notification-service.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State management for the notification screen.
/// Handles loading, offline read-marking, unread badge count, and mark-all-read.
class NotificationController extends ChangeNotifier {
  List<AppNotification> notifications = [];
  bool loading = false;
  int unreadCount = 0;

  final NotificationService _service = NotificationService();

  NotificationController() {
    _listenConnectivity();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Load
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> load(String userId) async {
    loading = true;
    notifyListeners();

    try {
      notifications = await _service.fetch(userId);
      unreadCount = notifications.where((n) => !n.isRead).length;
    } catch (e) {
      debugPrint('[NotificationController] Load error: $e');
      notifications = [];
      unreadCount = 0;
    }

    loading = false;
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Mark read — offline safe
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> markReadOffline(List<String> ids, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('pending_read_ids') ?? [];
    existing.addAll(ids);
    await prefs.setStringList('pending_read_ids', existing);
    await prefs.setBool('pending_read_sync', true);
    await prefs.setString('pending_read_user', userId);

    // Optimistically update local state
    for (var n in notifications) {
      if (ids.contains(n.id) && !n.isRead) {
        unreadCount = (unreadCount - 1).clamp(0, 9999);
      }
    }
    notifyListeners();
  }

  /// Mark all notifications as read.
  Future<void> markAllRead(String userId) async {
    try {
      await NotificationService.markAllRead(userId);
      unreadCount = 0;
      // Refresh list
      await load(userId);
    } catch (e) {
      debugPrint('[NotificationController] Mark all read error: $e');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Connectivity sync
  // ──────────────────────────────────────────────────────────────────────────

  void _listenConnectivity() {
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        _syncPendingReads();
      }
    });
  }

  Future<void> _syncPendingReads() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('pending_read_sync') == true) {
      final ids = prefs.getStringList('pending_read_ids') ?? [];
      final userId = prefs.getString('pending_read_user') ?? '';
      if (ids.isNotEmpty) {
        final ok = await NotificationService.markRead(userId, ids);
        if (ok) {
          prefs.remove('pending_read_ids');
          prefs.remove('pending_read_user');
          prefs.remove('pending_read_sync');
        }
      } else {
        prefs.remove('pending_read_sync');
      }
    }
  }
}
