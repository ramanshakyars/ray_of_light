import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/setting/mono_primary_button.dart';


class DeactivateAccountPage extends StatelessWidget {
  const DeactivateAccountPage({super.key});

  Future<void> _deactivate(BuildContext context) async {
    await HttpService.put(PathConfig.deleteAccount, {});
    await LocalStorageService.clearAll();
    if (context.mounted) {
      context.go(RouteNames.accountDeactivate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => context.pop(),
                child: Text(
                  "← Back",
                  style: TextStyle(
                    color: AppColors.getMonoTextSecondary(isDark),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.getMonoSurface(isDark),
                child: Icon(Icons.warning_amber_rounded,
                    size: 40,
                    color: AppColors.getMonoTextPrimary(isDark)),
              ),

              const SizedBox(height: 25),

              Text(
                "Deactivate Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getMonoTextPrimary(isDark),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "We're sad to see you go. Your account will be temporarily paused.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.getMonoTextSecondary(isDark),
                ),
              ),

              const SizedBox(height: 50),

              MonoPrimaryButton(
                text: "Continue to Deactivate",
                onPressed: () => _deactivate(context),
              ),

              const SizedBox(height: 15),

              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color:
                            AppColors.getMonoTextSecondary(isDark)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}