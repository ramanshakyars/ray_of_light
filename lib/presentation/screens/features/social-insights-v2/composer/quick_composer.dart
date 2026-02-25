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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _item("Photo", Icons.image_outlined, onPhotoTap, isDark),
        _item("Mood", Icons.emoji_emotions_outlined, onMoodTap, isDark),
        _item("Text", Icons.text_fields, onTextTap, isDark),
      ],
    );
  }

  Widget _item(String label, IconData icon, VoidCallback tap, bool isDark) {
    return GestureDetector(
      onTap: tap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.getMonoIcon(isDark)),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.monoMuted12(isDark)),
        ],
      ),
    );
  }
}