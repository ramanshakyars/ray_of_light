import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/config/config-routes.dart'; // createRouter
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.getInstance();
  final isLoggedIn = await LocalStorageService.isLoggedIn();

  // Determine initial route based on login/web state
  String initialRoute;
  if (isLoggedIn) {
    initialRoute = '${RouteNames.mainApp}/${RouteNames.home}';
  } else {
    initialRoute = kIsWeb ? RouteNames.weblandingPage : RouteNames.landingPage;
  }

  // Create the router ONCE and pass it down
  final GoRouter router = createRouter(initialRoute);

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
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
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: router, // Always the same instance!
          );
        },
      ),
    );
  }
}
