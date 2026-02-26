import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class DeactivateAccountPage extends StatefulWidget {
  const DeactivateAccountPage({super.key});

  @override
  State<DeactivateAccountPage> createState() =>
      _DeactivateAccountPageState();
}

class _DeactivateAccountPageState
    extends State<DeactivateAccountPage> {

  int? selectedReasonIndex;

  final List<String> reasons = [
    "Taking a break from social apps",
    "Privacy concerns",
    "Not finding it helpful",
    "Technical issues",
    "Other reasons",
  ];

  Future<void> _deactivate() async {
    await HttpService.put(PathConfig.deleteAccount, {});
    await LocalStorageService.clearAll();
    if (mounted) {
      context.go(RouteNames.accountDeactivate);
    }
  }

  void _showFinalConfirmation(bool isDark) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.getMonoCard(isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// ICON
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.getMonoSurface(isDark),
                child: Icon(
                  Icons.favorite_border,
                  size: 32,
                  color: AppColors.getMonoTextPrimary(isDark),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "We'll miss your light",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getMonoTextPrimary(isDark),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Your account will be deactivated.\nRemember, your light is always welcome back here whenever you're ready.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.getMonoTextSecondary(isDark),
                ),
              ),

              const SizedBox(height: 28),

              /// Deactivate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.getMonoTextPrimary(isDark),
                    foregroundColor:
                        AppColors.getMonoBackground(isDark),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: _deactivate,
                  child: const Text("Deactivate Account"),
                ),
              ),

              const SizedBox(height: 14),

              /// Keep Account
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.getMonoBorder(isDark),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
               onPressed: () => Navigator.of(context, rootNavigator: true).pop(), 
                child: Text(
                  "Keep My Account",
                  style: TextStyle(
                    color:
                        AppColors.getMonoTextPrimary(isDark),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [

              /// BACK
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.pop(),
                child: Text(
                  "← Back",
                  style: TextStyle(
                    color:
                        AppColors.getMonoTextSecondary(isDark),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// TOP ICON
              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor:
                      AppColors.getMonoSurface(isDark),
                  child: Icon(
                    Icons.error_outline,
                    size: 38,
                    color:
                        AppColors.getMonoTextPrimary(isDark),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// TITLE
              Text(
                "Deactivate Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      AppColors.getMonoTextPrimary(isDark),
                ),
              ),

              const SizedBox(height: 10),

              /// SUBTITLE
              Text(
                "We're sad to see you go. Your account will be temporarily paused.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      AppColors.getMonoTextSecondary(isDark),
                ),
              ),

              const SizedBox(height: 40),

              /// WHAT HAPPENS SECTION
              Text(
                "What happens when you deactivate?",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      AppColors.getMonoTextPrimary(isDark),
                ),
              ),

              const SizedBox(height: 16),

              _infoCard(
                isDark,
                Colors.blue,
                "Your profile will be hidden",
                "Others won't be able to see your profile or posts",
              ),

              _infoCard(
                isDark,
                Colors.purple,
                "Your data stays safe",
                "All your posts and information will be preserved",
              ),

              _infoCard(
                isDark,
                Colors.orange,
                "You can come back anytime",
                "Simply log in to reactivate your account",
              ),

              const SizedBox(height: 30),

              /// HELP IMPROVE
              Text(
                "Help us improve (optional)",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      AppColors.getMonoTextPrimary(isDark),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Would you mind sharing why you're leaving?",
                style: TextStyle(
                  fontSize: 13,
                  color:
                      AppColors.getMonoTextSecondary(isDark),
                ),
              ),

              const SizedBox(height: 16),

              /// REASONS
              ...List.generate(reasons.length, (index) {
                final selected =
                    selectedReasonIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedReasonIndex = index;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color:
                          AppColors.getMonoSurface(isDark),
                      borderRadius:
                          BorderRadius.circular(18),
                      border: selected
                          ? Border.all(
                              color: AppColors
                                  .getMonoTextPrimary(
                                      isDark),
                            )
                          : null,
                    ),
                    child: Text(
                      reasons[index],
                      style: TextStyle(
                        color: AppColors
                            .getMonoTextPrimary(isDark),
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.getMonoTextPrimary(
                            isDark),
                    foregroundColor:
                        AppColors.getMonoBackground(
                            isDark),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () =>
                      _showFinalConfirmation(isDark),
                  child: const Text(
                      "Continue to Deactivate"),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: AppColors
                          .getMonoTextSecondary(isDark),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
    bool isDark,
    Color dotColor,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.getMonoSurface(isDark),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors
                        .getMonoTextPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors
                        .getMonoTextSecondary(isDark),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}