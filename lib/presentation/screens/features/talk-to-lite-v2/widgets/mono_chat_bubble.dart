import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MonoChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MonoChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    if (!isUser) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 8),
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.getMonoTextPrimary(isDark),
              fontFamily: "Poppins",
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: AppColors.getMonoTextPrimary(isDark),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.getMonoBackground(isDark),
            fontFamily: "Poppins",
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}