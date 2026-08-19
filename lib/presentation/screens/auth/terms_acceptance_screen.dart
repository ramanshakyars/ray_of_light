import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/constants/common_button.dart';
import 'package:rayoflite/core/constants/terms_constants.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/authService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class TermsAcceptanceScreen extends StatefulWidget {
  const TermsAcceptanceScreen({super.key});

  @override
  State<TermsAcceptanceScreen> createState() => _TermsAcceptanceScreenState();
}

class _TermsAcceptanceScreenState extends State<TermsAcceptanceScreen> {
  bool _termsAccepted = false;
  bool _isLoading = false;
  bool _hasOpenedTermsOfUse = false;
  bool _hasOpenedCommunityGuidelines = false;

  void _handleCheckboxToggle(bool? val) {
    if (_isLoading) return;

    if (!_hasOpenedTermsOfUse || !_hasOpenedCommunityGuidelines) {
      MessageService.showError(
        context,
        'Please open and read both the Terms of Use and Community Guidelines before accepting.',
      );
      return;
    }

    setState(() {
      _termsAccepted = val ?? false;
    });
  }

  Future<void> _submitAcceptance() async {
    if (!_hasOpenedTermsOfUse || !_hasOpenedCommunityGuidelines) {
      MessageService.showError(
        context,
        'Please open and read both the Terms of Use and Community Guidelines before accepting.',
      );
      return;
    }

    if (!_termsAccepted) {
      MessageService.showError(
        context,
        'Please check the box to agree to the Terms of Use and Community Guidelines.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.acceptTerms({
        'termsAccepted': true,
        'termsVersion': TermsConstants.currentTermsVersion,
      });

      if (!mounted) return;

      if (response['success'] == true) {
        // Update local user state
        final existingUser = await LocalStorageService.getUser() ?? {};
        existingUser['termsAcceptance'] = {
          'accepted': true,
          'version': TermsConstants.currentTermsVersion,
          'acceptedAt': DateTime.now().toIso8601String(),
        };
        await LocalStorageService.setUser(existingUser);
        await Provider.of<AuthProvider>(context, listen: false).loadUser();

        MessageService.showSuccess(context, 'Terms accepted successfully');

        context.go('${RouteNames.mainApp}/${RouteNames.home}');
      } else {
        MessageService.showError(
          context,
          response['message'] ??
              'Unable to save your acceptance. Please check your connection and try again.',
        );
      }
    } catch (e) {
      if (mounted) {
        MessageService.showError(
          context,
          'Unable to save your acceptance. Please check your connection and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return PopScope(
      canPop: false, // Prevent back navigation bypass
      child: Scaffold(
        backgroundColor: AppColors.getMonoBackground(isDark),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Title Header
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.getMonoCard(isDark),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terms & Community Guidelines',
                                style: AppTextStyles.monoBold22(isDark),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Before continuing to Ray of Light, please review and accept our Terms of Use and Community Guidelines.',
                                style: AppTextStyles.monoSecondary14(isDark),
                              ),
                              const SizedBox(height: 24),

                              // Quick Link Cards
                              _DocumentLinkTile(
                                icon: Icons.gavel,
                                title: 'Terms of Use',
                                subtitle: 'Read our platform rules & policies',
                                isDark: isDark,
                                isOpened: _hasOpenedTermsOfUse,
                                onTap: () {
                                  setState(() {
                                    _hasOpenedTermsOfUse = true;
                                  });
                                  context.push(RouteNames.termsOfUse);
                                },
                              ),

                              const SizedBox(height: 12),

                              _DocumentLinkTile(
                                icon: Icons.verified_user_outlined,
                                title: 'Community Guidelines',
                                subtitle:
                                    'Read user safety & conduct guidelines',
                                isDark: isDark,
                                isOpened: _hasOpenedCommunityGuidelines,
                                onTap: () {
                                  setState(() {
                                    _hasOpenedCommunityGuidelines = true;
                                  });
                                  context.push(RouteNames.communityGuidelines);
                                },
                              ),

                              const SizedBox(height: 32),

                              // Acceptance Checkbox
                              InkWell(
                                onTap: () =>
                                    _handleCheckboxToggle(!_termsAccepted),
                                borderRadius: BorderRadius.circular(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _termsAccepted,
                                      onChanged: _handleCheckboxToggle,
                                      activeColor: isDark
                                          ? Colors.white
                                          : Colors.black,
                                      checkColor: isDark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 13,
                                              height: 1.4,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black87,
                                            ),
                                            children: const [
                                              TextSpan(
                                                text:
                                                    'I have read and agree to the ',
                                              ),
                                              TextSpan(
                                                text: 'Terms of Use',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' and ',
                                              ),
                                              TextSpan(
                                                text: 'Community Guidelines',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(text: '.'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Continue Button
                              CommonButton(
                                text: 'Continue',
                                isLoading: _isLoading,
                                onPressed:
                                    _isLoading ? null : _submitAcceptance,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentLinkTile extends StatelessWidget {
  const _DocumentLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.isOpened,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final bool isOpened;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOpened
                  ? (isDark ? Colors.greenAccent : Colors.green)
                  : (isDark ? Colors.white12 : Colors.black12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDark ? Colors.white70 : Colors.black87,
                size: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        if (isOpened) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: isDark ? Colors.greenAccent : Colors.green,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
