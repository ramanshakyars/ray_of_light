import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.medium22(isDarkMode),
        ),
        backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextPrimaryColor(isDarkMode),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.getFormsCardColor(isDarkMode),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Last updated: September 23, 2025',
                style: AppTextStyles.medium18(isDarkMode),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Introduction
            _buildSection(
              isDarkMode: isDarkMode,
              title: 'Introduction',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Ray of Light ("Company", "we", "our", or "us") respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application ("Application", "App") and services ("Service"). It also outlines your rights and choices, including the ability to delete your account and data.',
                ),
                const SizedBox(height: 12),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'By using our Service, you agree to the practices described in this Privacy Policy.',
                ),
              ],
            ),

            // 1. Interpretation and Definitions
            _buildSection(
              isDarkMode: isDarkMode,
              title: '1. Interpretation and Definitions',
              children: [
                _buildSubtitle(isDarkMode: isDarkMode, text: 'Interpretation'),
                const SizedBox(height: 8),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Words with capitalized initials have meanings defined below. The definitions apply regardless of whether they appear in singular or plural.',
                ),
                const SizedBox(height: 12),
                _buildSubtitle(isDarkMode: isDarkMode, text: 'Definitions'),
                const SizedBox(height: 8),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Words with capitalized initials have meanings defined below. The definitions apply regardless of whether they appear in singular or plural.',
                ),
                const SizedBox(height: 8),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Account:',
                  definition: 'A unique account created by you to access our Service.',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Application:',
                  definition: 'Ray of Light, the mobile app provided by the Company.',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Company:',
                  definition: 'Ray of Light, located at 2J/106 NIT 3 Main Road, Faridabad - 121001, Haryana, India.',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Device:',
                  definition: 'Any device that can access the Service, such as a smartphone or tablet.',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Personal Data:',
                  definition: 'Any information that identifies or can reasonably identify an individual.',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Service:',
                  definition: 'The Ray of Light mobile application.',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Service Provider:',
                  definition: 'A third-party company or individual who processes data on our behalf to enable our Service.',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'Usage Data:',
                  definition: 'Data collected automatically when you use the Service (e.g., IP address, app usage).',
                ),
                _buildDefinitionItem(
                  isDarkMode: isDarkMode,
                  term: 'You:',
                  definition: 'The individual accessing or using the Service.',
                ),
              ],
            ),

            // 2. Information We Collect
            _buildSection(
              isDarkMode: isDarkMode,
              title: '2. Information We Collect',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'We may collect the following types of data:',
                ),
                const SizedBox(height: 12),
                _buildSubtitle(isDarkMode: isDarkMode, text: 'Personal Data (Optional & Limited)'),
                const SizedBox(height: 8),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'When creating an account or using certain features, you may provide:',
                ),
                const SizedBox(height: 8),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Email address (required for account creation and communication)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'First and last name (optional)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Phone number (optional – used only for contact or verification)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Date of birth (optional – used only for personalization)',
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.getFormSubmitButtonColor(isDarkMode),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '👉 None of the optional information is required to use the core functionality of the app.',
                    style: AppTextStyles.regular16(isDarkMode),
                  ),
                ),
                const SizedBox(height: 12),
                _buildSubtitle(isDarkMode: isDarkMode, text: 'Usage Data (Automatic Collection)'),
                const SizedBox(height: 8),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'We automatically collect:',
                ),
                const SizedBox(height: 8),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Device information (e.g., model, operating system)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'IP address',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'App activity (e.g., pages visited, time spent)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Error/diagnostic data (used to improve app performance)',
                ),
              ],
            ),

            // 3. How We Use Your Data
            _buildSection(
              isDarkMode: isDarkMode,
              title: '3. How We Use Your Data',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'We use your data for purposes including:',
                ),
                const SizedBox(height: 8),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'To provide and maintain the Service',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'To create and manage your Account',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'To monitor and improve app performance',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'To send service-related notifications (e.g., updates, security alerts)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'To respond to your inquiries or support requests',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'To personalize user experience (optional data only if provided)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'For analytics and internal research',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'To comply with legal obligations',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.getFormsCardColor(isDarkMode),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'We do not sell your personal data.',
                    style: AppTextStyles.regular16(isDarkMode),
                  ),
                ),
              ],
            ),

            // 4. Sharing Your Data
            _buildSection(
              isDarkMode: isDarkMode,
              title: '4. Sharing Your Data',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'We may share data only in these circumstances:',
                ),
                const SizedBox(height: 8),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'With Service Providers: To support app operations (e.g., analytics, cloud hosting).',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'For Legal Reasons: To comply with applicable laws, government requests, or enforce agreements.',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Business Transfers: In the event of a merger, acquisition, or sale of assets.',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'With Consent: If you explicitly agree to sharing for other purposes.',
                ),
              ],
            ),

            // 5. Data Retention
            _buildSection(
              isDarkMode: isDarkMode,
              title: '5. Data Retention',
              children: [
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'We retain your data only for as long as necessary to provide the Service.',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Usage Data is generally kept for a shorter period unless needed for security, troubleshooting, or legal compliance.',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'If you delete your account, your personal data will be permanently removed unless retention is required by law.',
                ),
              ],
            ),

            // 6. Your Rights
            _buildSection(
              isDarkMode: isDarkMode,
              title: '6. Your Rights',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'You have the right to:',
                ),
                const SizedBox(height: 8),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Access the data we hold about you',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Request corrections to your data',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Delete your account and associated data',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Opt out of optional data collection (phone number, date of birth)',
                ),
                _buildListItem(
                  isDarkMode: isDarkMode,
                  text: 'Withdraw consent for marketing or optional services',
                ),
              ],
            ),

            // 7. Account and Data Deletion
            _buildSection(
              isDarkMode: isDarkMode,
              title: '7. Account and Data Deletion',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'You can delete your account and personal data at any time:',
                ),
                const SizedBox(height: 12),
                _buildSubtitle(isDarkMode: isDarkMode, text: 'In-App:'),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Go to Profile > Account > Delete Account.',
                ),
                const SizedBox(height: 12),
                _buildSubtitle(isDarkMode: isDarkMode, text: 'By Contact:'),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Email us at info@rayoflight.life with your registered email.',
                ),
                const SizedBox(height: 12),
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Deletion requests will be processed promptly. Please note that some data may be retained if required by law.',
                ),
              ],
            ),

            // 8. Security of Your Data
            _buildSection(
              isDarkMode: isDarkMode,
              title: '8. Security of Your Data',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'We use industry-standard safeguards to protect your data. However, no system is 100% secure. While we take reasonable measures, we cannot guarantee absolute security.',
                ),
              ],
            ),

            // 9. Children's Privacy
            _buildSection(
              isDarkMode: isDarkMode,
              title: '9. Children\'s Privacy',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Our Service is not directed at children under 13. We do not knowingly collect personal data from children. If you believe a child has provided us with personal data, please contact us so we can remove it.',
                ),
              ],
            ),

            // 10. Third-Party Links
            _buildSection(
              isDarkMode: isDarkMode,
              title: '10. Third-Party Links',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'Our Service may contain links to third-party websites. We are not responsible for the privacy practices or content of those third parties.',
                ),
              ],
            ),

            // 11. Changes to This Privacy Policy
            _buildSection(
              isDarkMode: isDarkMode,
              title: '11. Changes to This Privacy Policy',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'We may update this Privacy Policy from time to time. Changes will be posted in the app and on our website, with the "Last Updated" date revised.',
                ),
              ],
            ),

            // 12. Contact Us
            _buildSection(
              isDarkMode: isDarkMode,
              title: '12. Contact Us',
              children: [
                _buildParagraph(
                  isDarkMode: isDarkMode,
                  text: 'For questions about this Privacy Policy or your data rights, contact us at:',
                ),
                const SizedBox(height: 12),
                _buildContactInfo(
                  isDarkMode: isDarkMode,
                  text: '📧 info@rayoflight.life',
                ),
                _buildContactInfo(
                  isDarkMode: isDarkMode,
                  text: '📍 Ray of Light, 2J/106 NIT 3 Main Road, Faridabad - 121001, Haryana, India',
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required bool isDarkMode,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.medium22(isDarkMode)),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSubtitle({
    required bool isDarkMode,
    required String text,
  }) {
    return Text(
      text,
      style: AppTextStyles.medium18(isDarkMode).copyWith(
        color: AppColors.getTextPrimaryColor(isDarkMode),
      ),
    );
  }

  Widget _buildParagraph({
    required bool isDarkMode,
    required String text,
  }) {
    return Text(
      text,
      style: AppTextStyles.regular16(isDarkMode),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildDefinitionItem({
    required bool isDarkMode,
    required String term,
    required String definition,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.regular16(isDarkMode),
          children: [
            TextSpan(
              text: term,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' $definition'),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required bool isDarkMode,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: AppTextStyles.regular16(isDarkMode)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.regular16(isDarkMode),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required bool isDarkMode,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: AppTextStyles.regular16(isDarkMode),
      ),
    );
  }
}