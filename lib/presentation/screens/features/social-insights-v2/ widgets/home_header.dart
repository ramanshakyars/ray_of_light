import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({
    super.key,
    required this.userName,
  });

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
      ["", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"][d];

  String _month(int m) =>
      ["", "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
       "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"][m];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// GREETING
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getGreeting()}, $userName",
                    style: AppTextStyles.monoBold22(isDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getDate(),
                    style: AppTextStyles.monoMuted12(isDark),
                  ),
                ],
              ),

              /// ACTIONS
              Row(
                children: [
                  _circleIcon(Icons.notifications_none, isDark),
                  const SizedBox(width: 10),
                  _circleIcon(Icons.person_outline, isDark),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            "Share your light today",
            style: AppTextStyles.monoSecondary14(isDark),
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
      ),
      child: Icon(
        icon,
        size: 18,
        color: AppColors.getMonoIcon(isDark),
      ),
    );
  }
}