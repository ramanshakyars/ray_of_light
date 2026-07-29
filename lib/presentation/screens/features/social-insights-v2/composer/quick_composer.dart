import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class QuickComposer extends StatelessWidget {
  final VoidCallback onPhotoTap;
  final VoidCallback onMoodTap;
  final VoidCallback onTextTap;

  const QuickComposer({
    super.key,
    required this.onPhotoTap,
    required this.onMoodTap,
    required this.onTextTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final primaryColor = AppColors.getMonoTextPrimary(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.getMonoBorder(isDark).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit_rounded, size: 18, color: AppColors.getMonoIcon(isDark)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Share something...",
              style: AppTextStyles.monoSecondary14(isDark).copyWith(fontSize: 15),
            ),
          ),
          _item(Icons.image_outlined, onPhotoTap, isDark),
          const SizedBox(width: 16),
          _item(Icons.emoji_emotions_outlined, onMoodTap, isDark),
          const SizedBox(width: 16),
          _item(Icons.text_fields_rounded, onTextTap, isDark),
        ],
      ),
    );
  }

  Widget _item(IconData icon, VoidCallback tap, bool isDark) {
    return GestureDetector(
      onTap: tap,
      child: Icon(icon, color: AppColors.getMonoIcon(isDark), size: 22),
    );
  }
}