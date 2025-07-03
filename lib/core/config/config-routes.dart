import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/main-layout.dart';
import 'package:rayoflite/presentation/screens/features/breathing.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker.dart';
import 'package:rayoflite/presentation/screens/features/junerlism.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-light.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chat_screen.dart';
import 'package:rayoflite/presentation/screens/forget-password.dart';
import 'package:rayoflite/presentation/screens/landing-page.dart';
import 'package:rayoflite/presentation/screens/login.dart';
import 'package:rayoflite/presentation/screens/register.dart';
import 'package:rayoflite/presentation/screens/reset-password.dart';
import 'package:rayoflite/core/config/routenames.dart';


final router = GoRouter(
  initialLocation: RouteNames.lsndingPage,
  routes: [
    // Initial routes
    GoRoute(
      path: RouteNames.lsndingPage,
      builder: (context, state) => const LandingPage(),
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
    GoRoute(
      path: RouteNames.logout,
      builder: (context, state) => const Login(),
    ),
    
    // Main app structure with nested routes
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        // Bottom tab routes
        GoRoute(
          path: '${RouteNames.mainApp}/${RouteNames.home}',
          builder: (context, state) => const TalkToLiteScreen(),
        ),
        GoRoute(
          path: '${RouteNames.mainApp}/${RouteNames.talkToLight}',
          builder: (context, state) => ChatScreen(),
        ),
        GoRoute(
          path: '${RouteNames.mainApp}/${RouteNames.junerlism}',
          builder: (context, state) => const JunerlismScreen(),
        ),
        GoRoute(
          path: '${RouteNames.mainApp}/${RouteNames.breathingExercise}',
          builder: (context, state) => BreathingScreen(),
        ),
        GoRoute(
          path: '${RouteNames.mainApp}/${RouteNames.goalTracker}',
          builder: (context, state) => const GoalTrackerExcerises(),
        ),
      ],
    ),
  ],
);