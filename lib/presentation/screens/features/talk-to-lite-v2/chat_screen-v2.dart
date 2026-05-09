import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/provider/chat_provider-v2.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/widgets/chat_body.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/widgets/mono_chat_drawer.dart';

class ChatScreen extends StatelessWidget {
  final String? chatId;

  const ChatScreen({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return ChangeNotifierProvider(
      // create: (_) => ChatProvider()..loadConversations(),
      create: (_) {
        final provider = ChatProvider();
        provider.loadConversations();

        if (chatId != null && chatId!.isNotEmpty) {
          provider.loadChatById(chatId!);
        }

        return provider;
      },
      child: Scaffold(
        backgroundColor: AppColors.getMonoBackground(isDark),
        drawer: const MonoChatDrawer(),
        appBar: AppBar(
          backgroundColor: AppColors.getMonoBackground(isDark),
          elevation: 0,
          title: Text("Light", style: AppTextStyles.bold28(isDark)),
        ),
        body: ChatBody(),
      ),
    );
  }
}
