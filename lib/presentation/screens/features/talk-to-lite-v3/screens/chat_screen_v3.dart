import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/services/ChatServiceV3.dart';

import '../provider/chat_provider_v3.dart';
import '../widgets/chat_body_v3.dart';
// import '../widgets/history_bottom_sheet.dart'; // history hidden for now

class ChatScreenV3 extends StatelessWidget {
  final String? chatId;

  const ChatScreenV3({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return ChangeNotifierProvider(
      create:
          (_) =>
              ChatProviderV3(service: ChatServiceV3(), initialChatId: chatId)
                ..initializeChat(),

      child: Scaffold(
        backgroundColor: AppColors.getMonoBackground(isDark),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Beautiful Header ──────────────────────────────
              _ChatHeader(isDark: isDark),
              // ── Divider ───────────────────────────────────────
              Container(
                height: 1,
                color: AppColors.getMonoBorder(isDark).withValues(alpha: 0.5),
              ),
              // ── Chat Body ────────────────────────────────────
              const Expanded(child: ChatBodyV3()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final bool isDark;

  const _ChatHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProviderV3>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              // Back button – hidden for now
              // _HeaderIconButton(
              //   icon: Icons.arrow_back_ios_new_rounded,
              //   isDark: isDark,
              //   onTap: () => Navigator.of(context).maybePop(),
              // ),
              // const SizedBox(width: 12),

              // AI Avatar with online indicator
              Stack(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.getMonoSurface(isDark),
                      border: Border.all(
                        color: AppColors.getMonoBorder(isDark),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/talk-to-light.png',
                          color: AppColors.getMonoIcon(isDark),
                        ),
                      ),
                    ),
                  ),
                  // Online dot
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.getMonoBackground(isDark),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Title & Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Light',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getMonoTextPrimary(isDark),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Status subtitle — no duplicate dot, colour conveys state
                    Text(
                      provider.isTyping ? 'typing...' : 'online · AI Companion',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: provider.isTyping
                            ? const Color(0xFF22C55E)
                            : AppColors.getMonoTextSecondary(isDark),
                        fontWeight: provider.isTyping
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),

              // New Chat button – hidden for now
              // _HeaderIconButton(
              //   icon: Icons.add_comment_outlined,
              //   isDark: isDark,
              //   onTap: () {
              //     HapticFeedback.lightImpact();
              //     provider.clearChat();
              //   },
              // ),

              // History button – hidden for now
              // _HeaderIconButton(
              //   icon: Icons.history_rounded,
              //   isDark: isDark,
              //   onTap: () {
              //     HapticFeedback.lightImpact();
              //     showModalBottomSheet(
              //       context: context,
              //       isScrollControlled: true,
              //       backgroundColor: Colors.transparent,
              //       builder: (_) => ChangeNotifierProvider.value(
              //         value: provider,
              //         child: const HistoryBottomSheet(),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback? onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.getMonoSurface(isDark),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.getMonoBorder(isDark).withValues(alpha: 0.5),
          ),
        ),
        child: Icon(
          icon,
          size: 17,
          color: AppColors.getMonoIcon(isDark),
        ),
      ),
    );
  }
}
