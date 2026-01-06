import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DummyNotificationScheduler {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 🔹 Call only ONCE (after login)
  static Future<void> initAndSchedule() async {
    await _init();
    await _requestPermission();
    await _scheduleEvery6Hours();
  }

  /// 🔹 INIT
  static Future<void> _init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
  }

  /// 🔹 ASK PERMISSION (iOS + Android 13+)
  static Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (Platform.isAndroid) {
      // Android 13+ requires notification permission
      if (await Permission.notification.isDenied ||
          await Permission.notification.isPermanentlyDenied) {
        await Permission.notification.request();
      }
    }
  }

  /// 🔹 MAIN LOGIC — 4 NOTIFICATIONS / DAY
  // static Future<void> _scheduleEvery6Hours() async {
  //   await _plugin.cancelAll(); // avoid duplicates
  //   final now = tz.TZDateTime.now(tz.local);
  //   for (int i = 1; i <= 4; i++) {
  //     final scheduledTime = now.add(Duration(hours: i * 6));
  //     await _plugin.zonedSchedule(
  //       i,
  //       "🌟 Ray of Light",
  //       _dummyMessage(i),
  //       scheduledTime,
  //       _details(),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //     );
  //   }
  // }
  static Future<void> _scheduleEvery6Hours() async {
    await _plugin.cancelAll(); // avoid duplicates

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 1; i <= 5; i++) {
      final scheduledTime = now.add(Duration(minutes: i));

      await _plugin.zonedSchedule(
        i,
        "🧪 Dummy Test Notification",
        "Triggered at ${scheduledTime.hour}:${scheduledTime.minute}",
        scheduledTime,
        _details(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'dummy_channel',
        'Dummy Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static String _dummyMessage(int index) {
    return [
      "Stay consistent 🌱",
      "Take a mindful break ☕",
      "Reflect on your progress ✨",
      "You’re doing great 💙",
    ][index - 1];
  }
}
