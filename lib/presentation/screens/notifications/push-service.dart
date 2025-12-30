import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// 🔹 BACKGROUND HANDLER (TOP LEVEL - VERY IMPORTANT)
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background push: ${message.notification?.title}");
}

class PushService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  /// 🔹 CALL THIS FROM main()
  static Future<void> init() async {
    // iOS permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Background handler register
    FirebaseMessaging.onBackgroundMessage(
        firebaseBackgroundHandler);

    // Foreground listener
    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground push: ${message.notification?.title}");
    });
  }

  /// 🔹 TOKEN FETCH
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// 🔹 TOKEN REFRESH (IMPORTANT)
  static void onTokenRefresh(Function(String) callback) {
    _messaging.onTokenRefresh.listen(callback);
  }
}
