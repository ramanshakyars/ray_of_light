import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/constants/common_button.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import '../../../core/config/routenames.dart';
import '../../../core/theme/appcolors.dart';
import '../../../core/theme/themeProvider.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: AppColors.getMonoTextPrimary(isDark),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mail_outline,
                    color: Colors.white),
              ),

              const SizedBox(height: 24),

              Text(
                'Check your email',
                style: AppTextStyles.monoBold22(isDark),
              ),

              const SizedBox(height: 8),

              Text(
                "We've sent a password reset link to your email.",
                textAlign: TextAlign.center,
                style: AppTextStyles.monoSecondary14(isDark),
              ),

              const SizedBox(height: 32),

              CommonButton(
                text: "Back to Login",
                onPressed: () =>
                    context.go(RouteNames.login),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
