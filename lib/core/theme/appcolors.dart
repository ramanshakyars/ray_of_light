import 'package:flutter/material.dart';

class AppColors {
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // -------------------------
  // 🌞 LIGHT THEME COLORS
  // -------------------------

  // Core colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightForeground = Color(0xFF242424);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardForeground = Color(0xFF242424);
  static const Color lightPopover = Color(0xFFFFFFFF);
  static const Color lightPopoverForeground = Color(0xFF242424);
  static const Color lightPrimary = Color(0xFF030213);
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFF2F2F7);
  static const Color lightSecondaryForeground = Color(0xFF030213);
  static const Color lightMuted = Color(0xFFECECF0);
  static const Color lightMutedForeground = Color(0xFF717182);
  static const Color lightAccent = Color(0xFFE9EBEF);
  static const Color lightAccentForeground = Color(0xFF030213);
  static const Color lightDestructive = Color(0xFFD4183D);
  static const Color lightDestructiveForeground = Color(0xFFFFFFFF);
  static final Color lightBorder = Color(0xFF000000).withOpacity(0.1);
  static const Color lightInput = Colors.transparent;
  static const Color lightInputBackground = Color(0xFFF3F3F5);
  static const Color lightSwitchBackground = Color(0xFFCBCED4);
  static const Color lightRing = Color(0xFFB5B5B5);

  // Chart colors
  static const Color lightChart1 = Color(0xFFD94B13);
  static const Color lightChart2 = Color(0xFF009688);
  static const Color lightChart3 = Color(0xFF3F51B5);
  static const Color lightChart4 = Color(0xFFFF9800);
  static const Color lightChart5 = Color(0xFFFF5722);

  // Sidebar colors
  static const Color lightSidebar = Color(0xFFFBFBFB);
  static const Color lightSidebarForeground = Color(0xFF242424);
  static const Color lightSidebarPrimary = Color(0xFF030213);
  static const Color lightSidebarPrimaryForeground = Color(0xFFFBFBFB);
  static const Color lightSidebarAccent = Color(0xFFF7F7F7);
  static const Color lightSidebarAccentForeground = Color(0xFF343434);
  static const Color lightSidebarBorder = Color(0xFFEBEBEB);
  static const Color lightSidebarRing = Color(0xFFB5B5B5);

  // Breathing cycle colors (existing)
  static const Color lightInhaleDark = Color(0xFF374151);
  static const Color lightIconColor = Color(0xFF000000);
  static const Color lightIconWhiteColor = Color(0xFFFFFFFF);
  static const Color lightTextPrimaryColor = Color(0xFF0F0F0F);
  static const Color lightTextSecondaryColor = Color(0xFFFFFFFF);
  static const Color lightAppBackgroundColor = Color(0xFFFFFFFF);
  static final Color lightTalkToLiteButtonBackgroundColor = hexToColor(
    "#9333ea",
  );
  static final Color lightFormSubmitButtonColor = hexToColor("#9333ea");
  static const Color lightFormsCardColor = Color(0xFFFFFFFF);
  static const Color lightInputFieldBackgroundColor = Color(0xFFD5D4D1);
  static const Color lightBreathingCircleColor = Color(0xFFFBBF24);

  // Breathing cycle specific colors
  static final Color lightInhaleColor = lightFormSubmitButtonColor;
  static final Color lightHoldColor = lightTalkToLiteButtonBackgroundColor;
  static const Color lightHoldDark = Color(0xFF9CA3AF);
  static const Color lightExhaleColor = lightFormsCardColor;
  static const Color lightExhaleDark = Color(0xFFE5E7EB);

  // -------------------------
  // 🌚 DARK THEME COLORS
  // -------------------------

  // Core colors
  static const Color darkBackground = Color(0xFF242424);
  static const Color darkForeground = Color(0xFFFBFBFB);
  static const Color darkCard = Color(0xFF242424);
  static const Color darkCardForeground = Color(0xFFFBFBFB);
  static const Color darkPopover = Color(0xFF242424);
  static const Color darkPopoverForeground = Color(0xFFFBFBFB);
  static const Color darkPrimary = Color(0xFFFBFBFB);
  static const Color darkPrimaryForeground = Color(0xFF343434);
  static const Color darkSecondary = Color(0xFF444444);
  static const Color darkSecondaryForeground = Color(0xFFFBFBFB);
  static const Color darkMuted = Color(0xFF444444);
  static const Color darkMutedForeground = Color(0xFFB5B5B5);
  static const Color darkAccent = Color(0xFF444444);
  static const Color darkAccentForeground = Color(0xFFFBFBFB);
  static const Color darkDestructive = Color(0xFFB91D37);
  static const Color darkDestructiveForeground = Color(0xFFE53E5C);
  static const Color darkBorder = Color(0xFF444444);
  static const Color darkInput = Color(0xFF444444);
  static const Color darkRing = Color(0xFF707070);

  // Chart colors
  static const Color darkChart1 = Color(0xFF4A5FCF);
  static const Color darkChart2 = Color(0xFF00B894);
  static const Color darkChart3 = Color(0xFFFF5722);
  static const Color darkChart4 = Color(0xFF9C27B0);
  static const Color darkChart5 = Color(0xFFE74C3C);

  // Sidebar colors
  static const Color darkSidebar = Color(0xFF343434);
  static const Color darkSidebarForeground = Color(0xFFFBFBFB);
  static const Color darkSidebarPrimary = Color(0xFF4A5FCF);
  static const Color darkSidebarPrimaryForeground = Color(0xFFFBFBFB);
  static const Color darkSidebarAccent = Color(0xFF444444);
  static const Color darkSidebarAccentForeground = Color(0xFFFBFBFB);
  static const Color darkSidebarBorder = Color(0xFF444444);
  static const Color darkSidebarRing = Color(0xFF707070);

  // Breathing cycle colors (existing)
  static const Color darkIconColor = Color(0xFFF9FAFB);
  static const Color darkIconWhiteColor = Color(0xFFF9FAFB);
  static const Color darkTextPrimaryColor = Color(0xFFF9FAFB);
  static const Color darkTextSecondaryColor = Color(0xFFFFFFFF);
  static const Color darkAppBackgroundColor = Color(0xFF0F172A);
  static const Color darkTalkToLiteButtonBackgroundColor = Color(0xFF334155);
  static const Color darkFormSubmitButtonColor = Color(0xFF3B82F6);
  static const Color darkFormsCardColor = Color(0xFF1E293B);
  static const Color darkInputFieldBackgroundColor = Color(0xFF334155);
  static const Color darkBreathingCircleColor = Color(0xFFF59E0B);

  // Breathing cycle specific colors
  static const Color darkInhaleColor = darkFormSubmitButtonColor;
  static const Color darkInhaleDark = Color(0xFF1E40AF);
  static const Color darkHoldColor = darkTalkToLiteButtonBackgroundColor;
  static const Color darkHoldDark = Color(0xFF1E293B);
  static const Color darkExhaleColor = darkFormsCardColor;
  static const Color darkExhaleDark = Color(0xFF0F172A);

  // -------------------------
  // GETTER METHODS
  // -------------------------

  // Core color getters
  static Color getBackground(bool isDarkMode) =>
      isDarkMode ? darkBackground : lightBackground;
  static Color getForeground(bool isDarkMode) =>
      isDarkMode ? darkForeground : lightForeground;
  static Color getCard(bool isDarkMode) => isDarkMode ? darkCard : lightCard;
  static Color getCardForeground(bool isDarkMode) =>
      isDarkMode ? darkCardForeground : lightCardForeground;
  static Color getPopover(bool isDarkMode) =>
      isDarkMode ? darkPopover : lightPopover;
  static Color getPopoverForeground(bool isDarkMode) =>
      isDarkMode ? darkPopoverForeground : lightPopoverForeground;
  static Color getPrimary(bool isDarkMode) =>
      isDarkMode ? darkPrimary : lightPrimary;
  static Color getPrimaryForeground(bool isDarkMode) =>
      isDarkMode ? darkPrimaryForeground : lightPrimaryForeground;
  static Color getSecondary(bool isDarkMode) =>
      isDarkMode ? darkSecondary : lightSecondary;
  static Color getSecondaryForeground(bool isDarkMode) =>
      isDarkMode ? darkSecondaryForeground : lightSecondaryForeground;
  static Color getMuted(bool isDarkMode) => isDarkMode ? darkMuted : lightMuted;
  static Color getMutedForeground(bool isDarkMode) =>
      isDarkMode ? darkMutedForeground : lightMutedForeground;
  static Color getAccent(bool isDarkMode) =>
      isDarkMode ? darkAccent : lightAccent;
  static Color getAccentForeground(bool isDarkMode) =>
      isDarkMode ? darkAccentForeground : lightAccentForeground;
  static Color getDestructive(bool isDarkMode) =>
      isDarkMode ? darkDestructive : lightDestructive;
  static Color getDestructiveForeground(bool isDarkMode) =>
      isDarkMode ? darkDestructiveForeground : lightDestructiveForeground;
  static Color getBorder(bool isDarkMode) =>
      isDarkMode ? darkBorder : lightBorder;
  static Color getInput(bool isDarkMode) => isDarkMode ? darkInput : lightInput;
  static Color getInputBackground(bool isDarkMode) =>
      isDarkMode ? darkInputFieldBackgroundColor : lightInputBackground;
  static Color getSwitchBackground(bool isDarkMode) =>
      isDarkMode ? darkMuted : lightSwitchBackground;
  static Color getRing(bool isDarkMode) => isDarkMode ? darkRing : lightRing;

  // Chart color getters
  static Color getChart1(bool isDarkMode) =>
      isDarkMode ? darkChart1 : lightChart1;
  static Color getChart2(bool isDarkMode) =>
      isDarkMode ? darkChart2 : lightChart2;
  static Color getChart3(bool isDarkMode) =>
      isDarkMode ? darkChart3 : lightChart3;
  static Color getChart4(bool isDarkMode) =>
      isDarkMode ? darkChart4 : lightChart4;
  static Color getChart5(bool isDarkMode) =>
      isDarkMode ? darkChart5 : lightChart5;

  // Sidebar color getters
  static Color getSidebar(bool isDarkMode) =>
      isDarkMode ? darkSidebar : lightSidebar;
  static Color getSidebarForeground(bool isDarkMode) =>
      isDarkMode ? darkSidebarForeground : lightSidebarForeground;
  static Color getSidebarPrimary(bool isDarkMode) =>
      isDarkMode ? darkSidebarPrimary : lightSidebarPrimary;
  static Color getSidebarPrimaryForeground(bool isDarkMode) =>
      isDarkMode ? darkSidebarPrimaryForeground : lightSidebarPrimaryForeground;
  static Color getSidebarAccent(bool isDarkMode) =>
      isDarkMode ? darkSidebarAccent : lightSidebarAccent;
  static Color getSidebarAccentForeground(bool isDarkMode) =>
      isDarkMode ? darkSidebarAccentForeground : lightSidebarAccentForeground;
  static Color getSidebarBorder(bool isDarkMode) =>
      isDarkMode ? darkSidebarBorder : lightSidebarBorder;
  static Color getSidebarRing(bool isDarkMode) =>
      isDarkMode ? darkSidebarRing : lightSidebarRing;

  // Existing getters (kept for backward compatibility)
  static Color getIconColor(bool isDarkMode) =>
      isDarkMode ? darkIconColor : lightIconColor;
  static Color getIconWhiteColor(bool isDarkMode) =>
      isDarkMode ? darkIconWhiteColor : lightIconWhiteColor;
  static Color getTextPrimaryColor(bool isDarkMode) =>
      isDarkMode ? darkTextPrimaryColor : lightTextPrimaryColor;
  static Color getTextSecondaryColor(bool isDarkMode) =>
      isDarkMode ? darkTextSecondaryColor : lightTextSecondaryColor;
  static Color getAppBackgroundColor(bool isDarkMode) =>
      isDarkMode ? darkAppBackgroundColor : lightAppBackgroundColor;
  static Color getTalkToLiteButtonBackgroundColor(bool isDarkMode) =>
      isDarkMode
          ? darkTalkToLiteButtonBackgroundColor
          : lightTalkToLiteButtonBackgroundColor;
  static Color getFormSubmitButtonColor(bool isDarkMode) =>
      isDarkMode ? darkFormSubmitButtonColor : lightFormSubmitButtonColor;
  static Color getFormsCardColor(bool isDarkMode) =>
      isDarkMode ? darkFormsCardColor : lightFormsCardColor;
  static Color getInputFieldBackgroundColor(bool isDarkMode) =>
      isDarkMode
          ? darkInputFieldBackgroundColor
          : lightInputFieldBackgroundColor;
  static Color getBreathingCircleColor(bool isDarkMode) =>
      isDarkMode ? darkBreathingCircleColor : lightBreathingCircleColor;

  // Breathing cycle getters
  static Color getInhaleColor(bool isDarkMode) =>
      isDarkMode ? darkInhaleColor : lightInhaleColor;
  static Color getInhaleDark(bool isDarkMode) =>
      isDarkMode ? darkInhaleDark : lightInhaleDark;
  static Color getHoldColor(bool isDarkMode) =>
      isDarkMode ? darkHoldColor : lightHoldColor;
  static Color getHoldDark(bool isDarkMode) =>
      isDarkMode ? darkHoldDark : lightHoldDark;
  static Color getExhaleColor(bool isDarkMode) =>
      isDarkMode ? darkExhaleColor : lightExhaleColor;
  static Color getExhaleDark(bool isDarkMode) =>
      isDarkMode ? darkExhaleDark : lightExhaleDark;
}
