import 'package:flutter/material.dart';
import 'appcolors.dart';

class AppTextStyles {
  static TextStyle regular16(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 16,
    color: AppColors.getTextPrimaryColor(isDarkMode),
  );

  static TextStyle medium18(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.getTextPrimaryColor(isDarkMode),
  );

  static TextStyle medium22(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.getTextPrimaryColor(isDarkMode),
  );

  static TextStyle buttonText(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.getTextSecondaryColor(isDarkMode),
  );

  static TextStyle bold28(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.getTextPrimaryColor(isDarkMode),
  );

  static TextStyle bold22(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.getTextPrimaryColor(isDarkMode),
  );

  static TextStyle regular14(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 14,
    color: AppColors.getTextPrimaryColor(isDarkMode),
  );

  static TextStyle link14(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 14,
    color: AppColors.getTextPrimaryColor(isDarkMode),
    decoration: TextDecoration.underline,
  );

  static TextStyle button16(bool isDarkMode) => TextStyle(
    fontFamily: "Specimen",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.getTextSecondaryColor(isDarkMode),
  );

  static TextStyle chatBotText(bool isDarkMode) => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.getTextPrimaryColor(isDarkMode),
    height: 1.3,
  );

  // =====================================================
  // 🆕 MONO TEXT STYLES (NEW SYSTEM)
  // =====================================================

  static TextStyle monoRegular16(bool isDark) => TextStyle(
    fontFamily: "Arial",
    fontSize: 16,
    color: AppColors.getMonoTextPrimary(isDark),
  );

  static TextStyle monoMedium18(bool isDark) => TextStyle(
    fontFamily: "Arial",
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.getMonoTextPrimary(isDark),
  );

  static TextStyle monoBold22(bool isDark) => TextStyle(
    fontFamily: "Arial",
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.getMonoTextPrimary(isDark),
  );

  static TextStyle monoSecondary14(bool isDark) => TextStyle(
    fontFamily: "Arial",
    fontSize: 14,
    color: AppColors.getMonoTextSecondary(isDark),
  );

  static TextStyle monoMuted12(bool isDark) => TextStyle(
    fontFamily: "Arial",
    fontSize: 12,
    color: AppColors.getMonoTextMuted(isDark),
  );
}
