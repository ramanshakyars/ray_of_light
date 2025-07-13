import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:rayoflite/core/config/config-routes.dart';

void main() {
 
  runApp(
     DevicePreview(builder: (context) =>  MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // title: 'Ray of Light',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router, 
    );
  }
}
