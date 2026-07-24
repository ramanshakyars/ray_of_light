import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MonoChatBubbleV3 extends StatelessWidget {
  final String text;
  final bool isUser;
  final String? timestamp;

  const MonoChatBubbleV3({super.key, required this.text, required this.isUser,
   this.timestamp});

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "";
    try {
      final dt = DateTime.parse(timeStr).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final min = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$min $ampm";
    } catch (e) {
      return "";
    }
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: AppColors.getMonoTextPrimary(isDark),
                  fontFamily: "Arial",
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              if (timestamp != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatTime(timestamp),
                  style: TextStyle(
                    color: AppColors.getMonoTextPrimary(isDark).withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ]
            ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColors.getMonoBackground(isDark),
                fontFamily: "Arial",
                fontSize: 15,
                height: 1.35,
              ),
            ),
            if (timestamp != null) ...[
              const SizedBox(height: 4),
              Text(
                _formatTime(timestamp),
                style: TextStyle(
                  color: AppColors.getMonoBackground(isDark).withOpacity(0.7),
                  fontSize: 10,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
