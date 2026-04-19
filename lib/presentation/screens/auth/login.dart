import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/constants/app_text_field.dart';
import 'package:rayoflite/core/constants/common_button.dart';
import 'package:rayoflite/core/providers/TokenManager.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/authService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/notifications/dummy_notification_scheduler.dart';
import 'package:rayoflite/presentation/screens/notifications/push-service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _login() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => _isLoading = true);
  //   try {
  //     final body = {
  //       'email': _emailController.text.trim(),
  //       'password': _passwordController.text.trim(),
  //     };
  //     final response = await AuthService.login(body);
  //     if (!mounted) return;
  //     if (response['success'] == true) {
  //       MessageService.showSuccess(
  //         context,
  //         response['message'] ?? 'Login Successful!',
  //       );
  //       GoRouter.of(context).go('${RouteNames.mainApp}/${RouteNames.home}');
  //     } else {
  //       MessageService.showError(
  //         context,
  //         response['message'] ?? 'Login failed!',
  //       );
  //     }
  //   } catch (e) {
  //     MessageService.showError(context, 'Something went wrong');
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  void _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final body = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    final response = await AuthService.login(body);

    if (!mounted) return;

    if (response['success'] == true) {

      final token = response['token'];
      final user = response['user'];

      // 🔥 1. SAVE TOKEN
      await LocalStorageService.setToken(token);
      TokenManager.setToken(token);

      // 🔥 2. SAVE USER
      await LocalStorageService.setUser(user);

      // 🔥 3. LOAD PROVIDER
      await Provider.of<AuthProvider>(context, listen: false).loadUser();

      // 🔔 4. START NOTIFICATIONS (PERFECT PLACE)
     // await DummyNotificationScheduler.initAndSchedule();

      MessageService.showSuccess(
        context,
        response['message'] ?? 'Login Successful!',
      );

      GoRouter.of(context).go(
        '${RouteNames.mainApp}/${RouteNames.home}',
      );

    } else {
      MessageService.showError(
        context,
        response['message'] ?? 'Login failed!',
      );
    }
  } catch (e) {
    MessageService.showError(context, 'Something went wrong');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  void _forgotPassword() {
    MessageService.showInfo(context, 'Password reset link sent to your email');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 600;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDarkMode),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// 🔹 Header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        'Back',
                        style: AppTextStyles.monoSecondary14(isDarkMode),
                      ),
                    ),
                  ),

                  const SizedBox(height: 200),

                  /// 🔹 Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.getMonoCard(isDarkMode),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            Text(
                              'Welcome back',
                              style: AppTextStyles.monoBold22(isDarkMode),
                            ),

                            const SizedBox(height: 6),

                            /// Subtitle
                            Text(
                              'Continue your journey towards peace',
                              style: AppTextStyles.monoSecondary14(isDarkMode),
                            ),

                            const SizedBox(height: 28),

                            /// Email
                            AppTextField(
                              controller: _emailController,
                              label: 'Email',
                              prefixIcon: Icons.email,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!v.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            /// Password
                            AppTextField(
                              controller: _passwordController,
                              label: 'Password',
                              prefixIcon: Icons.lock,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed:
                                    () =>
                                        context.push(RouteNames.forgotPassword),
                                child: Text(
                                  'Forgot password?',
                                  style: AppTextStyles.monoSecondary14(
                                    isDarkMode,
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            /// Login button
                            CommonButton(
                              text: "Log In",
                              isLoading: _isLoading,
                              onPressed: _isLoading ? null : _login,
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: TextButton(
                                onPressed:
                                    () => context.push(RouteNames.register),
                                child: Text(
                                  "Don't have an account? Sign up",
                                  style: AppTextStyles.monoSecondary14(
                                    isDarkMode,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
