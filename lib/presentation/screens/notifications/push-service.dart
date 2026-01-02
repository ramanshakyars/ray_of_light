import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';

/// 🔹 BACKGROUND HANDLER (TOP LEVEL - VERY IMPORTANT)
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background push: ${message.notification?.title}");
}

class PushService {
   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground push: ${message.notification?.title}");
    });

    // get initial token and send to backend
    String? token = await _messaging.getToken();
    if (token != null) {
      await _registerTokenWithServer(token);
    }

    // listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      await _registerTokenWithServer(newToken);
    });
  }

  static Future<void> _registerTokenWithServer(String token) async {
    try {
      final userId = await LocalStorageService.getUser(); // implement or adjust
      final deviceId = 'flutter-${Platform.operatingSystem}-${DateTime.now().millisecondsSinceEpoch}';
      await HttpService.post(PathConfig.registerDeviceToken, {
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
