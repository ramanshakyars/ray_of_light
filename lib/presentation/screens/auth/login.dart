import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/authService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

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

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
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
                      SizedBox(height: 16),
                      Text(
                        'Ray of Light',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We are here to help you to be better than yesterday',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 32),
                    ],
                    // Login Form
                    Card(
                      color:AppColors.formsCardColor,
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Login/Signup',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ), // 👈 border radius here
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
                              SizedBox(height: 12),
                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ), // 👈 border radius here
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
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    GoRouter.of(
                                      context,
                                    ).push(RouteNames.forgotPassword);
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmallScreen ? 12 : 16,
                                    ),
                                    backgroundColor: AppColors.formSubmitButtonColor,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  GoRouter.of(
                                    context,
                                  ).push(RouteNames.register);
                                },
                                child: Text(
                                  'Don\'t have an account? Sign Up',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 14,
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
      ),
    );
  }
}
