// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // font Color
  static const Color textPrimaryColor = Colors.black;
  static const Color textSecondryCOlor = Colors.white;

  // colors
  static const Color appBackgroundColor = Color(0xFFE3DBCD);
  // static const Color appBackgroundColor = Colors.transparent;
  static const Color talkToLiteButtonBackgroundColor = Color.fromARGB(255,154,150,142);
  // static const Color talkToLiteButtonBackgroundColor = Colors.transparent;

  // forms SUbmit buttons
  static const Color formSubmitButtonColor = Color.fromARGB(255, 255, 223, 163);
  static const Color formsCardColor = Color.fromARGB(255, 255, 241, 218);

 
   // Breathing circle
  static const Color breathingCircleColor = Color.fromARGB(255, 255, 211, 134);

   // 🔥 Darker Shades for Breathing Cycle
  static const Color inhaleColor = formSubmitButtonColor; // base
  static const Color inhaleDark = Color.fromARGB(255, 230, 190, 120);

  static const Color holdColor = talkToLiteButtonBackgroundColor; // base
  static const Color holdDark = Color.fromARGB(255, 100, 95, 90);

  static const Color exhaleColor = formsCardColor; // base
  static const Color exhaleDark = Color.fromARGB(255, 220, 200, 170);

  // font style
}
