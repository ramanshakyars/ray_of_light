import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = themeProvider.colors;
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 12),

              // ── Header ──
              AppScreenHeader(
                title: 'Appearance',
                subtitle: 'Choose your visual experience',
                bottomPadding: 0,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: colors.icon,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Dark Mode toggle ──
              _DarkModeToggle(colors: colors, isDark: isDark),

              const SizedBox(height: 28),

              // ── Section label ──
              Text(
                'THEMES',
                style: AppTextStyles.sectionLabel(colors),
              ),

              const SizedBox(height: 14),

              // ── Theme cards for all 5 themes ──
              ...AppTheme.values.map((theme) {
                final isSelected = themeProvider.selectedTheme == theme;
                return _ThemeCard(
                  theme: theme,
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () => themeProvider.setAppTheme(theme),
                );
              }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Dark Mode Toggle Card
// ─────────────────────────────────────────────────────────────

class _DarkModeToggle extends StatelessWidget {
  final ThemeColors colors;
  final bool isDark;

  const _DarkModeToggle({required this.colors, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: colors.icon,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDark ? 'Dark Mode' : 'Light Mode',
                  style: AppTextStyles.cardTitle(colors),
                ),
                const SizedBox(height: 2),
                Text(
                  isDark ? 'Dark & immersive' : 'Bright & clear',
                  style: AppTextStyles.hintText(colors),
                ),
              ],
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
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

// ─────────────────────────────────────────────────────────────
// Theme Selection Card
// ─────────────────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentColors = context.watch<ThemeProvider>().colors;
    final previewColors = AppThemeColors.fromTheme(theme, isDark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: currentColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? currentColors.primary
                : currentColors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: currentColors.primary.withValues(alpha: 0.18),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // ── Radio indicator ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? currentColors.primary
                      : currentColors.border,
                  width: 2,
                ),
                color: isSelected
                    ? currentColors.primary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 13,
                      color: currentColors.primaryForeground,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            // ── Text info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.displayName,
                    style: AppTextStyles.cardTitle(currentColors),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    theme.displaySubtitle,
                    style: AppTextStyles.hintText(currentColors),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // ── Color swatch preview ──
            _ColorSwatchPreview(previewColors: previewColors),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Compact color swatch row (mini palette preview)
// ─────────────────────────────────────────────────────────────

class _ColorSwatchPreview extends StatelessWidget {
  final ThemeColors previewColors;

  const _ColorSwatchPreview({required this.previewColors});

  @override
  Widget build(BuildContext context) {
    final swatches = [
      previewColors.background,
      previewColors.primary,
      previewColors.textSecondary,
      previewColors.surface,
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 52,
        height: 32,
        child: Row(
          children: swatches
              .map(
                (c) => Expanded(
                  child: ColoredBox(color: c),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
