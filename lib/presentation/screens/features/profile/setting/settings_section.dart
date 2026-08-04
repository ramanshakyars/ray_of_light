import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final ThemeColors? colors;

  const SettingsSection({
    super.key,
    required this.title,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided colors or fallback from theme
    final c = colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: c != null
          ? Text(
              title,
              style: AppTextStyles.sectionLabel(c),
            )
          : Text(
              title,
              style: const TextStyle(
                fontFamily: 'Specimen',
                fontSize: 11,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
              ),
            ),
    );
  }
}