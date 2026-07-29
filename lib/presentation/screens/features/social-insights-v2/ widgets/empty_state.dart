import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final primaryColor = AppColors.getMonoTextPrimary(isDark);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_outlined,
                size: 38,
                color: primaryColor.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Posts Yet",
              style: AppTextStyles.monoBold22(isDark).copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              "Be the first to share your light ✨",
              textAlign: TextAlign.center,
              style: AppTextStyles.monoSecondary14(isDark).copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}