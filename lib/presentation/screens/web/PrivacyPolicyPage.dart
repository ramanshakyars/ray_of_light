import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.medium22.copyWith(color: AppColors.textPrimaryColor),
        ),
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryColor),
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
                color: AppColors.formsCardColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Last updated: September 23, 2025',
                style: AppTextStyles.medium18.copyWith(
                  color: AppColors.textPrimaryColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Introduction
            _buildSection(
              title: 'Introduction',
              children: [
                _buildParagraph(
                  'Ray of Light ("Company", "we", "our", or "us") respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application ("Application", "App") and services ("Service"). It also outlines your rights and choices, including the ability to delete your account and data.'
                ),
                const SizedBox(height: 12),
                _buildParagraph(
                  'By using our Service, you agree to the practices described in this Privacy Policy.',
                ),
              ],
            ),

            // 1. Interpretation and Definitions
            _buildSection(
              title: '1. Interpretation and Definitions',
              children: [
                _buildSubtitle('Interpretation'),
                const SizedBox(height: 8),
                _buildParagraph(
                  'Words with capitalized initials have meanings defined below. The definitions apply regardless of whether they appear in singular or plural.'
                ),
                const SizedBox(height: 12),
                _buildSubtitle('Definitions'),
                const SizedBox(height: 8),
                _buildDefinitionItem('Account:', 'A unique account created by you to access our Service.'),
                _buildDefinitionItem('Application:', 'Ray of Light, the mobile app provided by the Company.'),
                _buildDefinitionItem('Company:', 'Ray of Light, located at 2J/106 NIT 3 Main Road, Faridabad - 121001, Haryana, India.'),
                _buildDefinitionItem('Device:', 'Any device that can access the Service, such as a smartphone or tablet.'),
                _buildDefinitionItem('Personal Data:', 'Any information that identifies or can reasonably identify an individual.'),
                _buildDefinitionItem('Service:', 'The Ray of Light mobile application.'),
                _buildDefinitionItem('Service Provider:', 'A third-party company or individual who processes data on our behalf to enable our Service.'),
                _buildDefinitionItem('Usage Data:', 'Data collected automatically when you use the Service (e.g., IP address, app usage).'),
                _buildDefinitionItem('You:', 'The individual accessing or using the Service.'),
              ],
            ),

            // 2. Information We Collect
            _buildSection(
              title: '2. Information We Collect',
              children: [
                _buildParagraph('We may collect the following types of data:'),
                const SizedBox(height: 12),
                _buildSubtitle('Personal Data (Optional & Limited)'),
                const SizedBox(height: 8),
                _buildParagraph('When creating an account or using certain features, you may provide:'),
                const SizedBox(height: 8),
                _buildListItem('Email address (required for account creation and communication)'),
                _buildListItem('First and last name (optional)'),
                _buildListItem('Phone number (optional – used only for contact or verification)'),
                _buildListItem('Date of birth (optional – used only for personalization)'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.formSubmitButtonColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '👉 None of the optional information is required to use the core functionality of the app.',
                    style: AppTextStyles.regular16.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildSubtitle('Usage Data (Automatic Collection)'),
                const SizedBox(height: 8),
                _buildParagraph('We automatically collect:'),
                const SizedBox(height: 8),
                _buildListItem('Device information (e.g., model, operating system)'),
                _buildListItem('IP address'),
                _buildListItem('App activity (e.g., pages visited, time spent)'),
                _buildListItem('Error/diagnostic data (used to improve app performance)'),
              ],
            ),

            // 3. How We Use Your Data
            _buildSection(
              title: '3. How We Use Your Data',
              children: [
                _buildParagraph('We use your data for purposes including:'),
                const SizedBox(height: 8),
                _buildListItem('To provide and maintain the Service'),
                _buildListItem('To create and manage your Account'),
                _buildListItem('To monitor and improve app performance'),
                _buildListItem('To send service-related notifications (e.g., updates, security alerts)'),
                _buildListItem('To respond to your inquiries or support requests'),
                _buildListItem('To personalize user experience (optional data only if provided)'),
                _buildListItem('For analytics and internal research'),
                _buildListItem('To comply with legal obligations'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.formsCardColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'We do not sell your personal data.',
                    style: AppTextStyles.regular16.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // 4. Sharing Your Data
            _buildSection(
              title: '4. Sharing Your Data',
              children: [
                _buildParagraph('We may share data only in these circumstances:'),
                const SizedBox(height: 8),
                _buildListItem('With Service Providers: To support app operations (e.g., analytics, cloud hosting).'),
                _buildListItem('For Legal Reasons: To comply with applicable laws, government requests, or enforce agreements.'),
                _buildListItem('Business Transfers: In the event of a merger, acquisition, or sale of assets.'),
                _buildListItem('With Consent: If you explicitly agree to sharing for other purposes.'),
              ],
            ),

            // 5. Data Retention
            _buildSection(
              title: '5. Data Retention',
              children: [
                _buildListItem('We retain your data only for as long as necessary to provide the Service.'),
                _buildListItem('Usage Data is generally kept for a shorter period unless needed for security, troubleshooting, or legal compliance.'),
                _buildListItem('If you delete your account, your personal data will be permanently removed unless retention is required by law.'),
              ],
            ),

            // 6. Your Rights
            _buildSection(
              title: '6. Your Rights',
              children: [
                _buildParagraph('You have the right to:'),
                const SizedBox(height: 8),
                _buildListItem('Access the data we hold about you'),
                _buildListItem('Request corrections to your data'),
                _buildListItem('Delete your account and associated data'),
                _buildListItem('Opt out of optional data collection (phone number, date of birth)'),
                _buildListItem('Withdraw consent for marketing or optional services'),
              ],
            ),

            // 7. Account and Data Deletion
            _buildSection(
              title: '7. Account and Data Deletion',
              children: [
                _buildParagraph('You can delete your account and personal data at any time:'),
                const SizedBox(height: 12),
                _buildSubtitle('In-App:'),
                _buildParagraph('Go to Profile > Account > Delete Account.'),
                const SizedBox(height: 12),
                _buildSubtitle('By Contact:'),
                _buildParagraph('Email us at info@rayoflight.life with your registered email.'),
                const SizedBox(height: 12),
                _buildParagraph('Deletion requests will be processed promptly. Please note that some data may be retained if required by law.'),
              ],
            ),

            // 8. Security of Your Data
            _buildSection(
              title: '8. Security of Your Data',
              children: [
                _buildParagraph('We use industry-standard safeguards to protect your data. However, no system is 100% secure. While we take reasonable measures, we cannot guarantee absolute security.'),
              ],
            ),

            // 9. Children's Privacy
            _buildSection(
              title: '9. Children\'s Privacy',
              children: [
                _buildParagraph('Our Service is not directed at children under 13. We do not knowingly collect personal data from children. If you believe a child has provided us with personal data, please contact us so we can remove it.'),
              ],
            ),

            // 10. Third-Party Links
            _buildSection(
              title: '10. Third-Party Links',
              children: [
                _buildParagraph('Our Service may contain links to third-party websites. We are not responsible for the privacy practices or content of those third parties.'),
              ],
            ),

            // 11. Changes to This Privacy Policy
            _buildSection(
              title: '11. Changes to This Privacy Policy',
              children: [
                _buildParagraph('We may update this Privacy Policy from time to time. Changes will be posted in the app and on our website, with the "Last Updated" date revised.'),
              ],
            ),

            // 12. Contact Us
            _buildSection(
              title: '12. Contact Us',
              children: [
                _buildParagraph('For questions about this Privacy Policy or your data rights, contact us at:'),
                const SizedBox(height: 12),
                _buildContactInfo('📧 info@rayoflight.life'),
                _buildContactInfo('📍 Ray of Light, 2J/106 NIT 3 Main Road, Faridabad - 121001, Haryana, India'),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.medium22.copyWith(
            color: AppColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: AppTextStyles.medium18.copyWith(
        color: AppColors.textPrimaryColor,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: AppTextStyles.regular16,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildDefinitionItem(String term, String definition) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.regular16,
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

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.regular16,
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.regular16,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: AppTextStyles.regular16.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}