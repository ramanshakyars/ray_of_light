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
}
