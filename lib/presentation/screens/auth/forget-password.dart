import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/authService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isOtpSent = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // Step 1 - Send OTP
  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      MessageService.showError(context, 'Please enter a valid email!');
      return;
    }

    final response = await AuthService.sendOtpForgetPassword({'email': email});
    if (response['success'] == true) {
      setState(() {
        _isOtpSent = true;
      });
      MessageService.showSuccess(context, response['message']);
    } else {
      MessageService.showError(context, response['message']);
    }
  }

  // Step 2 - Reset Password
  Future<void> _resetPassword() async {
    if (_newPasswordController.text.length < 6) {
      MessageService.showError(
        context,
        'Password must be at least 6 characters',
      );
      return;
    }

    final body = {
      'email': _emailController.text.trim(),
      'otp': _otpController.text.trim(),
      'newPassword': _newPasswordController.text.trim(),
    };

    final response = await AuthService.resetPassword(body);

    if (response['success'] == true) {
      MessageService.showSuccess(context, response['message']);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          GoRouter.of(context).go(RouteNames.login);
        }
      });
    } else {
      MessageService.showError(context, response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 80),
                const SizedBox(height: 10),
                Text(
                  'Ray of Light',
                  style: AppTextStyles.bold28(isDarkMode),
                ),
                const SizedBox(height: 5),
                Text(
                  'We are here to help you to be better than yesterday',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular14(isDarkMode),
                ),
                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Card(
                    color: AppColors.getFormsCardColor(isDarkMode),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            _isOtpSent ? 'Reset Password' : 'Forgot Password',
                            style: AppTextStyles.bold22(isDarkMode),
                          ),
                          const SizedBox(height: 20),

                          // Email always visible
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email, size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // OTP + New Password (only after OTP is sent)
                          if (_isOtpSent) ...[
                            TextFormField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'OTP',
                                prefixIcon: const Icon(Icons.lock_clock, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                prefixIcon: const Icon(Icons.lock, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isOtpSent ? _resetPassword : _sendOtp,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor:
                                    AppColors.getFormSubmitButtonColor(isDarkMode),
                              ),
                              child: Text(
                                _isOtpSent ? 'Reset Password' : 'Send OTP',
                                style: AppTextStyles.button16(isDarkMode),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Back to Login
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).go(RouteNames.login);
                            },
                            child: Text(
                              'Back to Login',
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
    );
  }
}
