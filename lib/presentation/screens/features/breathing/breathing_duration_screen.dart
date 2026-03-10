import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';


class BreathingDurationScreen extends StatelessWidget {
  const BreathingDurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: true).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                "Breathe",
                style: AppTextStyles.monoBold22(isDark),
              ),

              const SizedBox(height: 8),

              Text(
                "How long would you like to practice?",
                style: AppTextStyles.monoSecondary14(isDark),
              ),

              const SizedBox(height: 40),

              _tile(context, isDark, "Quick", "2 min"),
              _tile(context, isDark, "Centered", "5 min"),
              _tile(context, isDark, "Deep", "10 min"),
              _tile(context, isDark, "Open", "∞"),

              const SizedBox(height: 180),

              Text(
                "Choose what feels right today ? ",
                style: AppTextStyles.monoSecondary14(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    bool isDark,
    String title,
    String duration,
  ) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('${RouteNames.mainApp}/''${RouteNames.breathingExercise}/''${RouteNames.breathingPlayer}',
),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.getMonoDivider(isDark)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.monoMedium18(isDark)),
            Text(duration, style: AppTextStyles.monoSecondary14(isDark)),
          ],
        ),
      ),
    );
  }
}
