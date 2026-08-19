import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/constants/terms_constants.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class CommunityGuidelinesPage extends StatelessWidget {
  const CommunityGuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final primaryColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      appBar: AppBar(
        backgroundColor: AppColors.getMonoBackground(isDark),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          TermsConstants.communityGuidelinesTitle,
          style: AppTextStyles.monoBold22(isDark),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.getMonoCard(isDark),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.black12,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RAY OF LIGHT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Effective Date: ${TermsConstants.effectiveDate}',
                          style: AppTextStyles.monoSecondary14(isDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Policy Version: ${TermsConstants.currentTermsVersion}',
                          style: AppTextStyles.monoSecondary14(isDark),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Content Body
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.getMonoCard(isDark),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      TermsConstants.communityGuidelinesContent,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
