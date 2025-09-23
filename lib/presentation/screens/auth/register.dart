import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/authService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

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

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      MessageService.showError(context, 'Please enter a valid email!');
      return;
    }

    final response = await AuthService.verifyOtp({'email': email});

    if (response['success'] == true) {
      setState(() {
        _isOtpSent = true;
      });
      MessageService.showSuccess(context, response['message']);
    } else {
      MessageService.showError(context, response['message']);
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final body = {
        'name': _nameController.text.trim(),
        'phoneNumber': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _dateOfBirthController.text.trim(),
        'password': _passwordController.text.trim(),
        'otp': _otpController.text.trim(),
      };

      final response = await AuthService.register(body);

      if (!response['success']) {
        MessageService.showError(context, response['message']);
        return;
      }

      MessageService.showSuccess(context, response['message']);
      if (mounted) {
        GoRouter.of(context).go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isPortrait ? 500 : 700,
              maxHeight: screenHeight,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isPortrait ? 20.0 : screenWidth * 0.1,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPortrait || screenHeight > 400) ...[
                  Image.asset('assets/logo.png', height: isPortrait ? 80 : 60),
                  SizedBox(height: isPortrait ? 10 : 5),
                  Text(
                    'Ray of Light',
                    style: TextStyle(
                      fontSize: isPortrait ? 32 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: isPortrait ? 5 : 4),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isPortrait ? 0 : 20,
                    ),
                    child: Text(
                      'We are here to help you to be better than yesterday',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isPortrait ? 14 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: isPortrait ? 30 : 20),
                ],
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Padding(
                          padding: EdgeInsets.all(isPortrait ? 20.0 : 16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min, // 👈 height wraps content
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: isPortrait ? 24 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: isPortrait ? 20 : 15),
                                // Email Field
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email, size: 20),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
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
                                  readOnly: _isOtpSent,
                                ),
                                SizedBox(height: 12),
                                if (!_isOtpSent)
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _sendOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.formSubmitButtonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      child: Text('Send OTP'),
                                    ),
                                  ),
                                if (_isOtpSent) ...[
                                  TextFormField(
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Enter OTP',
                                      prefixIcon: Icon(Icons.code, size: 20),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                                if (_isOtpSent) ...[
                                  SizedBox(height: 12),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      prefixIcon: Icon(Icons.person, size: 20),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  TextFormField(
                                    controller: _mobileController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number',
                                      prefixIcon: Icon(Icons.phone, size: 20),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    validator: (value) {
                                      // if (value == null || value.isEmpty) {
                                      //   return 'Please enter your mobile number';
                                      // }
                                      if (value != null && value.isNotEmpty) {
                                        if (value.length < 10) {
                                          return 'Enter a valid mobile number';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () async {
                                      final values =
                                          await showCalendarDatePicker2Dialog(
                                            context: context,
                                            config: CalendarDatePicker2WithActionButtonsConfig(
                                              calendarType:
                                                  CalendarDatePicker2Type
                                                      .single,
                                              selectedDayHighlightColor:
                                                  Colors.blue,
                                              firstDate: DateTime(
                                                1900,
                                              ), // min date
                                              lastDate:
                                                  DateTime.now(), // stop selecting future dates
                                            ),
                                            dialogSize: Size(
                                              screenWidth * 0.9,
                                              screenHeight * 0.5,
                                            ),
                                          );

                                      if (values != null && values.isNotEmpty) {
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
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: _dateOfBirthController,
                                        decoration: InputDecoration(
                                          labelText: 'Date Of Birth',
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            size: 20,
                                          ),
                                          suffixIcon: Icon(
                                            Icons.arrow_drop_down,
                                            size: 20,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value != null &&
                                              value.isNotEmpty) {
                                            try {
                                              final dob = DateTime.parse(value);
                                              final today = DateTime.now();
                                              final age =
                                                  today.year -
                                                  dob.year -
                                                  ((today.month < dob.month ||
                                                          (today.month ==
                                                                  dob.month &&
                                                              today.day <
                                                                  dob.day))
                                                      ? 1
                                                      : 0);

                                              if (age < 14) {
                                                return 'Age must be at least 14 years';
                                              }
                                            } catch (e) {
                                              return 'Please enter a valid date';
                                            }
                                          }
                                          return null; // no error if empty
                                        },
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 12),
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
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
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
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _register,
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      child: Text(
                                        'Register',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  TextButton(
                                    onPressed: () {
                                      GoRouter.of(
                                        context,
                                      ).push(RouteNames.login);
                                    },
                                    child: Text(
                                      'Already have an account? Login',
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
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
