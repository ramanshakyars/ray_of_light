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
import 'package:rayoflite/presentation/welcome-page.dart';


final router = GoRouter(
  initialLocation: RouteNames.landingPage,
  routes: [
    // Landing page route
    GoRoute(
      path: RouteNames.landingPage,
      builder: (context, state) => const WelcomePage(),
    ),

    // Auth routes (all top-level)
    GoRoute(path: RouteNames.login, builder: (context, state) => const Login()),
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
        GoRoute(
          path: RouteNames.mainApp,
          builder: (context, state) => const TalkToLiteScreen(userName: 'Rhythm'),
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => const TalkToLiteScreen(userName: 'Rhythm'),
            ),
            GoRoute(
              path: RouteNames.talkToLight,
              builder: (context, state) => ChatScreen(),
            ),
            GoRoute(
              path: RouteNames.junerlism,
              builder: (context, state) => const JunerlismScreen(),
            ),
            GoRoute(
              path: RouteNames.breathingExercise,
              builder: (context, state) => BreathingScreen(),
            ),
            GoRoute(
              path: RouteNames.goalTracker,
              builder: (context, state) => const GoalTrackerExcerises(),
            ),
          ],
        ),
      ],
    ),
  ],
);
