import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BACKGROUND HANDLER — MUST be a top-level function (not a class method)
// ─────────────────────────────────────────────────────────────────────────────

/// Handles FCM messages when the app is in the background or terminated.
/// Firebase calls this in a separate isolate — no UI access here.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  // Background messages are displayed automatically by FCM.
  // Parse and store data if needed for when the user taps the notification.
  print('[PushService] Background push received: ${message.notification?.title}');
}

// ─────────────────────────────────────────────────────────────────────────────
// PushService
// ─────────────────────────────────────────────────────────────────────────────

/// Local notifications plugin — shared instance used for foreground display.
final FlutterLocalNotificationsPlugin _localPlugin =
    FlutterLocalNotificationsPlugin();

/// Android notification channel for high-priority push notifications.
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'rayoflight_push',               // channel id
  'Ray of Light Notifications',   // channel name
  description: 'Real-time push notifications from Ray of Light',
  importance: Importance.high,
  playSound: true,
);

class PushService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // ──────────────────────────────────────────────────────────────────────────
  // Init — call this AFTER the user is logged in
  // ──────────────────────────────────────────────────────────────────────────

  static Future<void> init() async {
    // 1. Initialize local notifications (needed for foreground display)
    await _initLocalNotifications();

    // 2. Request push notification permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('[PushService] Notification permission granted');
    } else {
      print('[PushService] Notification permission not granted: ${settings.authorizationStatus}');
    }

    // 3. Register background handler BEFORE getting the token
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // 4. Get push token and register with backend
    await _fetchAndRegisterToken();

    // 5. Foreground message handler — show local notification
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 6. Background → foreground notification tap handler
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 7. Terminated state — app was opened from a notification tap
    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('[PushService] App opened from terminated state via notification: '
          '${initialMessage.notification?.title}');
      // Delay navigation until the widget tree is ready
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationTap(initialMessage);
      });
    }

    // 8. Listen for FCM token refreshes and re-register with backend
    _messaging.onTokenRefresh.listen((newToken) async {
      print('[PushService] FCM token refreshed');
      await _registerTokenWithServer(newToken);
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Logout — deregister device
  // ──────────────────────────────────────────────────────────────────────────

  /// Call this BEFORE clearing local storage on logout.
  /// Marks the device as inactive on the backend so no more pushes are sent.
  static Future<void> deregisterDevice() async {
    try {
      final user = await LocalStorageService.getUser();
      final String userId = _extractUserId(user);
      final String deviceId = await _getStableDeviceId();

      if (userId.isEmpty || deviceId.isEmpty) return;

      await HttpService.delete(
        '${PathConfig.registerDeviceToken}/$deviceId?userId=$userId',
      );
      print('[PushService] Device deregistered: $deviceId');
    } catch (e) {
      print('[PushService] Device deregistration failed (non-critical): $e');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Token management
  // ──────────────────────────────────────────────────────────────────────────

  static Future<void> _fetchAndRegisterToken() async {
    try {
      String? token;

      if (Platform.isIOS) {
        // iOS: get APNs token (required by AWS SNS APNS platform)
        token = await _messaging.getAPNSToken();
        print('[PushService] iOS APNs token: ${token?.substring(0, 10)}...');
      } else {
        // Android: get FCM token
        token = await _messaging.getToken();
        print('[PushService] Android FCM token: ${token?.substring(0, 10)}...');
      }

      if (token != null && token.isNotEmpty) {
        await _registerTokenWithServer(token);
      } else {
        print('[PushService] No push token available (normal on iOS simulator)');
      }
    } catch (e) {
      print('[PushService] Error getting push token: $e');
    }
  }

  static Future<void> _registerTokenWithServer(String token) async {
    try {
      final user = await LocalStorageService.getUser();
      final String userId = _extractUserId(user);
      final String deviceId = await _getStableDeviceId();

      if (userId.isEmpty) {
        print('[PushService] Skipping token registration — user not logged in yet');
        return;
      }

      await HttpService.postRaw(PathConfig.registerDeviceToken, {
        'userId': userId,
        'deviceId': deviceId,
        'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
        'token': token,
        'appVersion': '3.3.18',  // TODO: read from package_info_plus when added
      });

      print('[PushService] Token registered with backend for userId=$userId');
    } catch (e) {
      print('[PushService] Failed to register token with backend: $e');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Message handlers
  // ──────────────────────────────────────────────────────────────────────────

  /// Foreground message — app is open. Show a local notification so the user
  /// is aware (FCM does NOT show a heads-up notification when app is in foreground).
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    print('[PushService] Foreground push: ${notification.title}');

    final String deepLink = message.data['deepLink'] ?? '';

    await _localPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/notification_icon',  // custom notification icon
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: deepLink.isNotEmpty ? deepLink : null,
    );
  }

  /// Handle notification tap — navigate to the deepLink from the data payload.
  static void _handleNotificationTap(RemoteMessage message) {
    final String deepLink = message.data['deepLink'] ?? '';
    final String screen = message.data['screen'] ?? '';

    String? route;
    if (deepLink.isNotEmpty) {
      route = deepLink;
    } else if (screen.isNotEmpty) {
      // Fallback: map screen names to routes
      route = _screenToRoute(screen);
    }

    if (route != null && route.isNotEmpty) {
      print('[PushService] Navigating to: $route');
      NotificationNavigationService.navigate(route);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Local notifications init
  // ──────────────────────────────────────────────────────────────────────────

  static Future<void> _initLocalNotifications() async {
    // Create the Android notification channel
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);

    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/notification_icon'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,  // We request separately via firebase_messaging
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          print('[PushService] Local notification tapped → $payload');
          NotificationNavigationService.navigate(payload);
        }
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────────────

  static String _extractUserId(Map<String, dynamic>? user) {
    if (user == null) return '';
    return (user['id'] ?? user['_id'] ?? user['userId'] ?? '').toString();
  }

  /// Returns a stable device identifier.
  /// Persisted in SharedPreferences — survives token refreshes but not reinstalls.
  static Future<String> _getStableDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('push_device_id');
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = 'flutter-${Platform.operatingSystem}-${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('push_device_id', deviceId);
    }
    return deviceId;
  }

  /// Map data payload screen names to GoRouter routes.
  static String? _screenToRoute(String screen) {
    const Map<String, String> screenRoutes = {
      'home': '/main/home',
      'talk_to_light': '/main/talk-to-light',
      'goal_tracker': '/main/goal-tracker',
      'journalism': '/main/junerlism',
      'breathing': '/main/breathing-exercise',
      'profile': '/main/profile',
    };
    return screenRoutes[screen];
  }

  /// Get current FCM token (utility for debugging).
  static Future<String?> getToken() async => await _messaging.getToken();
}
