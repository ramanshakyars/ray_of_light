import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
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

  String _weekday(int d) =>
      [
        "",
        "MONDAY",
        "TUESDAY",
        "WEDNESDAY",
        "THURSDAY",
        "FRIDAY",
        "SATURDAY",
        "SUNDAY",
      ][d];

  String _month(int m) =>
      [
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MoodBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final primaryColor = AppColors.getMonoTextPrimary(isDark);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// LEFT — Logo
          Image.asset('assets/logo.png', height: 26, color: primaryColor),

          const SizedBox(width: 14),

          /// CENTER — Greeting + Name → taps to Profile
          Expanded(
            child: GestureDetector(
              onTap: () => _goToProfile(context),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getGreeting()}, $userName",
                    style: AppTextStyles.monoBold22(isDark).copyWith(
                      fontSize: 22,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getDate(),
                    style: AppTextStyles.monoMuted12(isDark).copyWith(letterSpacing: 0.4),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// RIGHT — Mood only (profile accessible via greeting tap)
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => _openMoodSheet(context),
            child: _circleIcon(Icons.mood_outlined, isDark),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, bool isDark) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.getMonoSurface(isDark),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.getMonoBorder(isDark).withOpacity(0.4)),
      ),
      child: Icon(icon, size: 19, color: AppColors.getMonoIcon(isDark)),
    );
  }
}

