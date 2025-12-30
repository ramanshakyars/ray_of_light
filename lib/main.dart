import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/config/config-routes.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/notifications/push-service.dart';

Future<void> main() async {
  /// 🔹 Required for async before runApp
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔹 Firebase init (must be first for push)
  await Firebase.initializeApp();

  /// 🔹 Push notifications init
  /// (permission, foreground/background listeners)
  await PushService.init();

  /// 🔹 Local storage init
  await LocalStorageService.getInstance();
  final bool isLoggedIn = await LocalStorageService.isLoggedIn();

  /// 🔹 Decide initial route
  String initialRoute;
  if (isLoggedIn) {
    initialRoute = '${RouteNames.mainApp}/${RouteNames.home}';
  } else {
    initialRoute =
        kIsWeb ? RouteNames.weblandingPage : RouteNames.landingPage;
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
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
              scaffoldBackgroundColor:
                  AppColors.getAppBackgroundColor(
                themeProvider.isDarkMode,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor:
                    AppColors.getAppBackgroundColor(
                  themeProvider.isDarkMode,
                ),
                foregroundColor:
                    AppColors.getTextPrimaryColor(
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
              scaffoldBackgroundColor:
                  AppColors.getAppBackgroundColor(
                themeProvider.isDarkMode,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor:
                    AppColors.getAppBackgroundColor(
                  themeProvider.isDarkMode,
                ),
                foregroundColor:
                    AppColors.getTextPrimaryColor(
                  themeProvider.isDarkMode,
                ),
              ),
            ),

            /// 🔹 Theme mode
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            /// 🔹 Router (single instance)
            routerConfig: router,
          );
        },
      ),
    );
  }
}
