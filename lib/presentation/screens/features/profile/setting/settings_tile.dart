import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final ThemeColors colors;

  // Backward-compatible isDark param (ignored if colors provided)
  final bool? isDark;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.colors = const _FallbackColors(),
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: Container(
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
        title: Text(
          title,
          style: AppTextStyles.cardTitle(colors),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: AppTextStyles.hintText(colors),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colors.textMuted,
          size: 20,
        ),
      ),
    );
  }
}

// Fallback for when the old isDark-based API is used without colors
class _FallbackColors implements ThemeColors {
  const _FallbackColors();

  @override
  Color get background => const Color(0xFFFFFFFF);
  @override
  Color get surface => const Color(0xFFF5F5F5);
  @override
  Color get card => const Color(0xFFFFFFFF);
  @override
  Color get cardBackground => card;
  @override
  Color get primary => const Color(0xFF000000);
  @override
  Color get primaryForeground => const Color(0xFFFFFFFF);
  @override
  Color get secondary => const Color(0xFFF0F0F0);
  @override
  Color get accent => const Color(0xFFE8E8E8);
  @override
  Color get textPrimary => const Color(0xFF000000);
  @override
  Color get textSecondary => const Color(0xFF6B7280);
  @override
  Color get textMuted => const Color(0xFF9CA3AF);
  @override
  Color get border => const Color(0xFFE5E7EB);
  @override
  Color get divider => const Color(0xFFE5E7EB);
  @override
  Color get icon => const Color(0xFF111111);
  @override
  Color get shadow => const Color(0x1A000000);
  @override
  Color get error => const Color(0xFFD4183D);
  @override
  Color get success => const Color(0xFF16A34A);
  @override
  Color get warning => const Color(0xFFF59E0B);
  @override
  Color get navBar => const Color(0xFFFFFFFF);
  @override
  Color get navBarBorder => const Color(0xFFE5E7EB);
  @override
  Color get navActive => const Color(0xFF000000);
  @override
  Color get navInactive => const Color(0xFFAAAAAA);
  @override
  Color get navGlow => const Color(0x22000000);
  @override
  Color get inputBackground => const Color(0xFFF3F3F5);
  @override
  Color get inputBorder => const Color(0xFFD1D5DB);
  @override
  Color get switchActive => const Color(0xFF000000);
  @override
  Color get switchActiveThumb => const Color(0xFFFFFFFF);
  @override
  Color get switchInactive => const Color(0xFFD1D5DB);
  @override
  Color get switchInactiveThumb => const Color(0xFF6B7280);
}