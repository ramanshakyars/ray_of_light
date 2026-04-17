import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationNavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigate(String route) {
    final context = navigatorKey.currentContext;

    if (context != null) {
      context.go(route);
    } else {
      print("❌ Navigation failed (context null)");
    }
  }
}