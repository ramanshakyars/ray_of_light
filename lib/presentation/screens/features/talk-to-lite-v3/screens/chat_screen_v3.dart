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
                color: colors.divider.withValues(alpha: 0.2),
              ),
              // ── Chat Body with background starting below header ──
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/talktolight image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const ChatBodyV3(),
                ),
              ),
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
          padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
          color: colors.background,
          child: Row(
            children: [
              // Back Button <
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: colors.textPrimary,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),

              const SizedBox(width: 4),

              // AI Avatar with online indicator (using logo.png)
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surface,
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Online dot
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 12,
                      height: 12,
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
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      provider.isTyping ? 'typing...' : 'online',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: provider.isTyping
                            ? colors.success
                            : colors.textSecondary.withValues(alpha: 0.8),
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

