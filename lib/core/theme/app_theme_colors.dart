import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// ENUM: Available application themes
// ─────────────────────────────────────────────────────────────

enum AppTheme {
  mono,         // Theme 1 – Monochrome (clean black/white)
  goldenLuxury, // Theme 2 – Golden Luxury (100% warm ivory + gold palette)
  oceanDepth,   // Theme 3 – Ocean Depth (deep navy + teal)
  sakuraZen,    // Theme 4 – Sakura Zen (soft pink + blush)
  emeraldNight, // Theme 5 – Emerald Night (emerald green + onyx black)
}

extension AppThemeExtension on AppTheme {
  String get displayName {
    switch (this) {
      case AppTheme.mono:
        return 'Monochrome';
      case AppTheme.goldenLuxury:
        return 'Golden Luxury';
      case AppTheme.oceanDepth:
        return 'Ocean Depth';
      case AppTheme.sakuraZen:
        return 'Sakura Zen';
      case AppTheme.emeraldNight:
        return 'Emerald Night';
    }
  }

  String get displaySubtitle {
    switch (this) {
      case AppTheme.mono:
        return 'Clean monochrome — timeless & minimal';
      case AppTheme.goldenLuxury:
        return '100% warm gold & ivory — elegant & opulent';
      case AppTheme.oceanDepth:
        return 'Deep navy & teal — calm & focused';
      case AppTheme.sakuraZen:
        return 'Blush & rose — soft & nurturing';
      case AppTheme.emeraldNight:
        return 'Onyx & emerald — modern & high contrast';
    }
  }

  String get storageKey => name;
}

// ─────────────────────────────────────────────────────────────
// VALUE CLASS: ThemeColors — all semantic tokens in one object
// ─────────────────────────────────────────────────────────────

class ThemeColors {
  // Backgrounds
  final Color background;
  final Color surface;
  final Color card;

  // Brand
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color accent;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Structural
  final Color border;
  final Color divider;
  final Color icon;
  final Color shadow;

  // Semantic
  final Color error;
  final Color success;
  final Color warning;

  // Navigation
  final Color navBar;
  final Color navBarBorder;
  final Color navActive;
  final Color navInactive;
  final Color navGlow;

  // Input / Form
  final Color inputBackground;
  final Color inputBorder;

  // Switch
  final Color switchActive;
  final Color switchActiveThumb;
  final Color switchInactive;
  final Color switchInactiveThumb;

  const ThemeColors({
    required this.background,
    required this.surface,
    required this.card,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.icon,
    required this.shadow,
    required this.error,
    required this.success,
    required this.warning,
    required this.navBar,
    required this.navBarBorder,
    required this.navActive,
    required this.navInactive,
    required this.navGlow,
    required this.inputBackground,
    required this.inputBorder,
    required this.switchActive,
    required this.switchActiveThumb,
    required this.switchInactive,
    required this.switchInactiveThumb,
  });
}

// ─────────────────────────────────────────────────────────────
// FACTORY: AppThemeColors — returns ThemeColors for any theme
// ─────────────────────────────────────────────────────────────

class AppThemeColors {
  AppThemeColors._();

  static ThemeColors fromTheme(AppTheme theme, bool isDark) {
    switch (theme) {
      case AppTheme.mono:
        return isDark ? _monoDark : _monoLight;
      case AppTheme.goldenLuxury:
        return isDark ? _goldenDark : _goldenLight;
      case AppTheme.oceanDepth:
        return isDark ? _oceanDark : _oceanLight;
      case AppTheme.sakuraZen:
        return isDark ? _sakuraDark : _sakuraLight;
      case AppTheme.emeraldNight:
        return isDark ? _emeraldDark : _emeraldLight;
    }
  }

  // ── Preview swatches (primary + surface for each theme) ──
  static Color previewPrimary(AppTheme theme, bool isDark) =>
      fromTheme(theme, isDark).primary;
  static Color previewSurface(AppTheme theme, bool isDark) =>
      fromTheme(theme, isDark).surface;
  static Color previewBackground(AppTheme theme, bool isDark) =>
      fromTheme(theme, isDark).background;

  // ─────────────────────────────────────────────────────────
  // THEME 1 — MONO (clean black/white system)
  // ─────────────────────────────────────────────────────────

  static const ThemeColors _monoLight = ThemeColors(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF5F5F7),
    card: Color(0xFFFFFFFF),
    primary: Color(0xFF111111),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFEEEEEE),
    accent: Color(0xFFE5E5E5),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF666666),
    textMuted: Color(0xFF999999),
    border: Color(0xFFE5E5E5),
    divider: Color(0xFFE5E5E5),
    icon: Color(0xFF111111),
    shadow: Color(0x1A000000),
    error: Color(0xFFD4183D),
    success: Color(0xFF16A34A),
    warning: Color(0xFFF59E0B),
    navBar: Color(0xFFFFFFFF),
    navBarBorder: Color(0xFFE5E5E5),
    navActive: Color(0xFF111111),
    navInactive: Color(0xFFAAAAAA),
    navGlow: Color(0x22000000),
    inputBackground: Color(0xFFF5F5F7),
    inputBorder: Color(0xFFE0E0E0),
    switchActive: Color(0xFF111111),
    switchActiveThumb: Color(0xFFFFFFFF),
    switchInactive: Color(0xFFD1D5DB),
    switchInactiveThumb: Color(0xFF6B7280),
  );

  static const ThemeColors _monoDark = ThemeColors(
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF141414),
    card: Color(0xFF1A1A1A),
    primary: Color(0xFFFFFFFF),
    primaryForeground: Color(0xFF000000),
    secondary: Color(0xFF262626),
    accent: Color(0xFF333333),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFCCCCCC),
    textMuted: Color(0xFF888888),
    border: Color(0xFF282828),
    divider: Color(0xFF282828),
    icon: Color(0xFFFFFFFF),
    shadow: Color(0x40000000),
    error: Color(0xFFFF6B6B),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    navBar: Color(0xFF141414),
    navBarBorder: Color(0xFF282828),
    navActive: Color(0xFFFFFFFF),
    navInactive: Color(0xFF666666),
    navGlow: Color(0x33FFFFFF),
    inputBackground: Color(0xFF1A1A1A),
    inputBorder: Color(0xFF333333),
    switchActive: Color(0xFFFFFFFF),
    switchActiveThumb: Color(0xFF000000),
    switchInactive: Color(0xFF444444),
    switchInactiveThumb: Color(0xFF888888),
  );

  // ─────────────────────────────────────────────────────────
  // THEME 2 — GOLDEN LUXURY (100% Golden Combination — Zero Plain White)
  // ─────────────────────────────────────────────────────────

  static const ThemeColors _goldenLight = ThemeColors(
    background: Color(0xFFFAF4E8),   // Rich Golden Ivory Background (NO WHITE)
    surface: Color(0xFFF0E4D0),      // Soft Cream Gold Surface (NO WHITE)
    card: Color(0xFFF7EEDD),         // Warm Luminous Gold Card (NO WHITE)
    primary: Color(0xFFC59B3F),      // Rich Brushed Gold Accent
    primaryForeground: Color(0xFFFAF4E8), // Warm Golden Ivory Text on Gold Buttons
    secondary: Color(0xFFEADBC0),    // Warm Champagne Gold Secondary
    accent: Color(0xFFD6B36A),       // Bright Golden Highlight
    textPrimary: Color(0xFF221C11),  // Crisp Deep Onyx Gold Text
    textSecondary: Color(0xFF5E4C2A), // Dark Golden Sienna Text
    textMuted: Color(0xFF8C754A),    // Dark Muted Gold Text
    border: Color(0xFFE4D3B6),       // Fine Golden Border
    divider: Color(0xFFE4D3B6),
    icon: Color(0xFF221C11),         // Dark Onyx Icon
    shadow: Color(0x22C59B3F),       // Subtle Gold Shadow
    error: Color(0xFFC0392B),
    success: Color(0xFF4A7C59),
    warning: Color(0xFFD49E2A),
    navBar: Color(0xFFF3E6CE),       // Soft Golden Nav
    navBarBorder: Color(0xFFDECBA9), // Golden Border
    navActive: Color(0xFFC59B3F),    // Gold Active
    navInactive: Color(0xFF8C754A),  // Muted Gold Inactive
    navGlow: Color(0x38C59B3F),      // Gold Glow
    inputBackground: Color(0xFFEFE1C9), // Golden Parchment Input Background (NO WHITE)
    inputBorder: Color(0xFFDECBA9),
    switchActive: Color(0xFFC59B3F),
    switchActiveThumb: Color(0xFFFAF4E8),
    switchInactive: Color(0xFFE4D3B6),
    switchInactiveThumb: Color(0xFF8C754A),
  );

  static const ThemeColors _goldenDark = ThemeColors(
    background: Color(0xFF161109),   // Deep Obsidian Gold Black
    surface: Color(0xFF20190D),      // Dark Golden Amber Surface
    card: Color(0xFF2B2112),         // Rich Warm Golden Card
    primary: Color(0xFFE5C178),      // Luminous Gold Primary Accent
    primaryForeground: Color(0xFF161109), // Deep Gold Black Text on Primary
    secondary: Color(0xFF382B18),    // Deep Amber Secondary
    accent: Color(0xFFD6B36A),       // Warm Gold Highlight
    textPrimary: Color(0xFFF5E5C9),  // Crisp Golden Ivory Text
    textSecondary: Color(0xFFD8C29D), // Golden Sand Secondary Text
    textMuted: Color(0xFF9E8866),    // Muted Warm Gold Text
    border: Color(0xFF42331C),       // Rich Golden Border
    divider: Color(0xFF42331C),
    icon: Color(0xFFE5C178),         // Bright Gold Icon
    shadow: Color(0x50000000),
    error: Color(0xFFFF6B6B),
    success: Color(0xFF6BCE86),
    warning: Color(0xFFE5C178),
    navBar: Color(0xFF20190D),
    navBarBorder: Color(0xFF42331C),
    navActive: Color(0xFFE5C178),
    navInactive: Color(0xFF8C7756),
    navGlow: Color(0x44E5C178),
    inputBackground: Color(0xFF2B2112),
    inputBorder: Color(0xFF42331C),
    switchActive: Color(0xFFE5C178),
    switchActiveThumb: Color(0xFF161109),
    switchInactive: Color(0xFF42331C),
    switchInactiveThumb: Color(0xFF9E8866),
  );

  // ─────────────────────────────────────────────────────────
  // THEME 3 — OCEAN DEPTH (deep navy + soft teal)
  // ─────────────────────────────────────────────────────────

  static const ThemeColors _oceanLight = ThemeColors(
    background: Color(0xFFF0F7FA),
    surface: Color(0xFFE4EFF5),
    card: Color(0xFFFFFFFF),
    primary: Color(0xFF2D7FA0),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFD0E8F0),
    accent: Color(0xFF1A6688),
    textPrimary: Color(0xFF0A2840),
    textSecondary: Color(0xFF4A7490),
    textMuted: Color(0xFF8BAEC4),
    border: Color(0xFFBDD8E8),
    divider: Color(0xFFBDD8E8),
    icon: Color(0xFF1A4A68),
    shadow: Color(0x1A2D7FA0),
    error: Color(0xFFCC3B5A),
    success: Color(0xFF2E9E6E),
    warning: Color(0xFFE89A2E),
    navBar: Color(0xFFF5FAFB),
    navBarBorder: Color(0xFFC0DDE8),
    navActive: Color(0xFF2D7FA0),
    navInactive: Color(0xFF8BAEC4),
    navGlow: Color(0x332D7FA0),
    inputBackground: Color(0xFFE8F3F8),
    inputBorder: Color(0xFFAACCDC),
    switchActive: Color(0xFF2D7FA0),
    switchActiveThumb: Color(0xFFFFFFFF),
    switchInactive: Color(0xFFBDD8E8),
    switchInactiveThumb: Color(0xFF8BAEC4),
  );

  static const ThemeColors _oceanDark = ThemeColors(
    background: Color(0xFF0A1628),
    surface: Color(0xFF0F2040),
    card: Color(0xFF162845),
    primary: Color(0xFF4AB4D8),
    primaryForeground: Color(0xFF0A1628),
    secondary: Color(0xFF1A3358),
    accent: Color(0xFF2D9DC4),
    textPrimary: Color(0xFFE8F4F8),
    textSecondary: Color(0xFF8BAEC4),
    textMuted: Color(0xFF4A7490),
    border: Color(0xFF1F3C60),
    divider: Color(0xFF1F3C60),
    icon: Color(0xFF7ECCE8),
    shadow: Color(0x40000000),
    error: Color(0xFFFF7A8A),
    success: Color(0xFF5DC8A0),
    warning: Color(0xFFFFCC6A),
    navBar: Color(0xFF0F2040),
    navBarBorder: Color(0xFF1F3C60),
    navActive: Color(0xFF4AB4D8),
    navInactive: Color(0xFF4A7490),
    navGlow: Color(0x444AB4D8),
    inputBackground: Color(0xFF162845),
    inputBorder: Color(0xFF1F3C60),
    switchActive: Color(0xFF4AB4D8),
    switchActiveThumb: Color(0xFF0A1628),
    switchInactive: Color(0xFF1F3C60),
    switchInactiveThumb: Color(0xFF4A7490),
  );

  // ─────────────────────────────────────────────────────────
  // THEME 4 — SAKURA ZEN (blush rose + soft pink)
  // ─────────────────────────────────────────────────────────

  static const ThemeColors _sakuraLight = ThemeColors(
    background: Color(0xFFFDF6F0),
    surface: Color(0xFFF9EDE8),
    card: Color(0xFFFFFFFF),
    primary: Color(0xFFC9748F),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFF0D8DC),
    accent: Color(0xFFB85C78),
    textPrimary: Color(0xFF2A1520),
    textSecondary: Color(0xFF9B6878),
    textMuted: Color(0xFFBF9FAA),
    border: Color(0xFFEDD5D8),
    divider: Color(0xFFEDD5D8),
    icon: Color(0xFF6B3348),
    shadow: Color(0x1AC9748F),
    error: Color(0xFFB83B3B),
    success: Color(0xFF6BAA78),
    warning: Color(0xFFD4872E),
    navBar: Color(0xFFFDF8F6),
    navBarBorder: Color(0xFFEDCDD2),
    navActive: Color(0xFFC9748F),
    navInactive: Color(0xFFBF9FAA),
    navGlow: Color(0x33C9748F),
    inputBackground: Color(0xFFF5E5E8),
    inputBorder: Color(0xFFE0C0C8),
    switchActive: Color(0xFFC9748F),
    switchActiveThumb: Color(0xFFFFFFFF),
    switchInactive: Color(0xFFEDD5D8),
    switchInactiveThumb: Color(0xFFBF9FAA),
  );

  static const ThemeColors _sakuraDark = ThemeColors(
    background: Color(0xFF180D10),
    surface: Color(0xFF221318),
    card: Color(0xFF2C1820),
    primary: Color(0xFFE896AE),
    primaryForeground: Color(0xFF180D10),
    secondary: Color(0xFF3A1E28),
    accent: Color(0xFFD4788A),
    textPrimary: Color(0xFFFCEFF2),
    textSecondary: Color(0xFFD4A8B5),
    textMuted: Color(0xFF9B6878),
    border: Color(0xFF3D2030),
    divider: Color(0xFF3D2030),
    icon: Color(0xFFF0B0C0),
    shadow: Color(0x40000000),
    error: Color(0xFFFF8A8A),
    success: Color(0xFF88CC88),
    warning: Color(0xFFFFBB66),
    navBar: Color(0xFF221318),
    navBarBorder: Color(0xFF3D2030),
    navActive: Color(0xFFE896AE),
    navInactive: Color(0xFF6B4050),
    navGlow: Color(0x44E896AE),
    inputBackground: Color(0xFF2C1820),
    inputBorder: Color(0xFF3D2030),
    switchActive: Color(0xFFE896AE),
    switchActiveThumb: Color(0xFF180D10),
    switchInactive: Color(0xFF3D2030),
    switchInactiveThumb: Color(0xFF9B6878),
  );

  // ─────────────────────────────────────────────────────────
  // THEME 5 — EMERALD NIGHT (Green & Black Theme)
  // ─────────────────────────────────────────────────────────

  static const ThemeColors _emeraldLight = ThemeColors(
    background: Color(0xFFF4F8F5),
    surface: Color(0xFFE5EFE8),
    card: Color(0xFFFFFFFF),
    primary: Color(0xFF1B6B42),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFD2E6D8),
    accent: Color(0xFF279B60),
    textPrimary: Color(0xFF0F2618),
    textSecondary: Color(0xFF3F664F),
    textMuted: Color(0xFF7A9E89),
    border: Color(0xFFC8DEC0),
    divider: Color(0xFFC8DEC0),
    icon: Color(0xFF1B6B42),
    shadow: Color(0x1B1B6B42),
    error: Color(0xFFCC3B3B),
    success: Color(0xFF1B6B42),
    warning: Color(0xFFD4872E),
    navBar: Color(0xFFF4F8F5),
    navBarBorder: Color(0xFFC8DEC0),
    navActive: Color(0xFF1B6B42),
    navInactive: Color(0xFF7A9E89),
    navGlow: Color(0x381B6B42),
    inputBackground: Color(0xFFEAF2EB),
    inputBorder: Color(0xFFC8DEC0),
    switchActive: Color(0xFF1B6B42),
    switchActiveThumb: Color(0xFFFFFFFF),
    switchInactive: Color(0xFFC8DEC0),
    switchInactiveThumb: Color(0xFF7A9E89),
  );

  static const ThemeColors _emeraldDark = ThemeColors(
    background: Color(0xFF08120B),
    surface: Color(0xFF102115),
    card: Color(0xFF162B1D),
    primary: Color(0xFF2ECC71),
    primaryForeground: Color(0xFF08120B),
    secondary: Color(0xFF1F3D29),
    accent: Color(0xFF25B865),
    textPrimary: Color(0xFFE8F5EE),
    textSecondary: Color(0xFFA1CCA8),
    textMuted: Color(0xFF5B8566),
    border: Color(0xFF1F3A27),
    divider: Color(0xFF1F3A27),
    icon: Color(0xFF2ECC71),
    shadow: Color(0x50000000),
    error: Color(0xFFFF6B6B),
    success: Color(0xFF2ECC71),
    warning: Color(0xFFFFC107),
    navBar: Color(0xFF102115),
    navBarBorder: Color(0xFF1F3A27),
    navActive: Color(0xFF2ECC71),
    navInactive: Color(0xFF43694E),
    navGlow: Color(0x442ECC71),
    inputBackground: Color(0xFF162B1D),
    inputBorder: Color(0xFF1F3A27),
    switchActive: Color(0xFF2ECC71),
    switchActiveThumb: Color(0xFF08120B),
    switchInactive: Color(0xFF1F3A27),
    switchInactiveThumb: Color(0xFF5B8566),
  );
}
