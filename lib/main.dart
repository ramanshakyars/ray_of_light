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
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/firebase_options.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeProvider.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_navigation_service.dart';

import 'presentation/screens/notifications/dummy_notification_scheduler.dart';

Future<void> main() async {
  /// 🔹 Required for async before runApp
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// 🔹 Firebase init (unchanged)
  if (!Platform.isIOS) {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
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
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,

            /// 🔹 Light Theme (unchanged)
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.getFormSubmitButtonColor(
                  themeProvider.isDarkMode,
                ),
                brightness: Brightness.light,
              ),
              fontFamily: 'Specimen',
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.getAppBackgroundColor(
                themeProvider.isDarkMode,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.getAppBackgroundColor(
                  themeProvider.isDarkMode,
                ),
                foregroundColor: AppColors.getTextPrimaryColor(
                  themeProvider.isDarkMode,
                ),
              ),
            ),

            /// 🔹 Dark Theme (unchanged)
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.getFormSubmitButtonColor(
                  themeProvider.isDarkMode,
                ),
                brightness: Brightness.dark,
              ),
              fontFamily: 'Specimen',
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.getAppBackgroundColor(
                themeProvider.isDarkMode,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.getAppBackgroundColor(
                  themeProvider.isDarkMode,
                ),
                foregroundColor: AppColors.getTextPrimaryColor(
                  themeProvider.isDarkMode,
                ),
              ),
            ),

            /// 🔹 Theme mode (unchanged)
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
