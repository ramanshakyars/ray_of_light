import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_navigation_service.dart';

class DummyNotificationScheduler {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 🔹 INIT + CLICK HANDLER
  static Future<void> _init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;

        if (payload != null) {
          print("📲 Notification Clicked → $payload");
          NotificationNavigationService.navigate(payload);
        }
      },
    );
  }

  /// 🔹 PERMISSION
  static Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (Platform.isAndroid) {
      if (await Permission.notification.isDenied ||
          await Permission.notification.isPermanentlyDenied) {
        await Permission.notification.request();
      }
    }
  }

  /// 🔹 CALL AFTER LOGIN
  static Future<void> initAndSchedule() async {
    await _init();
    await _requestPermission();
    await scheduleNotifications();
  }

  /// 🔥 ALL YOUR NOTIFICATIONS (FULL LIST + ROUTES)
  static final List<Map<String, String>> notifications = [
    // 🏆 MOTIVATION
    {
      "title": "🏆 Winner Mindset",
      "body": "Trust me, You will have everything.",
      "route": "/main/home",
    },
    {"title": "🥇 Champion", "body": "You are winner.", "route": "/main/home"},
    {
      "title": "🔥 Stronger",
      "body": "You will beat everyone.",
      "route": "/main/talk-to-light",
    },
    {
      "title": "🎯 Focus",
      "body": "You are facing yourself, only competition is you.",
      "route": "/main/talk-to-light",
    },
    {
      "title": "💡 Meaning",
      "body": "What you do is meaningful.",
      "route": "/main/junerlism",
    },
    {"title": "😄 Enjoy", "body": "Hey! Enjoy.", "route": "/main/home"},
    {
      "title": "✅ Winning",
      "body": "You are a winner, you are winning.",
      "route": "/main/home",
    },
    {
      "title": "⚡ Reality",
      "body": "It's not that simple… and it's a lie.",
      "route": "/main/talk-to-light",
    },
    {
      "title": "💰 Money",
      "body": "Money matters",
      "route": "/main/goal-tracker",
    },
    {
      "title": "🧠 Truth",
      "body": "Everything you feared losing, you already lost.",
      "route": "/main/junerlism",
    },
    {
      "title": "📖 Lesson",
      "body": "Life teaches you everything",
      "route": "/main/junerlism",
    },

    // 🌱 CALM / HEALING
    {
      "title": "🌱 Keep Growing",
      "body": "Every day is a chance to grow.",
      "route": "/main/junerlism",
    },
    {
      "title": "☀️ New Day",
      "body": "A fresh start begins now.",
      "route": "/main/home",
    },
    {
      "title": "🫶 Self Care",
      "body": "Taking care of yourself is productive.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "🌬️ Slow Down",
      "body": "You don’t need to rush. Breathe.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "💭 Gentle Reminder",
      "body": "Progress looks different for everyone.",
      "route": "/main/home",
    },
    {
      "title": "🌊 Flow",
      "body": "Go at your own pace.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "✨ Inner Peace",
      "body": "Peace begins with one breath.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "🧠 Clarity",
      "body": "Clear thoughts come from calm mind.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "💙 Self Love",
      "body": "Be gentle with yourself.",
      "route": "/main/home",
    },
    {
      "title": "🪴 Nurture",
      "body": "Growth takes time.",
      "route": "/main/junerlism",
    },
    {
      "title": "🌸 Soft Strength",
      "body": "You can be soft and strong.",
      "route": "/main/home",
    },
    {
      "title": "⏸️ Pause",
      "body": "Rest is part of progress.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "🎯 One Thing",
      "body": "Focus on one small thing.",
      "route": "/main/talk-to-light",
    },
    {"title": "🌈 Hope", "body": "Tough days pass.", "route": "/main/home"},
    {
      "title": "🧩 Little Wins",
      "body": "Small wins matter.",
      "route": "/main/goal-tracker",
    },
    {
      "title": "💫 Trust Yourself",
      "body": "You know more than you think.",
      "route": "/main/home",
    },
    {
      "title": "🌤️ Gentle Day",
      "body": "Let today be light.",
      "route": "/main/home",
    },
    {
      "title": "🫂 You’re Safe",
      "body": "It’s okay to slow down.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "📖 Your Journey",
      "body": "No one walks your path but you.",
      "route": "/main/junerlism",
    },
    {
      "title": "🌱 Still Trying",
      "body": "Trying is a victory.",
      "route": "/main/home",
    },
    {
      "title": "🧘 Calm Moment",
      "body": "Relax your shoulders.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "💭 Kind Thoughts",
      "body": "Speak kindly to yourself.",
      "route": "/main/talk-to-light",
    },
    {
      "title": "🕊️ Let Go",
      "body": "Release what you can’t control.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "⏳ Be Patient",
      "body": "Good things take time.",
      "route": "/main/home",
    },
    {
      "title": "🌙 Gentle Night",
      "body": "You did enough today.",
      "route": "/main/home",
    },
    {
      "title": "☁️ Light Mind",
      "body": "Don’t carry everything.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "🌻 Still Blooming",
      "body": "You’re growing quietly.",
      "route": "/main/junerlism",
    },
    {
      "title": "💛 Warm Reminder",
      "body": "You’re allowed to rest.",
      "route": "/main/home",
    },
    {
      "title": "🔁 One More Try",
      "body": "Tomorrow is another chance.",
      "route": "/main/goal-tracker",
    },
    {
      "title": "🧠 Clear Space",
      "body": "A pause resets everything.",
      "route": "/main/breathing-exercise",
    },
    {
      "title": "🌿 Grounded",
      "body": "Stay present.",
      "route": "/main/breathing-exercise",
    },
  ];

  /// 🔹 SCHEDULER
  static Future<void> scheduleNotifications() async {
    await _plugin.cancelAll();

    final random = Random();
    final now = tz.TZDateTime.now(tz.local);

    const int startHour = 8;
    const int endHour = 22;

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
        payload: notification["route"], // ✅ CLICK ROUTE
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print(
        "⏰ Scheduled → ${notification["title"]} → ${notification["route"]}",
      );
    }
  }

  static NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'dummy_channel',
        'RayOfLight Notifications',
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
