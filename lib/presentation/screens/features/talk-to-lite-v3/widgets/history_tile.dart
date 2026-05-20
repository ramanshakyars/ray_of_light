import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_history_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/provider/chat_provider_v3.dart';

class HistoryTile extends StatelessWidget {
  final ChatHistoryModel history;

  const HistoryTile({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return InkWell(
      onTap: () {
        context.read<ChatProviderV3>().loadConversation(history.conversationId);
        Navigator.pop(context);
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.getMonoSurface(isDark),

              child: const Icon(Icons.chat_bubble_outline),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    history.title,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: AppTextStyles.bold22(isDark),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    history.lastMessage ?? "",

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: AppTextStyles.monoSecondary14(isDark),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Text(
              history.messageCount?.toString() ?? "",

              style: AppTextStyles.bold22(isDark),
            ),
          ],
        ),
      ),
    );
  }
}
