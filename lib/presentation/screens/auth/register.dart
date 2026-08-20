import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/constants/app_text_field.dart';
import 'package:rayoflite/core/constants/common_button.dart';
import 'package:rayoflite/core/constants/terms_constants.dart';
import 'package:rayoflite/core/providers/TokenManager.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/authService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/core/services/google_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
  bool _isGoogleLoading = false;
  bool _termsAccepted = false;
  bool _hasOpenedTermsOfUse = false;
  bool _hasOpenedCommunityGuidelines = false;

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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response =
          await AuthService.verifyOtp({'email': _emailController.text.trim()});

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

  // ================= CHECKBOX TOGGLE =================

  void _handleCheckboxToggle(bool? val) {
    if (_isLoading || _isGoogleLoading) return;

    if (!_hasOpenedTermsOfUse || !_hasOpenedCommunityGuidelines) {
      MessageService.showError(
        context,
        'Please open and read both the Terms of Use and Community Guidelines before accepting.',
      );
      return;
    }

    setState(() {
      _termsAccepted = val ?? false;
    });
  }

  // ================= REGISTER =================

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasOpenedTermsOfUse || !_hasOpenedCommunityGuidelines) {
      MessageService.showError(
        context,
        'Please open and read both the Terms of Use and Community Guidelines before accepting.',
      );
      return;
    }

    if (!_termsAccepted) {
      MessageService.showError(
        context,
        'Please check the box to agree to the Terms of Use and Community Guidelines.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final body = {
        'name': _nameController.text.trim(),
        'phoneNumber': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _dateOfBirthController.text.trim(),
        'password': _passwordController.text.trim(),
        'otp': _otpController.text.trim(),
        'termsAccepted': _termsAccepted,
        'termsVersion': TermsConstants.currentTermsVersion,
      };

      final response = await AuthService.register(body);

      if (!mounted) return;

      if (!response['success']) {
        MessageService.showError(context, response['message']);
        return;
      }

      MessageService.showSuccess(context, response['message']);
      context.go(RouteNames.login);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= GOOGLE SIGN-IN =================

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      final response = await GoogleAuthService.signIn();

      if (!mounted) return;

      if (response['cancelled'] == true) {
        // Quietly reset state without showing scary error popups
        return;
      }

      if (response['success'] == true) {
        final token = response['token'];
        final user = response['user'];

        await LocalStorageService.setToken(token);
        TokenManager.setToken(token);
        await LocalStorageService.setUser(user);
        await Provider.of<AuthProvider>(context, listen: false).loadUser();

        MessageService.showSuccess(
          context,
          response['message'] ?? 'Google Sign-In Successful',
        );

        GoRouter.of(context).go(
          '${RouteNames.mainApp}/${RouteNames.home}',
        );
      } else {
        MessageService.showError(
          context,
          response['message'] ?? 'Google Sign-In Failed',
        );
      }
    } catch (e) {
      if (mounted) {
        MessageService.showError(
          context,
          'Google Sign-In Failed: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 🔙 Back
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed:
                            _isLoading ? null : () => context.pop(),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: Text(
                          'Back',
                          style:
                              AppTextStyles.monoSecondary14(isDark),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🧊 Card
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
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Text(
                                'Begin your journey',
                                style:
                                    AppTextStyles.monoBold22(isDark),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Create your account and find your light',
                                style: AppTextStyles
                                    .monoSecondary14(isDark),
                              ),
                              const SizedBox(height: 28),

                              // 📧 Email
                              AppTextField(
                                controller: _emailController,
                                label: 'Email',
                                prefixIcon: Icons.email,
                                readOnly: _isOtpSent,
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

                              // 🔐 Send OTP
                              if (!_isOtpSent)
                                CommonButton(
                                  text: "Send OTP",
                                  isLoading: _isLoading,
                                  onPressed:
                                      _isLoading ? null : _sendOtp,
                                ),

                              // ✅ AFTER OTP
                              if (_isOtpSent) ...[
                                AppTextField(
                                  controller: _otpController,
                                  label: 'Enter OTP',
                                  prefixIcon: Icons.code,
                                  validator: (v) =>
                                      v == null || v.isEmpty
                                          ? 'Enter OTP'
                                          : null,
                                ),
                                const SizedBox(height: 16),

                                AppTextField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  prefixIcon: Icons.person,
                                  validator: (v) =>
                                      v == null || v.isEmpty
                                          ? 'Enter your name'
                                          : null,
                                ),
                                const SizedBox(height: 16),

                                AppTextField(
                                  controller: _mobileController,
                                  label: 'Mobile Number',
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),

                                // 📅 DOB
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
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Enter password';
                                    }
                                    if (v.length < 6) {
                                      return 'Minimum 6 characters';
                                    }
                                    return null;
                                  },
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

                                const SizedBox(height: 20),

                                // 📜 Terms & Guidelines Acceptance Checkbox
                                InkWell(
                                  onTap: () =>
                                      _handleCheckboxToggle(!_termsAccepted),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _termsAccepted,
                                        onChanged: _handleCheckboxToggle,
                                        activeColor: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        checkColor: isDark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 13,
                                                height: 1.4,
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black87,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'I have read and agree to the ',
                                                ),
                                                TextSpan(
                                                  text: 'Terms of Use',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.underline,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          setState(() {
                                                            _hasOpenedTermsOfUse =
                                                                true;
                                                          });
                                                          context.push(
                                                              RouteNames
                                                                  .termsOfUse);
                                                        },
                                                ),
                                                const TextSpan(
                                                  text: ' and ',
                                                ),
                                                TextSpan(
                                                  text: 'Community Guidelines',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.underline,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          setState(() {
                                                            _hasOpenedCommunityGuidelines =
                                                                true;
                                                          });
                                                          context.push(
                                                              RouteNames
                                                                  .communityGuidelines);
                                                        },
                                                ),
                                                const TextSpan(text: '.'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                CommonButton(
                                  text: "Create Account",
                                  isLoading: _isLoading,
                                  onPressed: (_isLoading || _isGoogleLoading)
                                      ? null
                                      : _register,
                                ),

                                /*
                                // ─── Google Sign-Up (Hidden on iOS for now) ───
                                if (!(!kIsWeb && Platform.isIOS) &&
                                    Theme.of(context).platform !=
                                        TargetPlatform.iOS) ...[
                                  const SizedBox(height: 16),

                                  // ─── OR Divider ──────────────────────
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? Colors.white12
                                              : Colors.black12,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          'OR',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                            color: isDark
                                                ? Colors.white38
                                                : Colors.black38,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? Colors.white12
                                              : Colors.black12,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // ─── Google Sign-Up Button ───────────
                                  _GoogleSignInButton(
                                    label: 'Sign up with Google',
                                    isLoading: _isGoogleLoading,
                                    isDarkMode: isDark,
                                    onPressed:
                                        (_isLoading || _isGoogleLoading)
                                            ? null
                                            : _handleGoogleSignIn,
                                  ),
                                ],
                                */

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
      ),
    );
  }
}

// ─── Reusable Google Sign-In Button ──────────────────────────────────────────

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({
    required this.label,
    required this.isLoading,
    required this.isDarkMode,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final bool isDarkMode;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDarkMode ? Colors.white24 : Colors.black12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: isDarkMode ? Colors.white10 : Colors.white,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleLogo(size: 20),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({this.size = 24});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.85);

    void drawArc(double startDeg, double sweepDeg, Color color) {
      final p = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18
        ..strokeCap = StrokeCap.butt;
      const pi = 3.141592653589793;
      canvas.drawArc(rect, startDeg * pi / 180, sweepDeg * pi / 180, false, p);
    }

    drawArc(-10, 110, const Color(0xFF4285F4));
    drawArc(100, 110, const Color(0xFF34A853));
    drawArc(210, 60, const Color(0xFFFBBC04));
    drawArc(270, 80, const Color(0xFFEA4335));

    final barPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
          cx, cy - size.height * 0.11, r * 0.85, size.height * 0.22),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
