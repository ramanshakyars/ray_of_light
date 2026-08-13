import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/models/chat_history_model.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/provider/chat_provider_v3.dart';

class HistoryTile extends StatefulWidget {
  final ChatHistoryModel history;

  const HistoryTile({super.key, required this.history});

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool _pressed = false;

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt).inDays;

      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      if (diff < 7) return '${diff}d ago';

      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final dateLabel = _formatDate(widget.history.updatedAt);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.selectionClick();
        context.read<ChatProviderV3>().loadConversation(
              widget.history.conversationId,
            );
        Navigator.pop(context);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _pressed
            ? AppColors.getMonoSurface(isDark).withValues(alpha: 0.7)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.getMonoSurface(isDark),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.getMonoBorder(isDark),
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 18,
                color: AppColors.getMonoIcon(isDark),
              ),
            ),

            const SizedBox(width: 14),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.history.title.isNotEmpty
                        ? widget.history.title
                        : 'Conversation',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getMonoTextPrimary(isDark),
                    ),
                  ),
                  if (widget.history.lastMessage != null &&
                      widget.history.lastMessage!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      widget.history.lastMessage!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.monoSecondary14(isDark).copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Right side: date + message count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (dateLabel.isNotEmpty)
                  Text(
                    dateLabel,
                    style: AppTextStyles.monoMuted12(isDark),
                  ),
                if (widget.history.messageCount != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.getMonoSurface(isDark),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.getMonoBorder(isDark),
                      ),
                    ),
                    child: Text(
                      '${widget.history.messageCount}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getMonoTextSecondary(isDark),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(width: 6),

            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.getMonoTextMuted(isDark),
            ),
          ],
        ),
      ),
    );
  }
}
