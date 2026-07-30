import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v3/widgets/history_tile.dart';

import '../provider/chat_provider_v3.dart';

class HistoryBottomSheet extends StatefulWidget {
  const HistoryBottomSheet({super.key});

  @override
  State<HistoryBottomSheet> createState() => _HistoryBottomSheetState();
}

class _HistoryBottomSheetState extends State<HistoryBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChatProviderV3>();
      if (provider.history.isEmpty) {
        provider.loadHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProviderV3>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: AppColors.getMonoBackground(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ── Handle ─────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.getMonoBorder(isDark),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── Header ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.getMonoSurface(isDark),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.getMonoBorder(isDark),
                    ),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    size: 18,
                    color: AppColors.getMonoIcon(isDark),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chat History',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.getMonoTextPrimary(isDark),
                        ),
                      ),
                      Text(
                        '${provider.history.length} conversations',
                        style: AppTextStyles.monoMuted12(isDark),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.getMonoSurface(isDark),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.getMonoIcon(isDark),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Divider ─────────────────────────────────────────
          Container(
            height: 1,
            color: AppColors.getMonoBorder(isDark).withValues(alpha: 0.5),
          ),

          // ── List ──────────────────────────────────────────
          Expanded(
            child: provider.isHistoryLoading && provider.history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.getMonoTextPrimary(isDark),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Loading history...',
                          style: AppTextStyles.monoSecondary14(isDark),
                        ),
                      ],
                    ),
                  )
                : provider.history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48,
                              color: AppColors.getMonoTextMuted(isDark),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No conversations yet',
                              style: AppTextStyles.monoSecondary14(isDark),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Start chatting with Light!',
                              style: AppTextStyles.monoMuted12(isDark),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: provider.history.length,
                        separatorBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Divider(
                            height: 1,
                            color: AppColors.getMonoBorder(isDark)
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final item = provider.history[index];
                          return HistoryTile(history: item);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
