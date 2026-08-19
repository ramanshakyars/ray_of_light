import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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
    final themeProvider = context.watch<ThemeProvider>();
    final colors = themeProvider.colors;
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 12),

              /// HEADER
              AppScreenHeader(
                title: 'Settings',
                subtitle: 'Manage your account and preferences',
                bottomPadding: 0,
                actions: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.close,
                      color: colors.icon,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// PROFILE
              SettingsSection(title: 'PROFILE', colors: colors),
              SettingsTile(
                icon: Icons.mood_outlined,
                title: 'Mood Manager',
                subtitle: 'Change your mood',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const MoodBottomSheet(),
                  );
                },
                colors: colors,
              ),

              const SizedBox(height: 30),

              /// PREFERENCES
              SettingsSection(title: 'PREFERENCES', colors: colors),

              SettingsSwitchTile(
                icon: isDark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                title: 'Dark Mode',
                subtitle: isDark ? 'Dark & immersive' : 'Bright and clear',
                value: isDark,
                onChanged: (_) {
                  context.read<ThemeProvider>().toggleTheme();
                },
                colors: colors,
              ),

              /// APPEARANCE (Theme switcher)
              // SettingsTile(
              //   icon: Icons.palette_outlined,
              //   title: 'Appearance',
              //   subtitle:
              //       '${themeProvider.selectedTheme.displayName} theme',
              //   onTap: () => context.push(
              //     '${RouteNames.mainApp}/${RouteNames.themeSettings}',
              //   ),
              //   colors: colors,
              // ),


              // SettingsTile(
              //   icon: Icons.lock_outline,
              //   title: 'Privacy',
              //   subtitle: 'Control your data',
              //   onTap: () {},
              //   colors: colors,
              // ),

              // SettingsTile(
              //   icon: Icons.description_outlined,
              //   title: 'Terms & Conditions',
              //   subtitle: 'Read our T&C',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => TermsAndConditionsPage(),
              //       ),
              //     );
              //   },
              //   colors: colors,
              // ),

              const SizedBox(height: 30),

              /// LEGAL & SAFETY
              SettingsSection(title: 'LEGAL & SAFETY', colors: colors),

              SettingsTile(
                icon: Icons.gavel_outlined,
                title: 'Terms of Use',
                subtitle: 'Read our platform rules & policies',
                onTap: () => context.push(RouteNames.termsOfUse),
                colors: colors,
              ),

              SettingsTile(
                icon: Icons.verified_user_outlined,
                title: 'Community Guidelines',
                subtitle: 'Read user safety & conduct guidelines',
                onTap: () => context.push(RouteNames.communityGuidelines),
                colors: colors,
              ),

              SettingsTile(
                icon: Icons.policy_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () => context.push(RouteNames.privacyPolicy),
                colors: colors,
              ),

              const SizedBox(height: 30),

              /// ACCOUNT
              SettingsSection(title: 'ACCOUNT', colors: colors),

              SettingsTile(
                icon: Icons.logout,
                title: 'Log Out',
                subtitle: 'See you soon',
                onTap: () => showLogoutModal(context),
                colors: colors,
              ),

              SettingsTile(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: () {
                  context.push(
                    '${RouteNames.mainApp}/${RouteNames.deactivateAccount}',
                  );
                },
                colors: colors,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
