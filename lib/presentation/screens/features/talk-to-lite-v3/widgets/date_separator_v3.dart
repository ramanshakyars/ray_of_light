import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

/// WhatsApp-style date pill separator shown between messages of different days.
class DateSeparatorV3 extends StatelessWidget {
  final DateTime date;
  final bool isDark;

  const DateSeparatorV3({super.key, required this.date, required this.isDark});

  /// Returns "Today", "Yesterday", weekday name (within 7 days),
  /// or "DD Mon YYYY" for older dates.
  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) {
      const days = [
        'Monday', 'Tuesday', 'Wednesday',
        'Thursday', 'Friday', 'Saturday', 'Sunday'
      ];
      return days[date.weekday - 1];
    }

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.monoDarkSurface
                : const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _label(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.monoDarkTextSecondary
                  : const Color(0xFF555555),
            ),
          ),
        ),
      ),
    );
  }
}
