import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/messageService.dart';

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
  final _confirmPasswordController = TextEditingController();

  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isOtpSent = true;
      });
      MessageService.showSuccess(context, 'OTP sent to your email');
    }
  }

  void _verifyOtp() {
    if (_otpController.text.isNotEmpty) {
      setState(() {
        _isOtpVerified = true;
      });
      MessageService.showSuccess(context, 'OTP verified successfully');
    } else {
      MessageService.showError(context, 'Please enter OTP');
    }
  }

  void _resetPassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      MessageService.showError(context, 'Passwords do not match');
      return;
    }
    if (_newPasswordController.text.length < 6) {
      MessageService.showError(
        context,
        'Password must be at least 6 characters',
      );
      return;
    }

    MessageService.showSuccess(context, 'Password reset successfully');
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        GoRouter.of(context).go(RouteNames.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500, // Limits the width on larger screens
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    // Add your logo image here (make sure it's in your assets folder)
                    Image.asset(
                      'assets/logo.png', // Update with your actual image path
                      height: 80, // Adjust size as needed
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ray of Light',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'We are here to help you to be better than yesterday',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isOtpVerified
                            ? 'Reset Password'
                            : _isOtpSent
                            ? 'Verify OTP'
                            : 'Forgot Password',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Field (shown initially and hidden after OTP verification)
                      if (!_isOtpVerified) ...[
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
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
                        const SizedBox(height: 15),
                      ],

                      // OTP Field (shown after OTP is sent)
                      if (_isOtpSent && !_isOtpVerified) ...[
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'OTP',
                            prefixIcon: Icon(Icons.lock_clock),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter OTP';
                            }
                            if (value.length != 6) {
                              return 'OTP must be 6 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                      ],

                      // New Password Field (shown after OTP verification)
                      if (_isOtpVerified) ...[
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: const Icon(Icons.lock),
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
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                      ],

                      const SizedBox(height: 20),

                      // Action Button (changes based on state)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isOtpVerified
                                  ? _resetPassword
                                  : _isOtpSent
                                  ? _verifyOtp
                                  : _sendOtp,
                          child: Text(
                            _isOtpVerified
                                ? 'Reset Password'
                                : _isOtpSent
                                ? 'Verify OTP'
                                : 'Send OTP',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Back to Login Link
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).go(RouteNames.login);
                        },
                        child: const Text('Back to Login'),
                      ),
                    ],
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
