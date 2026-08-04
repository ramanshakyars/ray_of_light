import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;
  final ThemeColors colors;

  // Backward-compatible isDark param (ignored if colors provided)
  final bool? isDark;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.colors,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.5),
                width: 0.8,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colors.icon,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(colors),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.hintText(colors),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colors.switchActiveThumb,
            activeTrackColor: colors.switchActive,
            inactiveThumbColor: colors.switchInactiveThumb,
            inactiveTrackColor: colors.switchInactive,
          ),
        ],
      ),
    );
  }
}
