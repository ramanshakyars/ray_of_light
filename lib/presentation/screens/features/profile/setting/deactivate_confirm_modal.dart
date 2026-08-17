import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

void showDeactivateConfirmModal(BuildContext context) {
  final isDark = context.read<ThemeProvider>().isDarkMode;

  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: AppColors.getMonoCard(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.getMonoSurface(isDark),
              child: Icon(
                Icons.favorite_border,
                size: 30,
                color: AppColors.getMonoTextPrimary(isDark),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "We'll miss your light",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.getMonoTextPrimary(isDark),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your account and data will be permanently deleted. This action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.getMonoTextSecondary(isDark),
              ),
            ),
            const SizedBox(height: 25),

            /// Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                onPressed: () async {
                  await HttpService.put(PathConfig.deleteAccount, {});
                  await LocalStorageService.clearAll();
                  if (context.mounted) {
                    context.go(RouteNames.accountDeactivate);
                  }
                },
                child: const Text("Delete Account"),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Keep My Account",
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