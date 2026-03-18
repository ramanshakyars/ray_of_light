import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/config/config-routes.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/firebase_options.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeProvider.dart';

Future<void> main() async {
  /// 🔹 Required for async before runApp
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔹 Firebase init (must be first for push)
  if (!Platform.isIOS) {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  /// 🔹 Local storage init
  await LocalStorageService.getInstance();
  final bool isLoggedIn = await LocalStorageService.isLoggedIn();
  final bool isTokenValid = await LocalStorageService.isTokenValid();

  /// 🔹 Decide initial route
  String initialRoute;
  if (isLoggedIn && isTokenValid) {
    initialRoute = '${RouteNames.mainApp}/${RouteNames.home}';
  } else {
    initialRoute = kIsWeb ? RouteNames.weblandingPage : RouteNames.landingPage;
  }

  /// 🔹 Create router ONCE (very important)
  final GoRouter router = createRouter(initialRoute);

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// ✅ Existing Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        /// ✅ Profile Provider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ScreenTimeProvider()),
        
        /// ✅ UPDATED Auth Provider with Session Management
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..loadUser(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,

            /// 🔹 Light Theme
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

            /// 🔹 Dark Theme
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

            /// 🔹 Theme mode
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            /// 🔹 Router (single instance)
            routerConfig: router,
          );
        },
      ),
    );
  }
}
