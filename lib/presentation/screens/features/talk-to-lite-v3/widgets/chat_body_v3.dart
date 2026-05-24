import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

import '../provider/chat_provider_v3.dart';

import '../../talk-to-lite-v2/widgets/mono_typing_indicator.dart';
import 'mono_chat_bubble_v3.dart';
import 'mono_input_bar_v3.dart';

class ChatBodyV3 extends StatefulWidget {
  const ChatBodyV3({super.key});

  @override
  State<ChatBodyV3> createState() => _ChatBodyV3State();
}

class _ChatBodyV3State extends State<ChatBodyV3> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProviderV3>();

    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Column(
      children: [
        Expanded(
          child:
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.messages.isEmpty
                  ? Center(
                    child: Text(
                      "Ask me anything and I'll do my best to help you.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.monoSecondary14(isDark),
                    ),
                  )
                  : ListView.builder(
                    controller: provider.scrollController,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

                    itemCount:
                        provider.messages.length + (provider.isTyping ? 1 : 0),

                    itemBuilder: (context, index) {
                      if (provider.isLoadingMoreMessages && index == 0) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      if (provider.isTyping &&
                          index == provider.messages.length) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: MonoTypingIndicator(),
                        );
                      }

                      final message = provider.messages[index];

                      return MonoChatBubbleV3(
                        text: message.content,
                        isUser: message.isUser,
                      );
                    },
                  ),
        ),

        MonoInputBarV3(
          controller: controller,

          isLoading: provider.isTyping,

          onSend: () {
            final text = controller.text.trim();

            if (text.isEmpty) return;

            provider.sendMessage(text);

            controller.clear();
          },
        ),
      ],
    );
  }
}
