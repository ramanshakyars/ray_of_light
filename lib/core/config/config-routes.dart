import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/presentation/screens/auth/accountDeactivation.dart';
import 'package:rayoflite/presentation/screens/auth/forget-password.dart';
import 'package:rayoflite/presentation/screens/auth/login.dart';
import 'package:rayoflite/presentation/screens/auth/register.dart';
import 'package:rayoflite/presentation/screens/auth/reset-password.dart';
import 'package:rayoflite/presentation/screens/features/profile.dart';
import 'package:rayoflite/presentation/screens/home/user-dashboard.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chat_screen.dart';
import 'package:rayoflite/presentation/screens/features/journalism/junerlism.dart';
import 'package:rayoflite/presentation/screens/features/breathing/breathing.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker/goal-tracker.dart';
import 'package:rayoflite/presentation/screens/web/PrivacyPolicyPage.dart';
import 'package:rayoflite/presentation/screens/web/web-LandingPage.dart';
import 'package:rayoflite/presentation/welcome-page.dart';
import 'package:rayoflite/core/config/main-layout.dart';

GoRouter createRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      // Mobile landing page
      GoRoute(
        path: RouteNames.landingPage,
        builder: (context, state) => const WelcomePage(),
      ),
      // Web landing page
      GoRoute(
        path: RouteNames.weblandingPage,
        builder: (context, state) => const WebLandingPage(),
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
        path: RouteNames.accountDeactivate,
        builder: (context, state) => const AccountDeactivatedScreen(),
      ),
      GoRoute(
        path: RouteNames.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),

      // Main App Routes
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.mainApp,
            builder: (context, state) => UserDashboard(),
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => UserDashboard(),
              ),
              GoRoute(
                path: RouteNames.talkToLight,
                builder: (context, state) {
                  final chatId = state.uri.queryParameters['chatId'];
                  return ChatScreen(chatId: chatId); // pass it here
                },
              ),

              GoRoute(
                path: RouteNames.junerlism,
                builder: (context, state) => const JournalismScreen(),
              ),
              GoRoute(
                path: RouteNames.breathingExercise,
                builder: (context, state) => BreathingScreen(),
              ),
              GoRoute(
                path: RouteNames.goalTracker,
                builder: (context, state) => const GoalTrackerExercises(),
              ),
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
