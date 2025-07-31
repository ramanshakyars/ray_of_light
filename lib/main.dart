import 'package:flutter/material.dart';
import 'package:rayoflite/core/config/config-routes.dart';
import 'package:rayoflite/core/services/localStorageService.dart';

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: createRouter(isLoggedIn), 
    );
  }
}
