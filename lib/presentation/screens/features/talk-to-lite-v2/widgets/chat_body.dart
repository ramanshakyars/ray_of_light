import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/provider/chat_provider-v2.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/widgets/mono_chat_bubble.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/widgets/mono_input_bar.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/widgets/mono_typing_indicator.dart';

class ChatBody extends StatefulWidget {
    const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Column(
      children: [
        /// ===================== CHAT LIST =====================
        Expanded(
          child: provider.messages.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.builder(
                  controller: provider.scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: provider.messages.length +
                      (provider.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (provider.isTyping &&
                        index == provider.messages.length) {
                      return const MonoTypingIndicator();
                    }

                    final message = provider.messages[index];

                    return MonoChatBubble(
                      text: message.text,
                      isUser: message.isUser,
                    );
                  },
                ),
        ),

        /// ===================== INPUT =====================
        MonoInputBar(
          controller: _controller,
          isLoading: provider.isTyping,
          onSend: () {
            final text = _controller.text.trim();
            if (text.isEmpty) return;

            provider.sendMessage(text);
            _controller.clear();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Text(
        "Ask me anything and I'll do my best to help you.",
        textAlign: TextAlign.center,
        style: AppTextStyles.monoSecondary14(isDark),
      ),
    );
  }
}