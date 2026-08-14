import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/google_auth_service.dart';
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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ================= OTP FORGOT PASSWORD =================

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      MessageService.showError(context, 'Please enter a valid email!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.sendOtpForgetPassword({'email': email});

      if (!mounted) return;

      if (response['success'] == true) {
        setState(() => _isOtpSent = true);
        MessageService.showSuccess(context, response['message'] ?? 'OTP sent successfully!');
      } else {
        MessageService.showError(context, response['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      if (mounted) MessageService.showError(context, 'Something went wrong');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= RESET PASSWORD =================

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      MessageService.showError(context, 'Passwords do not match!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final otp = _otpController.text.trim();

      final body = {
        'email': email,
        'otp': otp,
        'newPassword': password,
        'password': password,
      };

      final response = await AuthService.resetPassword(body);

      if (!mounted) return;

      if (response['success'] == true) {
        MessageService.showSuccess(context, response['message'] ?? 'Password reset successful!');
        context.go(RouteNames.login);
      } else {
        MessageService.showError(context, response['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      if (mounted) MessageService.showError(context, 'Something went wrong');
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
                        style: AppTextStyles.monoSecondary14(isDark),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                              'Reset your password',
                              style: AppTextStyles.monoBold22(isDark),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Recover your credentials and find your light',
                              style: AppTextStyles.monoSecondary14(isDark),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),

                            /// Email
                            AppTextField(
                              controller: _emailController,
                              label: 'Email',
                              prefixIcon: Icons.email,
                              readOnly: _isOtpSent,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Enter your email';
                                if (!v.contains('@')) return 'Enter a valid email';
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            /// Send OTP Button
                            if (!_isOtpSent)
                              CommonButton(
                                text: "Send OTP",
                                isLoading: _isLoading,
                                onPressed: _isLoading ? null : _sendOtp,
                              ),

                            /// AFTER OTP SENT
                            if (_isOtpSent) ...[
                              AppTextField(
                                controller: _otpController,
                                label: 'Enter OTP',
                                prefixIcon: Icons.code,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Enter the OTP' : null,
                              ),
                              const SizedBox(height: 16),

                              AppTextField(
                                controller: _passwordController,
                                label: 'New Password',
                                prefixIcon: Icons.lock,
                                obscureText: !_isPasswordVisible,
                                validator: (v) =>
                                    v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(() =>
                                      _isPasswordVisible = !_isPasswordVisible),
                                ),
                              ),
                              const SizedBox(height: 16),

                              AppTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                prefixIcon: Icons.lock,
                                obscureText: !_isConfirmPasswordVisible,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Confirm your password' : null,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(() =>
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible),
                                ),
                              ),
                              const SizedBox(height: 28),

                              CommonButton(
                                text: "Reset Password",
                                isLoading: _isLoading,
                                onPressed: _isLoading ? null : _resetPassword,
                              ),
                            ],

                            if (Theme.of(context).platform !=
                                TargetPlatform.iOS) ...[
                              const SizedBox(height: 24),

                              Row(
                                children: [
                                  Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('OR', style: AppTextStyles.monoSecondary14(isDark)),
                                  ),
                                  Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12)),
                                ],
                              ),

                              const SizedBox(height: 16),

                              _GoogleSignInButton(
                                isLoading: _isGoogleLoading,
                                isDarkMode: isDark,
                                onPressed: (_isLoading || _isGoogleLoading)
                                    ? null
                                    : _handleGoogleSignIn,
                              ),
                            ],

                            const SizedBox(height: 16),

                            Center(
                              child: TextButton(
                                onPressed: () => context.go(RouteNames.login),
                                child: Text(
                                  'Back to Login',
                                  style: AppTextStyles.monoSecondary14(isDark),
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

// ─── Reusable Google Sign-In Button ──────────────────────────────────────────

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({
    required this.isLoading,
    required this.isDarkMode,
    required this.onPressed,
  });

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
                    'Continue with Google',
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

    // Circle background
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // Draw four colour arcs: blue, red, yellow, green
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

    drawArc(-10, 110, const Color(0xFF4285F4)); // blue
    drawArc(100, 110, const Color(0xFF34A853)); // green
    drawArc(210, 60, const Color(0xFFFBBC04)); // yellow
    drawArc(270, 80, const Color(0xFFEA4335)); // red

    // White "arm" pointing right (gap + horizontal bar of the G)
    final barPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - size.height * 0.11,
          r * 0.85, size.height * 0.22),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
