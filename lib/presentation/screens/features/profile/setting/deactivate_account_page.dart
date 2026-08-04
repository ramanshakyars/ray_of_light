import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

class DeactivateAccountPage extends StatefulWidget {
  const DeactivateAccountPage({super.key});

  @override
  State<DeactivateAccountPage> createState() => _DeactivateAccountPageState();
}

class _DeactivateAccountPageState extends State<DeactivateAccountPage> {
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

  void _showFinalConfirmation(ThemeColors colors) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: colors.surface,
                child: Icon(
                  Icons.favorite_border,
                  size: 32,
                  color: colors.primary,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "We'll miss your light",
                textAlign: TextAlign.center,
                style: AppTextStyles.dialogTitle(colors),
              ),

              const SizedBox(height: 12),

              Text(
                "Your account will be deactivated.\nRemember, your light is always welcome back here whenever you're ready.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary(colors),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: Colors.white,
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

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                child: Text(
                  "Keep My Account",
                  style: AppTextStyles.cardTitle(colors),
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
    final colors = context.watch<ThemeProvider>().colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 12),

              AppScreenHeader(
                title: "Deactivate Account",
                subtitle: "We're sad to see you go",
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back, color: colors.icon),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: colors.surface,
                  child: Icon(
                    Icons.error_outline,
                    size: 38,
                    color: colors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "What happens when you deactivate?",
                style: AppTextStyles.sectionTitle(colors),
              ),

              const SizedBox(height: 16),

              _infoCard(
                colors,
                Colors.blue,
                "Your profile will be hidden",
                "Others won't be able to see your profile or posts",
              ),

              _infoCard(
                colors,
                Colors.purple,
                "Your data stays safe",
                "All your posts and information will be preserved",
              ),

              _infoCard(
                colors,
                Colors.orange,
                "You can come back anytime",
                "Simply log in to reactivate your account",
              ),

              const SizedBox(height: 30),

              Text(
                "Help us improve (optional)",
                style: AppTextStyles.sectionTitle(colors),
              ),

              const SizedBox(height: 6),

              Text(
                "Would you mind sharing why you're leaving?",
                style: AppTextStyles.bodySecondary(colors),
              ),

              const SizedBox(height: 16),

              ...List.generate(reasons.length, (index) {
                final selected = selectedReasonIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedReasonIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: selected
                          ? Border.all(color: colors.primary, width: 1.5)
                          : Border.all(color: colors.border),
                    ),
                    child: Text(
                      reasons[index],
                      style: AppTextStyles.bodyText(colors),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.primaryForeground,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () => _showFinalConfirmation(colors),
                  child: Text(
                    "Continue to Deactivate",
                    style: AppTextStyles.buttonLabel(colors),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.bodySecondary(colors),
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
    ThemeColors colors,
    Color dotColor,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(colors),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.hintText(colors),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}