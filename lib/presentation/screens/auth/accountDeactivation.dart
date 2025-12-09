import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import '../../../core/theme/AppFont.dart';

class AccountDeactivatedScreen extends StatelessWidget {
  const AccountDeactivatedScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
  final isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, color: Colors.red, size: 80),
                const SizedBox(height: 24),

                // Title
                Text(
                  "Account Deleted",
                  style: AppTextStyles.medium22(isDarkMode),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  "Your account has been deleted successfully.\n"
                  "You will no longer be able to use it unless reactivated.",
                  style: AppTextStyles.regular16(isDarkMode),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Suggestion
                Text(
                  "If this was a mistake, you can create a new account anytime.",
                  style: AppTextStyles.regular16(isDarkMode),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Go to Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.getFormSubmitButtonColor(isDarkMode),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      GoRouter.of(context).go(RouteNames.login);
                    },
                    child: Text("GO TO LOGIN", style: AppTextStyles.medium18(isDarkMode)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
