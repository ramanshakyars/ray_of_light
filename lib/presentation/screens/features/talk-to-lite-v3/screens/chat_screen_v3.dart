import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/services/ChatServiceV3.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

import '../provider/chat_provider_v3.dart';
import '../widgets/chat_body_v3.dart';

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
              // ── Consistent Header ────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: AppScreenHeader(
                  title: "Light",
                  subtitle: "Your AI companion",
                  bottomPadding: 0,
                ),
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

