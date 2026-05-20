import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MonoChatBubbleV3 extends StatelessWidget {
  final String text;
  final bool isUser;

  const MonoChatBubbleV3({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    if (!isUser) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.getMonoTextPrimary(isDark),
              fontFamily: "Arial",
              fontSize: 15,
              height: 1.35,
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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: AppColors.getMonoTextPrimary(isDark),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.getMonoBackground(isDark),
            fontFamily: "Arial",
            fontSize: 15,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
