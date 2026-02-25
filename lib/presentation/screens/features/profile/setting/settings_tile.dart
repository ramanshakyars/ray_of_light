import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.getMonoSurface(isDark),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.getMonoBackground(isDark),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.getMonoTextPrimary(isDark),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.getMonoTextPrimary(isDark),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getMonoTextSecondary(isDark),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.getMonoTextMuted(isDark),
        ),
      ),
    );
  }
}