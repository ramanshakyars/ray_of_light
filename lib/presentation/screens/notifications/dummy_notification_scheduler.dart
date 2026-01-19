import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DummyNotificationScheduler {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 🔹 Call only ONCE (after login)
  static Future<void> initAndSchedule() async {
    print("🔔 DummyNotificationScheduler CALLED");
    await _init();
    await _requestPermission();
    await scheduleDummyNotifications();
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

  static Future<void> scheduleDummyNotifications() async {
    await _plugin.cancelAll(); // 🔒 avoid duplicates

    final notifications = <Map<String, String>>[
      // ✅ Your 11 messages (NEW)
      {
        "title": "🏆 Winner Mindset",
        "body": "Trust me, You will have everything.",
      },
      {"title": "🥇 Champion", "body": "You are winner."},
      {"title": "🔥 Stronger", "body": "You will beat everyone."},
      {
        "title": "🎯 Focus",
        "body":
            "You are facing yourself, there is only one competition its you.",
      },
      {"title": "💡 Meaning", "body": "What you do is meaningful."},
      {"title": "😄 Enjoy", "body": "Hey!…………Enjoy."},
      {
        "title": "✅ Winning",
        "body": "You know? You are a winner, you are winning.",
      },
      {"title": "⚡ Reality", "body": "Its not that simple……….., and its a lie"},
      {"title": "💰 Money", "body": "Money matters"},
      {
        "title": "🧠 Truth",
        "body": "Everything you were afraid of losing, you have already lost.",
      },
      {"title": "📖 Lesson", "body": "Life teaches you everything"},

      // ✅ Old messages (keep like before)
      {
        "title": "🌱 Keep Growing",
        "body": "Every day is a chance to grow a little more.",
      },
      {"title": "☀️ New Day", "body": "A fresh start begins right now."},
      {
        "title": "🫶 Self Care",
        "body": "Taking care of yourself is productive.",
      },
      {"title": "🌬️ Slow Down", "body": "You don’t need to rush. Breathe."},
      {
        "title": "💭 Gentle Reminder",
        "body": "Progress looks different for everyone.",
      },
      {"title": "🌊 Flow", "body": "Go at your own pace today."},
      {"title": "✨ Inner Peace", "body": "Peace begins with one calm breath."},
      {"title": "🧠 Clarity", "body": "Clear thoughts come from a calm mind."},
      {"title": "💙 Self Love", "body": "Be gentle with yourself today."},
      {"title": "🪴 Nurture", "body": "Growth takes time—just like roots."},
      {
        "title": "🌸 Soft Strength",
        "body": "You can be soft and strong together.",
      },
      {"title": "⏸️ Pause", "body": "Rest is part of progress."},
      {"title": "🎯 One Thing", "body": "Focus on one small thing right now."},
      {"title": "🌈 Hope", "body": "Even tough days pass."},
      {
        "title": "🧩 Little Wins",
        "body": "Small wins matter more than you think.",
      },
      {"title": "💫 Trust Yourself", "body": "You know more than you realize."},
      {"title": "🌤️ Gentle Day", "body": "Let today be light on your heart."},
      {"title": "🫂 You’re Safe", "body": "It’s okay to slow down here."},
      {
        "title": "📖 Your Journey",
        "body": "No one else walks your path but you.",
      },
      {"title": "🌱 Still Trying", "body": "Trying itself is a victory."},
      {
        "title": "🧘 Calm Moment",
        "body": "Unclench your jaw. Relax your shoulders.",
      },
      {"title": "💭 Kind Thoughts", "body": "Speak kindly to yourself today."},
      {"title": "🕊️ Let Go", "body": "Release what you can’t control."},
      {"title": "⏳ Be Patient", "body": "Good things take time."},
      {"title": "🌙 Gentle Night", "body": "You did enough for today."},
      {"title": "☁️ Light Mind", "body": "You don’t need to carry everything."},
      {
        "title": "🌻 Still Blooming",
        "body": "You’re growing, even on quiet days.",
      },
      {"title": "💛 Warm Reminder", "body": "You’re allowed to rest."},
      {"title": "🔁 One More Try", "body": "Tomorrow is another chance."},
      {"title": "🧠 Clear Space", "body": "A calm pause can reset everything."},
      {"title": "🌿 Grounded", "body": "Stay present. Stay grounded."},
    ];

    // 🔹 SCHEDULE NOTIFICATIONS EVERY 2 MIN
    // // 🛑 EDGE CASE
    // if (notifications.isEmpty) return;
    // final now = tz.TZDateTime.now(tz.local);
    // for (int i = 0; i < notifications.length; i++) {
    //   final scheduledTime = now.add(
    //     Duration(minutes: (i + 1) * 2),
    //   ); // dummy test
    //   if (scheduledTime.isBefore(now)) continue;
    //   await _plugin.zonedSchedule(
    //     i + 1,
    //     notifications[i]["title"]!,
    //     notifications[i]["body"]!,
    //     scheduledTime,
    //     _details(),
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //   );

    //   print("⏰ Scheduled ${i + 1} → ${notifications[i]["title"]}");
    // }

    /// 🔹 SCHEDULE NOTIFICATIONS DAILY AT FIXED TIME S
    final random = Random();
    final now = tz.TZDateTime.now(tz.local);
    const int startHour = 8; // 8 AM
    const int endHour = 22; // 10 PM
    final Set<int> usedHours = {};
    for (int i = 0; i < 6; i++) {
      int hour;
      do {
        hour = startHour + random.nextInt(endHour - startHour);
      } while (usedHours.contains(hour));
      usedHours.add(hour);
      final minute = random.nextInt(60);
      var scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // ⏭️ agar time nikal gaya ho to next day
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final notification = notifications[random.nextInt(notifications.length)];

      await _plugin.zonedSchedule(
        i + 1,
        notification["title"]!,
        notification["body"]!,
        scheduledTime,
        _details(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print(
        "⏰ Scheduled ${i + 1} → ${notification["title"]} at ${scheduledTime.hour}:${scheduledTime.minute}",
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
        channelDescription: 'RayOfLight motivational alerts',
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
