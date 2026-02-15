import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.menu,
            color: AppColors.getMonoIcon(isDark),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dream Garden",
                  style: AppTextStyles.monoBold22(isDark),
                ),
                const SizedBox(height: 2),
                Text(
                  "Plant your dreams and watch them grow",
                  style: AppTextStyles.monoSecondary14(isDark),
                ),
              ],
            ),
          ),

          Icon(
            Icons.auto_awesome_outlined,
            color: AppColors.getMonoIcon(isDark),
          ),
        ],
      ),
    );
  }
}
