import 'package:flutter/material.dart';

class AppColors {
  // -------------------------
  // 🌞 LIGHT THEME COLORS
  // -------------------------
  static const Color textPrimaryColor = Color(0xFF0F0F0F); // --foreground
  static const Color textSecondryCOlor = Color(0xFFFFFFFF); // --primary-foreground

  static const Color appBackgroundColor = Color(0xFFFFFFFF); // --background
  static const Color talkToLiteButtonBackgroundColor = Color(0xFFF3F4F6); // --secondary
  static const Color formSubmitButtonColor = Color(0xFF111827); // --primary
  static const Color formsCardColor = Color(0xFFFFFFFF); // --card
  static const Color inputFieldBackgroundColor = Color.fromARGB(255, 213, 212, 209);

  // Breathing circle (extra aesthetic)
  static const Color breathingCircleColor = Color(0xFFFBBF24); // yellow accent

  // 🔥 Darker Shades for Breathing Cycle
  static const Color inhaleColor = formSubmitButtonColor;
  static const Color inhaleDark = Color(0xFF374151);

  static const Color holdColor = talkToLiteButtonBackgroundColor;
  static const Color holdDark = Color(0xFF9CA3AF);

  static const Color exhaleColor = formsCardColor;
  static const Color exhaleDark = Color(0xFFE5E7EB);

  // -------------------------
  // 🌚 DARK THEME COLORS
  // -------------------------
  static const Color darkTextPrimaryColor = Color(0xFFF9FAFB); // --foreground
  static const Color darkTextSecondryCOlor = Color(0xFFFFFFFF); // --primary-foreground

  static const Color darkAppBackgroundColor = Color(0xFF0F172A); // --background
  static const Color darkTalkToLiteButtonBackgroundColor = Color(0xFF334155); // --secondary
  static const Color darkFormSubmitButtonColor = Color(0xFF3B82F6); // --primary
  static const Color darkFormsCardColor = Color(0xFF1E293B); // --card

  static const Color darkBreathingCircleColor = Color(0xFFF59E0B); // warm yellow

  // 🔥 Darker Shades for Breathing Cycle
  static const Color darkInhaleColor = darkFormSubmitButtonColor;
  static const Color darkInhaleDark = Color(0xFF1E40AF);

  static const Color darkHoldColor = darkTalkToLiteButtonBackgroundColor;
  static const Color darkHoldDark = Color(0xFF1E293B);

  static const Color darkExhaleColor = darkFormsCardColor;
  static const Color darkExhaleDark = Color(0xFF0F172A);
}
