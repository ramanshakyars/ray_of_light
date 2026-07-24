import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import 'package:rayoflite/core/config/google_auth_config.dart';

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
  bool _isGoogleLoading = false;

  final GoogleSignIn _googleSignIn = GoogleAuthConfig.googleSignIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Helper: post-login routing ──────────────────────────────────────────

  void _handleAuthRedirect(Map<String, dynamic> user) {
    final roles = user['roles'];
    final isAdmin = roles == 'ROLE_ADMIN' ||
        (roles is List &&
            (roles.contains('ROLE_ADMIN') || roles.contains('ADMIN')));

    if (isAdmin) {
      // Admin → could navigate to admin dashboard; adjust route if needed
      GoRouter.of(context).go('${RouteNames.mainApp}/${RouteNames.home}');
    } else {
      GoRouter.of(context).go('${RouteNames.mainApp}/${RouteNames.home}');
    }
  }

  // ─── Helper: persist session after successful login ───────────────────────

  Future<void> _persistSession(Map<String, dynamic> response) async {
    final token = response['token'];
    final user = response['user'];

    await LocalStorageService.setToken(token);
    TokenManager.setToken(token);
    await LocalStorageService.setUser(user);
    await Provider.of<AuthProvider>(context, listen: false).loadUser();
  }

  // ─── Standard credentials login ──────────────────────────────────────────

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
        await _persistSession(response);

        MessageService.showSuccess(
          context,
          response['message'] ?? 'Login Successful!',
        );

        _handleAuthRedirect(response['user']);
      } else {
        MessageService.showError(
          context,
          response['message'] ?? 'Login failed!',
        );
      }
    } catch (e) {
      if (mounted) MessageService.showError(context, 'Something went wrong');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Google OAuth Sign-In ─────────────────────────────────────────────────

  /// Mirrors the React handleGoogleSuccess:
  ///   1. Trigger Google Sign-In to get the ID token.
  ///   2. POST {idToken} to /public/login/google.
  ///   3. Store the backend JWT, load user, navigate.
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      // Sign out first so the account picker always shows
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // null means: user cancelled OR misconfiguration (missing SHA-1 / wrong client ID).
        // Log so the exact cause can be seen in the terminal.
        dev.log(
          '[GoogleSignIn] signIn() returned null — either the user dismissed '
          'the picker, or the SHA-1 fingerprint is not registered in '
          'Firebase Console / Google Cloud Console.',
          name: 'GoogleOAuth',
        );
        if (mounted) {
          MessageService.showError(
            context,
            'Google Sign-In was cancelled or is not configured for this device. '
            'Please contact support.',
          );
          setState(() => _isGoogleLoading = false);
        }
        return;
      }
      dev.log('[GoogleSignIn] account: ${googleUser.email}', name: 'GoogleOAuth');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        dev.log(
          '[GoogleSignIn] idToken is null — check that client_type:3 '
          '(web client) is present in google-services.json.',
          name: 'GoogleOAuth',
        );
        if (mounted) {
          MessageService.showError(
              context, 'Google authentication failed: no ID token');
          setState(() => _isGoogleLoading = false);
        }
        return;
      }
      dev.log('[GoogleSignIn] idToken obtained, posting to backend.', name: 'GoogleOAuth');

      // POST idToken to your Spring Boot backend
      final response = await AuthService.googleLogin(idToken);

      if (!mounted) return;

      if (response['success'] == true) {
        await _persistSession(response);

        MessageService.showSuccess(
          context,
          response['message'] ?? 'Google Login Successful',
        );

        _handleAuthRedirect(response['user']);
      } else {
        MessageService.showError(
          context,
          response['message'] ?? 'Google Login Failed',
        );
      }
    } catch (e, st) {
      dev.log('[GoogleSignIn] exception: $e', name: 'GoogleOAuth', error: e, stackTrace: st);
      if (mounted) {
        MessageService.showError(
            context, 'Google Login Failed: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDarkMode),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
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

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  /// 🔹 Card
                  Container(
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
                              style:
                                  AppTextStyles.monoSecondary14(isDarkMode),
                            ),

                            const SizedBox(height: 20),

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

                            const SizedBox(height: 14),

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
                                onPressed: () => context.push(
                                    RouteNames.forgotPassword),
                                child: Text(
                                  'Forgot password?',
                                  style: AppTextStyles.monoSecondary14(
                                    isDarkMode,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            /// Login button
                            CommonButton(
                              text: 'Log In',
                              isLoading: _isLoading,
                              onPressed: (_isLoading || _isGoogleLoading)
                                  ? null
                                  : _login,
                            ),

                            const SizedBox(height: 14),

                            /// ─── OR Divider ──────────────────────────────
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: isDarkMode
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
                                      color: isDarkMode
                                          ? Colors.white38
                                          : Colors.black38,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: isDarkMode
                                        ? Colors.white12
                                        : Colors.black12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            /// ─── Google Sign-In Button ───────────────────
                            _GoogleSignInButton(
                              isLoading: _isGoogleLoading,
                              isDarkMode: isDarkMode,
                              onPressed: (_isLoading || _isGoogleLoading)
                                  ? null
                                  : _handleGoogleSignIn,
                            ),

                            const SizedBox(height: 14),

                            Center(
                              child: TextButton(
                                onPressed: () =>
                                    context.push(RouteNames.register),
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
                  // Google "G" logo painted manually — no extra package needed
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

/// Draws the Google "G" logo using a CustomPainter — no SVG or image asset
/// needed.
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
