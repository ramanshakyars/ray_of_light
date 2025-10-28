import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/config-routes.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.getInstance();
  final isLoggedIn = await LocalStorageService.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // Initial landing page selection
    String initialRoute;
    if (isLoggedIn) {
      // Logged-in users: follow normal flow
      initialRoute = '${RouteNames.mainApp}/${RouteNames.home}';
    } else {
      // Not logged in: show web landing or mobile landing
      if (kIsWeb) {
        initialRoute = RouteNames.weblandingPage;
      } else {
        initialRoute = RouteNames.landingPage;
      }
    }

    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.getFormSubmitButtonColor(themeProvider.isDarkMode),
                brightness: Brightness.light,
              ),
              fontFamily: 'Specimen',
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.getAppBackgroundColor(themeProvider.isDarkMode),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.getAppBackgroundColor(themeProvider.isDarkMode),
                foregroundColor: AppColors.getTextPrimaryColor(themeProvider.isDarkMode),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.getFormSubmitButtonColor(themeProvider.isDarkMode),
                brightness: Brightness.dark,
              ),
              fontFamily: 'Specimen',
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.getAppBackgroundColor(themeProvider.isDarkMode),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.getAppBackgroundColor(themeProvider.isDarkMode),
                foregroundColor: AppColors.getTextPrimaryColor(themeProvider.isDarkMode),
              ),
            ),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: createRouter(initialRoute),
          );
        },
      ),
    );
  }
}
