import 'package:flutter/material.dart';
import 'app_theme_colors.dart';
import 'appcolors.dart';

// ─────────────────────────────────────────────────────────────
// AppTextStyles — centralized typography system
//
// Font families registered in pubspec.yaml:
//   "Specimen"  → OpenSans Condensed (primary app font)
//
// All screen headers use identical sizing, weight, family, and height
// for consistent, modern typography throughout the app.
// ─────────────────────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  static const String _primaryFont = 'Poppins';

  // ─────────────────────────────────────────────────────────
  // THEME-AWARE STANDARDIZED TYPOGRAPHY (using ThemeColors & Poppins)
  // ─────────────────────────────────────────────────────────

  /// Screen / page header title — 19px semibold (600), -0.4 letter spacing, 1.2 line height
  static TextStyle screenTitle(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
        height: 1.2,
        letterSpacing: -0.4,
      );

  /// Section heading — 19px semibold
  static TextStyle sectionTitle(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
        height: 1.2,
        letterSpacing: -0.4,
      );

  /// Card / list item title — 15px semibold (600)
  static TextStyle cardTitle(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
      );

  /// Body text — 14px regular (400), 1.5 line height
  static TextStyle bodyText(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: c.textPrimary,
        height: 1.5,
      );

  /// Secondary body — 13px regular (400), 1.4 line height
  static TextStyle bodySecondary(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: c.textSecondary,
        height: 1.4,
      );

  /// Button text — 15px semibold
  static TextStyle buttonLabel(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: c.primaryForeground,
        letterSpacing: 0.2,
      );

  /// Small label / form label — 12px medium
  static TextStyle labelSmall(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: c.textMuted,
        letterSpacing: 1.1,
      );

  /// Section label (ALL CAPS) — 11px medium (500), 1.2 letter spacing
  static TextStyle sectionLabel(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: c.textMuted,
        letterSpacing: 1.2,
      );

  /// Dialog / modal title — 20px semibold
  static TextStyle dialogTitle(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
        height: 1.2,
      );

  /// Muted helper / hint — 12px regular (400)
  static TextStyle hintText(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: c.textMuted,
      );

  /// Navigation label — 11px medium
  static TextStyle navLabel(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: c.navActive,
      );

  /// Chat / AI response text
  static TextStyle chatText(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: c.textPrimary,
        height: 1.5,
      );

  /// Input field text
  static TextStyle inputText(ThemeColors c) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: c.textPrimary,
      );

  // ─────────────────────────────────────────────────────────
  // LEGACY STYLES — kept for backward compatibility
  // ─────────────────────────────────────────────────────────

  static TextStyle regular16(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 16,
        color: AppColors.getTextPrimaryColor(isDarkMode),
      );

  static TextStyle medium18(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.getTextPrimaryColor(isDarkMode),
      );

  static TextStyle medium22(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: AppColors.getTextPrimaryColor(isDarkMode),
      );

  static TextStyle buttonText(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.getTextSecondaryColor(isDarkMode),
      );

  static TextStyle bold28(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimaryColor(isDarkMode),
      );

  static TextStyle bold22(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimaryColor(isDarkMode),
      );

  static TextStyle regular14(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14,
        color: AppColors.getTextPrimaryColor(isDarkMode),
      );

  static TextStyle link14(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14,
        color: AppColors.getTextPrimaryColor(isDarkMode),
        decoration: TextDecoration.underline,
      );

  static TextStyle button16(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextSecondaryColor(isDarkMode),
      );

  static TextStyle chatBotText(bool isDarkMode) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.getTextPrimaryColor(isDarkMode),
        height: 1.3,
      );

  static TextStyle monoRegular16(bool isDark) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 16,
        color: AppColors.getMonoTextPrimary(isDark),
      );

  static TextStyle monoMedium18(bool isDark) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.getMonoTextPrimary(isDark),
      );

  static TextStyle monoBold22(bool isDark) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.getMonoTextPrimary(isDark),
      );

  static TextStyle monoSecondary14(bool isDark) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 14,
        color: AppColors.getMonoTextSecondary(isDark),
      );

  static TextStyle monoMuted12(bool isDark) => TextStyle(
        fontFamily: _primaryFont,
        fontSize: 12,
        color: AppColors.getMonoTextMuted(isDark),
      );
}
