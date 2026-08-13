import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

import '../../ṃood-manager/mood_bottom_sheet.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String _getDate() {
    final now = DateTime.now();
    return "${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}";
  }

  String _weekday(int d) => [
        "",
        "MONDAY",
        "TUESDAY",
        "WEDNESDAY",
        "THURSDAY",
        "FRIDAY",
        "SATURDAY",
        "SUNDAY",
      ][d];

  String _month(int m) => [
        "",
        "JANUARY",
        "FEBRUARY",
        "MARCH",
        "APRIL",
        "MAY",
        "JUNE",
        "JULY",
        "AUGUST",
        "SEPTEMBER",
        "OCTOBER",
        "NOVEMBER",
        "DECEMBER",
      ][m];

  void _goToProfile(BuildContext context) {
    context.push('${RouteNames.mainApp}/${RouteNames.profile}');
  }

  void _openMoodSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MoodBottomSheet(),
    );
  }

  String _capitalize(String text) {
    if (text.trim().isEmpty) return text;
    return text.trim().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// CENTER — Greeting + Name → taps to Profile
          Expanded(
            child: GestureDetector(
              onTap: () => _goToProfile(context),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getGreeting()}, ${_capitalize(userName)}",
                    style: AppTextStyles.screenTitle(colors).copyWith(
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getDate(),
                    style: AppTextStyles.labelSmall(colors).copyWith(
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// RIGHT — Mood
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => _openMoodSheet(context),
            child: _circleIcon(Icons.mood_outlined, colors),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, dynamic colors) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.border.withValues(alpha: 0.4),
        ),
      ),
      child: Icon(icon, size: 19, color: colors.icon),
    );
  }
}
