import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatHistory> {
  List<dynamic> chatHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final result = await Talktolightservice.getChatHistory();
    setState(() {
      if (result['success'] == true && result['data'] != null) {
        chatHistory = result['data'];
      } else {
        chatHistory = [];
      }
      isLoading = false;
    });
  }

  Future<void> deleteChat(String chatId) async {
    await Talktolightservice.deleteChatHistory(chatId);
    setState(() {
      chatHistory.removeWhere((item) => item['id'].toString() == chatId);
    });
    MessageService.showSuccess(context, 'Chat deleted successfully');
  }

  Future<void> renameChat(String chatId, String newTitle) async {
    final result = await Talktolightservice.renameChatHistory(newTitle, chatId);

    if (result['success'] == true) {
      final updatedData = result['data'];
      setState(() {
        final index = chatHistory.indexWhere(
          (item) => item['id'].toString() == chatId,
        );
        if (index != -1) {
          chatHistory[index]['title'] = updatedData['title'];
        }
      });
      MessageService.showSuccess(context, 'Chat renamed successfully');
    } else {
      MessageService.showError(context, result['message']);
    }
  }

  void showRenameDialog(String chatId, String oldTitle) {
    final TextEditingController controller = TextEditingController(
      text: oldTitle,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.formsCardColor,
            title: Text("Rename Chat", style: AppTextStyles.medium18),
            content: TextField(
              controller: controller,
              style: AppTextStyles.regular16,
              decoration: const InputDecoration(
                hintText: "Enter new name",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: AppTextStyles.regular16),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.formSubmitButtonColor,
                  foregroundColor: AppColors.textPrimaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  renameChat(chatId, controller.text.trim());
                },
                child: Text("Save", style: AppTextStyles.medium18),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            color: AppColors.formsCardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Chat History", style: AppTextStyles.medium22),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textPrimaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              color: AppColors.appBackgroundColor,
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : chatHistory.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.history,
                              size: 50,
                              color: AppColors.textPrimaryColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No chat history found",
                              style: AppTextStyles.medium18,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.formSubmitButtonColor,
                                foregroundColor: AppColors.textPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                GoRouter.of(context).push(
                                  "${RouteNames.mainApp}/${RouteNames.talkToLight}",
                                );
                              },
                              child: Text(
                                "Start New Chat",
                                style: AppTextStyles.medium18,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: chatHistory.length,
                        itemBuilder: (context, index) {
                          final item = chatHistory[index];
                          final chatId = item['id'].toString();
                          final rawTitle = item['title'];
                          final title =
                              (rawTitle == null || rawTitle.trim().isEmpty)
                                  ? "Untitled Chat"
                                  : rawTitle.trim();

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            // leading: const Icon(
                            //   Icons.chat_bubble_outline,
                            //   color: AppColors.textPrimaryColor,
                            // ),
                            title: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.regular16,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              GoRouter.of(context).push(
                                "${RouteNames.mainApp}/${RouteNames.talkToLight}?chatId=$chatId",
                              );
                            },
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: AppColors.textPrimaryColor,
                              ),
                              onSelected: (value) {
                                if (value == 'delete') {
                                  deleteChat(chatId);
                                } else if (value == 'rename') {
                                  showRenameDialog(chatId, title);
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text("Delete"),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'rename',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: AppColors.textPrimaryColor,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text("Rename"),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
