import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/config/routenames.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // 👉 change route if needed
            context.go(RouteNames.landingPage);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(),

                  /// 🔹 small divider with dot
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.getMonoDivider(isDark),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF59E0B), // orange dot
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.getMonoDivider(isDark),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// 🔹 Main affirmation text
                  Text(
                    "I am better than yesterday",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.monoMedium18(isDark).copyWith(
                      fontSize: 22, // 👈 tuned for design
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  /// 🔹 bottom hint
                  Text(
                    "TAP ANYWHERE TO CONTINUE",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.monoMuted12(isDark).copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}