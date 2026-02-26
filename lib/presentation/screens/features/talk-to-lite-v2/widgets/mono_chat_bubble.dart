import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MonoChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MonoChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.getMonoTextPrimary(isDark)
              : AppColors.getMonoSurface(isDark),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser
                ? AppColors.getMonoBackground(isDark)
                : AppColors.getMonoTextPrimary(isDark),
            fontFamily: "Arial",
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}