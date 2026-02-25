import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'mono_primary_button.dart';

void showLogoutModal(BuildContext context) {
  final isDark = context.read<ThemeProvider>().isDarkMode;

  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: AppColors.getMonoCard(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.getMonoSurface(isDark),
              child: Icon(Icons.logout,
                  size: 35,
                  color: AppColors.getMonoTextPrimary(isDark)),
            ),
            const SizedBox(height: 20),
            Text(
              "Leave for now?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.getMonoTextPrimary(isDark),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your light will be here waiting for you whenever you return",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.getMonoTextSecondary(isDark),
              ),
            ),
            const SizedBox(height: 25),

            /// LOGOUT BUTTON
            MonoPrimaryButton(
              text: "Log Out",
              onPressed: () async {
                await LocalStorageService.clearAll();
                if (context.mounted) {
                  context.go(RouteNames.login);
                }
              },
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Stay",
                style: TextStyle(
                  color: AppColors.getMonoTextSecondary(isDark),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}