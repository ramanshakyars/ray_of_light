import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';

/// 🔹 BACKGROUND HANDLER (TOP LEVEL - VERY IMPORTANT)
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  print("Background push: ${message.notification?.title}");
}

class PushService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // 1. Request Permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // 2. Background Message Handler (Register this early)
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // 3. Get the correct token based on Platform
    String? token;
    try {
      if (Platform.isIOS) {
        // IMPORTANT: AWS SNS needs the raw APNS token for iOS Sandbox/Production
        token = await _messaging.getAPNSToken();
        print("iOS APNS Token: $token");
      } else {
        token = await _messaging.getToken();
        print("Android FCM Token: $token");
      }

      if (token != null) {
        await _registerTokenWithServer(token);
      }
    } catch (e) {
      print("Error getting device token: $e");
    }

    // 4. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground push received: ${message.notification?.title}");
      // If you want to show a local notification or alert while the app is open,
      // you would trigger flutter_local_notifications here.
    });

    // 5. Handle notification click when app is in background but NOT terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        "Notification clicked from background: ${message.notification?.title}",
      );
      // Navigate to a specific screen if needed
    });

    // 6. Handle notification click when app was completely terminated
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print(
        "App launched from terminated state via notification: ${initialMessage.notification?.title}",
      );
    }

    // 7. Listen for token refreshes
    _messaging.onTokenRefresh.listen((newToken) async {
      print("Token refreshed: $newToken");
      await _registerTokenWithServer(newToken);
    });
  }

  static Future<void> _registerTokenWithServer(String token) async {
    try {
      final user = await LocalStorageService.getUser();
      final String userId =
          user?['id'] ?? user?['_id'] ?? user?['userId'] ?? '';
      final deviceId =
          'flutter-${Platform.operatingSystem}-${DateTime.now().millisecondsSinceEpoch}';
      await HttpService.postRaw(PathConfig.registerDeviceToken, {
        "userId": userId ?? "",
        "deviceId": deviceId,
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "token": token,
      });
      print('Registered push token with server');
    } catch (e) {
      print('Failed to register push token: $e');
    }
  }

  static Future<String?> getToken() async => await _messaging.getToken();
}
