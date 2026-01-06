import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/authService.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final body = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };
      final response = await AuthService.login(body);
      if (response['success'] == true) {
        MessageService.showSuccess(
          context,
          response['message'] ?? 'Login Successful!',
        );
         await PushService.init();
         await DummyNotificationScheduler.initAndSchedule();
        if (mounted) {
          GoRouter.of(context).go('${RouteNames.mainApp}/${RouteNames.home}');
        }
      } else {
        MessageService.showError(
          context,
          response['message'] ?? 'Login failed!',
        );
      }
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
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Center(
            child: SingleChildScrollView(
              // Only for emergency - shouldn't normally scroll
              physics: NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  minHeight:
                      screenHeight - MediaQuery.of(context).padding.vertical,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Section - Only show if there's enough space
                    if (!isSmallScreen) ...[
                      Image.asset(
                        'assets/logo.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ray of Light',
                        style: AppTextStyles.bold28(isDarkMode),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We are here to help you to be better than yesterday',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular14(isDarkMode),
                      ),
                      const SizedBox(height: 32),
                    ],
                    Card(
                      color: AppColors.getFormsCardColor(isDarkMode),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Login / Signup',
                                style: AppTextStyles.bold22(isDarkMode),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: AppTextStyles.regular14(isDarkMode),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: 20,
                                    color: AppColors.getIconColor(isDarkMode),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 12 : 14,
                                    horizontal: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: AppTextStyles.regular14(isDarkMode),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 20,
                                    color: AppColors.getIconColor(isDarkMode),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 20,
                                      color: AppColors.getIconColor(isDarkMode),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 12 : 14,
                                    horizontal: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .push(RouteNames.forgotPassword);
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: AppTextStyles.link14(isDarkMode),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.getFormSubmitButtonColor(isDarkMode),
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmallScreen ? 12 : 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Login',
                                    style: AppTextStyles.button16(isDarkMode),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  GoRouter.of(context)
                                      .push(RouteNames.register);
                                },
                                child: Text(
                                  'Don\'t have an account? Sign Up',
                                  style: AppTextStyles.link14(isDarkMode),
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
      ),
    );
  }
}
