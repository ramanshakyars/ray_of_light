import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/presentation/screens/features/profile/setting/logout_modal.dart';
import 'package:rayoflite/presentation/screens/features/profile/setting/settings_section.dart';
import 'package:rayoflite/presentation/screens/features/profile/setting/settings_switch_tile.dart';
import 'package:rayoflite/presentation/screens/features/profile/setting/settings_tile.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

import '../../ṃood-manager/mood_bottom_sheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 12),

              /// HEADER
              AppScreenHeader(
                title: "Settings",
                subtitle: "Manage your account and preferences",
                bottomPadding: 0,
                actions: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.getMonoIcon(isDark),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// PROFILE
              const SettingsSection(title: "PROFILE"),
              SettingsTile(
                icon: Icons.mood_outlined,
                title: "Mood Manager",
                subtitle: "Change your mood ",
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const MoodBottomSheet(),
                  );
                },
                isDark: isDark,
              ),

              const SizedBox(height: 30),

              /// PREFERENCES
              const SettingsSection(title: "PREFERENCES"),

              SettingsSwitchTile(
                icon: Icons.light_mode_outlined,
                title: "Dark Mode",
                subtitle: "Bright and clear",
                value: isDark,
                onChanged: (_) {
                  context.read<ThemeProvider>().toggleTheme();
                },
                isDark: isDark,
              ),

              SettingsTile(
                icon: Icons.notifications_none,
                title: "Notifications",
                subtitle: "Manage alerts",
                onTap: () {},
                isDark: isDark,
              ),

              SettingsTile(
                icon: Icons.lock_outline,
                title: "Privacy",
                subtitle: "Control your data",
                onTap: () {},
                isDark: isDark,
              ),

              const SizedBox(height: 30),

              /// ACCOUNT
              const SettingsSection(title: "ACCOUNT"),

              SettingsTile(
                icon: Icons.logout,
                title: "Log Out",
                subtitle: "See you soon",
                onTap: () => showLogoutModal(context),
                isDark: isDark,
              ),

              SettingsTile(
                icon: Icons.warning_amber_rounded,
                title: "Deactivate Account",
                subtitle: "Temporarily pause",
                onTap: () {
                  context.push(
                    '${RouteNames.mainApp}/${RouteNames.deactivateAccount}',
                  );
                },
                isDark: isDark,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
