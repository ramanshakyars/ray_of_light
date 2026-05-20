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
      height: MediaQuery.of(context).size.height * 0.80,

      decoration: BoxDecoration(
        color: AppColors.getMonoBackground(isDark),

        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),

      child: Column(
        children: [
          const SizedBox(height: 12),

          Container(
            width: 50,

            height: 5,

            decoration: BoxDecoration(
              color: Colors.grey.shade400,

              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Chat History", style: AppTextStyles.bold22(isDark)),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child:
                provider.isHistoryLoading && provider.history.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : provider.history.isEmpty
                    ? Center(
                      child: Text(
                        "No conversations yet",

                        style: AppTextStyles.monoSecondary14(isDark),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),

                      itemCount: provider.history.length,

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
