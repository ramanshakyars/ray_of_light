import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    final TextEditingController controller = TextEditingController(
      text: oldTitle,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.getFormsCardColor(isDarkMode),
            title: Text(
              "Rename Chat",
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(isDarkMode),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Specimen',
              ),
            ),
            content: TextField(
              controller: controller,
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(isDarkMode),
                fontSize: 16,
                fontFamily: 'Specimen',
              ),
              decoration: InputDecoration(
                hintText: "Enter new name",
                hintStyle: TextStyle(
                  color: AppColors.getTextPrimaryColor(
                    isDarkMode,
                  ).withOpacity(0.6),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontSize: 16,
                    fontFamily: 'Specimen',
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.getFormSubmitButtonColor(
                    isDarkMode,
                  ),
                  foregroundColor: AppColors.getTextSecondaryColor(isDarkMode),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  renameChat(chatId, controller.text.trim());
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Specimen',
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Drawer(
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            color: AppColors.getFormsCardColor(isDarkMode),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chat History",
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Specimen',
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Main content
          // Main content
          // 🔹 Chat list (with New Chat button as first item)
          Expanded(
            child: ListView.builder(
              itemCount: chatHistory.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.getFormSubmitButtonColor(
                            isDarkMode,
                          ),
                          foregroundColor: AppColors.getTextSecondaryColor(
                            isDarkMode,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(
                            "${RouteNames.mainApp}/${RouteNames.talkToLight}",
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: Text(
                          "New Chat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Specimen',
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final item = chatHistory[index - 1];
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
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.getTextPrimaryColor(isDarkMode),
                      fontSize: 16,
                      fontFamily: 'Specimen',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    GoRouter.of(context).push(
                      "${RouteNames.mainApp}/${RouteNames.talkToLight}?chatId=$chatId",
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.getTextPrimaryColor(isDarkMode),
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
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: AppColors.getTextPrimaryColor(
                                      isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'rename',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColors.getTextPrimaryColor(
                                    isDarkMode,
                                  ),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Rename",
                                  style: TextStyle(
                                    color: AppColors.getTextPrimaryColor(
                                      isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
