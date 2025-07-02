import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/main-layout.dart';
import 'package:rayoflite/presentation/screens/features/breathing.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker.dart';
import 'package:rayoflite/presentation/screens/features/junerlism.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-light.dart';
import 'package:rayoflite/presentation/screens/forget-password.dart';
import 'package:rayoflite/presentation/screens/login.dart';
import 'package:rayoflite/presentation/screens/register.dart';
import 'package:rayoflite/presentation/screens/reset-password.dart';
import 'package:rayoflite/core/config/routenames.dart';


final router = GoRouter(
  initialLocation: RouteNames.landing,
  routes: [
    GoRoute(
      path: RouteNames.landing,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RouteNames.resetPassword,
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    
    // Main app structure with nested routes
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        // Bottom tab routes
        GoRoute(
          path: '${RouteNames.mainApp}/:tab(home|search|profile)',
          builder: (context, state) {
            final tab = state.pathParameters['tab']!;
            switch (tab) {
              case 'home':
                return const TalkToLiteScreen();
              case 'search':
                return const BreathingScreen();
              case 'profile':
                return const JunerlismScreen();             
              default:
                return const GoalTrackerExcerises();
            }
          },
        ),
        
        // Other pages that can be accessed from drawer/side menu
        GoRoute(
          path: '${RouteNames.mainApp}/${RouteNames.page1}',
          builder: (context, state) => const GoalTrackerExcerises(),
        ),
        GoRoute(
          path: '${RouteNames.mainApp}/${RouteNames.page2}',
          builder: (context, state) => const JunerlismScreen(),
        ),
      ],
    ),
  ],
);