import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite-v2/provider/chat_provider-v2.dart';

class MonoChatDrawer extends StatelessWidget {
  const MonoChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final grouped = provider.groupedConversations;

    return Drawer(
      backgroundColor: AppColors.getMonoBackground(isDark),
      child: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Conversations",
                    style: AppTextStyles.monoBold22(isDark),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppColors.getMonoIcon(isDark),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            /// NEW CHAT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.getMonoTextPrimary(isDark),
                  foregroundColor: AppColors.getMonoBackground(isDark),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  GoRouter.of(
                    context,
                  ).push('${RouteNames.mainApp}/${RouteNames.talkToLight}');
                },
                child: const Text("+ New Chat"),
              ),
            ),

            const SizedBox(height: 16),

            /// GROUPED LIST
            Expanded(
              child:
                  provider.conversations.isEmpty
                      ? Center(
                        child: Text(
                          "No conversations yet",
                          style: AppTextStyles.monoSecondary14(isDark),
                        ),
                      )
                      : ListView(
                        children: [
                          _buildGroup(context, "Today", grouped),
                          _buildGroup(context, "Yesterday", grouped),
                          _buildGroup(context, "Earlier", grouped),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(
    BuildContext context,
    String title,
    Map<String, List<dynamic>> grouped,
  ) {
    final provider = context.read<ChatProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final items = grouped[title] ?? [];

    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.monoSecondary14(isDark),
          ),
        ),
        ...items.map((convo) {
          final id = convo['id'];
          final title = convo['title'] ?? "Untitled Chat";

          return ListTile(
            title: Text(
              title,
              style: AppTextStyles.monoRegular16(isDark),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pop(context);
              provider.loadChatById(id);
            },
            trailing: PopupMenuButton<String>(
              color: AppColors.getMonoSurface(isDark), // background
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == "delete") {
                  provider.deleteConversation(id);
                } else if (value == "rename") {
                  _showRenameDialog(context, id, title);
                }
              },
              itemBuilder:
                  (_) => [
                    PopupMenuItem(
                      value: "rename",
                      child: Text(
                        "Rename",
                        style: AppTextStyles.monoRegular16(isDark),
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Text(
                        "Delete",
                        style: AppTextStyles.monoRegular16(isDark),
                      ),
                    ),
                  ],
            ),
          );
        }),
      ],
    );
  }

  void _showRenameDialog(BuildContext context, String id, String oldTitle) {
    final controller = TextEditingController(text: oldTitle);
    final provider = context.read<ChatProvider>();
    final isDark = context.read<ThemeProvider>().isDarkMode;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6), // background blur/dim
      builder:
          (_) => Dialog(
            backgroundColor: AppColors.getMonoCard(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// TITLE
                  Text("Rename Chat", style: AppTextStyles.monoBold22(isDark)),

                  const SizedBox(height: 16),

                  /// TEXT FIELD
                  TextField(
                    controller: controller,
                    style: AppTextStyles.monoRegular16(isDark),
                    cursorColor: AppColors.getMonoTextPrimary(isDark),
                    decoration: InputDecoration(
                      hintText: "Enter name",
                      hintStyle: AppTextStyles.monoSecondary14(isDark),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.getMonoBorder(isDark),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.getMonoTextPrimary(isDark),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ACTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: AppTextStyles.monoRegular16(isDark),
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          provider.renameConversation(
                            id,
                            controller.text.trim(),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save",
                          style: AppTextStyles.monoRegular16(
                            isDark,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
