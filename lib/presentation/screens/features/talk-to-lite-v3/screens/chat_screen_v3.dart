import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

import '../provider/chat_provider_v3.dart';
import '../services/chat_service_v3.dart';
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

        appBar: AppBar(
          backgroundColor: AppColors.getMonoBackground(isDark),

          elevation: 0,

          title: Text("Light", style: AppTextStyles.bold28(isDark)),

          // actions: [
          //   Builder(
          //     builder: (context) {
          //       return IconButton(
          //         onPressed: () {
          //           showModalBottomSheet(
          //             context: context,
          //             backgroundColor: Colors.transparent,
          //             isScrollControlled: true,
          //             builder:
          //                 (sheetContext) => ChangeNotifierProvider.value(
          //                   value: context.read<ChatProviderV3>(),
          //                   child: const HistoryBottomSheet(),
          //                 ),
          //           );
          //         },

          //         icon: const Icon(Icons.history),
          //       );
          //     },
          //   ),
          // ],
        ),

        body: const ChatBodyV3(),
      ),
    );
  }
}
