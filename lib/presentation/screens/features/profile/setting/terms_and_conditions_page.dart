import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 12),
              AppScreenHeader(
                title: 'Terms & Conditions',
                subtitle: 'Please read carefully',
                bottomPadding: 0,
                actions: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: colors.icon),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                '1. Introduction\n\nWelcome to Ray of Light. By using our application, you agree to these terms and conditions in full.\n\n'
                '2. Intellectual Property Rights\n\nUnless otherwise stated, we or our licensors own the intellectual property rights in the app and material on the app.\n\n'
                '3. Restrictions\n\nYou are specifically restricted from all of the following:\n'
                '- Publishing any app material in any other media\n'
                '- Selling, sublicensing and/or otherwise commercializing any app material\n'
                '- Publicly performing and/or showing any app material\n\n'
                '4. Your Content\n\nIn these terms and conditions, "Your Content" shall mean any audio, video text, images or other material you choose to display on this app.\n\n'
                '5. No warranties\n\nThis app is provided "as is," with all faults, and we express no representations or warranties, of any kind related to this app or the materials contained on this app.\n\n'
                '6. Limitation of liability\n\nIn no event shall we, nor any of our officers, directors and employees, shall be held liable for anything arising out of or in any way connected with your use of this app.\n\n'
                '7. Indemnification\n\nYou hereby indemnify to the fullest extent us from and against any and/or all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of these Terms.\n\n'
                '8. Severability\n\nIf any provision of these Terms is found to be invalid under any applicable law, such provisions shall be deleted without affecting the remaining provisions herein.\n\n'
                '9. Variation of Terms\n\nWe are permitted to revise these Terms at any time as we see fit, and by using this app you are expected to review these Terms on a regular basis.\n\n'
                '10. Governing Law & Jurisdiction\n\nThese Terms will be governed by and interpreted in accordance with the laws of the State/Country, and you submit to the non-exclusive jurisdiction of the state and federal courts located in for the resolution of any disputes.\n',
                style: TextStyle(color: colors.textPrimary, fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
