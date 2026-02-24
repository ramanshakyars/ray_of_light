import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/constants/app_text_field.dart';
import 'package:rayoflite/core/constants/common_button.dart';
import 'package:rayoflite/core/services/authService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  DateTime? _selectedDate;

  bool _isPasswordVisible = false;
  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // ================= OTP =================

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      MessageService.showError(context, 'Please enter a valid email!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.verifyOtp({'email': email});

      if (!mounted) return;

      if (response['success'] == true) {
        setState(() => _isOtpSent = true);
        MessageService.showSuccess(context, response['message']);
      } else {
        MessageService.showError(context, response['message']);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= REGISTER =================

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final body = {
        'name': _nameController.text.trim(),
        'phoneNumber': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _dateOfBirthController.text.trim(),
        'password': _passwordController.text.trim(),
        'otp': _otpController.text.trim(),
      };

      final response = await AuthService.register(body);

      if (!mounted) return;

      if (!response['success']) {
        MessageService.showError(context, response['message']);
        return;
      }

      MessageService.showSuccess(context, response['message']);
      GoRouter.of(context).go(RouteNames.login);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// 🔹 Back
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        'Back',
                        style:
                            AppTextStyles.monoSecondary14(isDark),
                      ),
                    ),
                  ),

                  const SizedBox(height: 200),

                  /// 🔹 Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.getMonoCard(isDark),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Text(
                              'Begin your journey',
                              style:
                                  AppTextStyles.monoBold22(isDark),
                                  textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Create your account and find your light',
                              style: AppTextStyles
                                  .monoSecondary14(isDark),
                                   textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),

                            /// Email
                            AppTextField(
                              controller: _emailController,
                              label: 'Email',
                              prefixIcon: Icons.email,
                              readOnly: _isOtpSent,
                            ),

                            const SizedBox(height: 16),

                            /// Send OTP
                            if (!_isOtpSent)
                              CommonButton(
                                text: "Send OTP",
                                isLoading: _isLoading,
                                onPressed:
                                    _isLoading ? null : _sendOtp,
                              ),

                            /// AFTER OTP
                            if (_isOtpSent) ...[
                              AppTextField(
                                controller: _otpController,
                                label: 'Enter OTP',
                                prefixIcon: Icons.code,
                              ),
                              const SizedBox(height: 16),

                              AppTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                prefixIcon: Icons.person,
                              ),
                              const SizedBox(height: 16),

                              AppTextField(
                                controller: _mobileController,
                                label: 'Mobile Number',
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 16),

                              /// DOB
                              AppTextField(
                                controller: _dateOfBirthController,
                                label: 'Date Of Birth',
                                prefixIcon: Icons.calendar_today,
                                readOnly: true,
                                onTap: () async {
                                  final values =
                                      await showCalendarDatePicker2Dialog(
                                    context: context,
                                    dialogSize: const Size(350, 400),
                                    config:
                                        CalendarDatePicker2WithActionButtonsConfig(
                                      calendarType:
                                          CalendarDatePicker2Type.single,
                                      lastDate: DateTime.now(),
                                    ),
                                  );

                                  if (values != null &&
                                      values.isNotEmpty) {
                                    setState(() {
                                      _selectedDate = values[0];
                                      _dateOfBirthController.text =
                                          _selectedDate!
                                              .toIso8601String()
                                              .split('T')
                                              .first;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16),

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
                                  onPressed: () => setState(() =>
                                      _isPasswordVisible =
                                          !_isPasswordVisible),
                                ),
                              ),

                              const SizedBox(height: 28),

                              CommonButton(
                                text: "Create Account",
                                isLoading: _isLoading,
                                onPressed: _isLoading
                                    ? null
                                    : _register,
                              ),

                              const SizedBox(height: 16),

                              Center(
                                child: TextButton(
                                  onPressed: () =>
                                      context.push(RouteNames.login),
                                  child: Text(
                                    'Already have an account? Log in',
                                    style: AppTextStyles
                                        .monoSecondary14(isDark),
                                  ),
                                ),
                              ),
                            ],
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
