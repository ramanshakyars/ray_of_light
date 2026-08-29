import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/config/config-routes.dart';
import 'package:rayoflite/core/providers/TokenManager.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/firebase_options.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeProvider.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_navigation_service.dart';

import 'package:rayoflite/presentation/screens/notifications/dummy_notification_scheduler.dart';
import 'package:rayoflite/presentation/screens/notifications/push-service.dart';

Future<void> main() async {
  /// 🔹 Required for async before runApp
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// 🔹 Firebase init — required on BOTH Android AND iOS for FCM/APNs to work
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// 🔹 Local storage init (unchanged)
  await LocalStorageService.getInstance();

  /// 🔥 Token restore (unchanged)
  final token = await LocalStorageService.getToken();
  if (token != null && token.isNotEmpty) {
    TokenManager.setToken(token);
  }

  await DummyNotificationScheduler.initOnly();
  final bool isLoggedIn = await LocalStorageService.isLoggedIn();
  final bool isTokenValid = await LocalStorageService.isTokenValid();

  /// 🔥 Init Firebase push notifications if user is already logged in.
  /// If not logged in yet, PushService.init() must be called after login.
  if (isLoggedIn && isTokenValid) {
    PushService.init().catchError((e) {
      debugPrint('[main] PushService.init() failed: $e');
    });
  }

  /// 🔹 Initial route logic (unchanged)
  String initialRoute;
  if (isLoggedIn && isTokenValid) {
    initialRoute = '${RouteNames.mainApp}/${RouteNames.home}';
  } else {
    initialRoute = kIsWeb ? RouteNames.weblandingPage : RouteNames.landingPage;
  }

  /// 🔥 ✅ NEW: CHECK IF APP OPENED FROM NOTIFICATION
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  final details = await plugin.getNotificationAppLaunchDetails();

  String? notificationRoute;

  if (details?.didNotificationLaunchApp ?? false) {
    notificationRoute = details!.notificationResponse?.payload;
    print("🚀 Opened from notification → $notificationRoute");
  }

  /// 🔹 Create router (unchanged)
  final GoRouter router = createRouter(initialRoute);

  /// 🔹 Run app (unchanged)
  runApp(MyApp(router: router));

  /// 🔥 ✅ NEW: NAVIGATE AFTER APP LOAD
  if (notificationRoute != null) {
    Future.delayed(const Duration(seconds: 1), () {
      NotificationNavigationService.navigate(notificationRoute!);
    });
  }
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// ✅ Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        /// ✅ Profile Provider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),

        /// ✅ Screen Time Provider
        ChangeNotifierProvider(create: (_) => ScreenTimeProvider()),

        /// ✅ Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadUser()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final colors = themeProvider.colors;

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,

            /// 🔹 Light Theme — driven by centralized ThemeColors
            theme: ThemeData(
              colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: colors.primary,
                onPrimary: colors.primaryForeground,
                secondary: colors.secondary,
                onSecondary: colors.textPrimary,
                error: colors.error,
                onError: colors.primaryForeground,
                surface: colors.surface,
                onSurface: colors.textPrimary,
              ),
              fontFamily: 'Poppins',
              useMaterial3: true,
              scaffoldBackgroundColor: colors.background,
              appBarTheme: AppBarTheme(
                backgroundColor: colors.background,
                foregroundColor: colors.textPrimary,
                elevation: 0,
              ),
              dividerColor: colors.divider,
              splashColor: colors.primary.withValues(alpha: 0.08),
              highlightColor: colors.primary.withValues(alpha: 0.05),
            ),

            /// 🔹 Dark Theme — driven by centralized ThemeColors
            darkTheme: ThemeData(
              colorScheme: ColorScheme(
                brightness: Brightness.dark,
                primary: colors.primary,
                onPrimary: colors.primaryForeground,
                secondary: colors.secondary,
                onSecondary: colors.textPrimary,
                error: colors.error,
                onError: colors.primaryForeground,
                surface: colors.surface,
                onSurface: colors.textPrimary,
              ),
              fontFamily: 'Poppins',
              useMaterial3: true,
              scaffoldBackgroundColor: colors.background,
              appBarTheme: AppBarTheme(
                backgroundColor: colors.background,
                foregroundColor: colors.textPrimary,
                elevation: 0,
              ),
              dividerColor: colors.divider,
              splashColor: colors.primary.withOpacity(0.08),
              highlightColor: colors.primary.withOpacity(0.05),
            ),

            /// 🔹 Theme mode — controlled by ThemeProvider
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            /// 🔥 IMPORTANT: Router config (unchanged)
            routerConfig: router,
          );
        },
      ),
    );
  }
}
