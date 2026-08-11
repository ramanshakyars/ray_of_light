import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

import 'breathing_model.dart';

class BreathingDurationScreen extends StatelessWidget {
  const BreathingDurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppScreenHeader(
                title: "Breathwork",
                subtitle: "Find your center. Align your mind and body.",
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.getMonoIcon(isDark),
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildExerciseCard(
                      context,
                      isDark,
                      "Awaken",
                      "Box Breathing",
                      "2 min",
                      Icons.square_outlined,
                      BreathingModel.defaultExercises[0], // Box Breathing
                    ),
                    _buildExerciseCard(
                      context,
                      isDark,
                      "Relax",
                      "4-7-8 Breathing",
                      "5 min",
                      Icons.waves_rounded,
                      BreathingModel.defaultExercises[1], // 4-7-8
                    ),
                    _buildExerciseCard(
                      context,
                      isDark,
                      "Focus",
                      "Resonance Breathing",
                      "10 min",
                      Icons.lens_blur_rounded,
                      BreathingModel.defaultExercises[2], // Resonance
                    ),
                    _buildExerciseCard(
                      context,
                      isDark,
                      "Free Flow",
                      "Open Ended Practice",
                      "∞",
                      Icons.all_inclusive_rounded,
                      BreathingModel.defaultExercises[3], // Open Flow
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    bool isDark,
    String title,
    String subtitle,
    String duration,
    IconData icon,
    BreathingModel model,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.getMonoSurface(isDark),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.getMonoTextPrimary(isDark).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            GoRouter.of(context).push(
              '${RouteNames.mainApp}/${RouteNames.breathingExercise}/${RouteNames.breathingPlayer}',
              extra: model,
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.getMonoTextPrimary(isDark).withValues(alpha: 0.04),
                    shape: BoxShape.circle,
                  ),
                    child: Icon(
                    icon,
                    color: AppColors.getMonoIcon(isDark),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.monoMedium18(isDark).copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.monoSecondary14(isDark).copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.getMonoTextPrimary(isDark).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    duration,
                    style: AppTextStyles.monoBold22(isDark).copyWith(
                      fontSize: 14,
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
