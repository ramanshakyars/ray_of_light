import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/presentation/screens/forget-password.dart';
import 'package:rayoflite/presentation/screens/login.dart';
import 'package:rayoflite/presentation/screens/register.dart';
import 'package:rayoflite/presentation/screens/reset-password.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login', 
  routes: [
    GoRoute(
      path: '/',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const Login(),
    ),

    GoRoute(
      path: '/forgot-password',
      name: 'forgot_password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset_password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
  ],
);
