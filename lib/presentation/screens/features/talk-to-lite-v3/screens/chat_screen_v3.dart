import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/services/ChatServiceV3.dart';

import '../provider/chat_provider_v3.dart';
import '../widgets/chat_body_v3.dart';

class ChatScreenV3 extends StatelessWidget {
  final String? chatId;

  const ChatScreenV3({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return ChangeNotifierProvider(
      create: (_) =>
          ChatProviderV3(service: ChatServiceV3(), initialChatId: chatId)
            ..initializeChat(),
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Header ───────────────────────────────────────
              _ChatHeader(colors: colors),
              // ── Divider ───────────────────────────────────────
              Container(
                height: 1,
                color: colors.divider,
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
  final ThemeColors colors;

  const _ChatHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProviderV3>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: colors.background,
          child: Row(
            children: [
              // AI Avatar with online indicator
              Stack(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surface,
                      border: Border.all(
                        color: colors.border,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/talk-to-light.png',
                          color: colors.icon,
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
                          color: colors.background,
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
                      style: AppTextStyles.cardTitle(colors).copyWith(
                        fontSize: 17,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      provider.isTyping ? 'typing...' : 'online',
                      style: TextStyle(
                        fontFamily: 'Specimen',
                        fontSize: 12,
                        color: provider.isTyping
                            ? colors.success
                            : colors.textSecondary,
                        fontWeight: provider.isTyping
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
