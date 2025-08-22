import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
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
      final updatedData = result['data']; // backend ka fresh object

      setState(() {
        final index = chatHistory.indexWhere(
          (item) => item['id'].toString() == chatId,
        );
        if (index != -1) {
          // backend ke response se replace karo
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
            title: const Text("Rename Chat"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter new name",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  renameChat(chatId, controller.text.trim());
                },
                child: const Text("Save"),
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
          // Header with title and close button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.appBackgroundColor, // Dark blue header
              border: Border(
                bottom: BorderSide(color: Colors.blue.shade900, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chat History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              color: AppColors.appBackgroundColor, // Light blue background
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : chatHistory.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 60,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No chat history found",
                              style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                GoRouter.of(context).push(
                                  "${RouteNames.mainApp}/${RouteNames.talkToLight}",
                                );
                              },
                              icon: const Icon(Icons.add_comment),
                              label: const Text("Start New Chat"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: chatHistory.length,
                        itemBuilder: (context, index) {
                          final item = chatHistory[index];
                          final chatId = item['id'].toString();
                          final rawTitle = item['title'];
                          final title =
                              (rawTitle == null || rawTitle.trim().isEmpty)
                                  ? "Untitled Chat"
                                  : rawTitle.trim();

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.appBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.appBackgroundColor,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.blue[700],
                              ),
                              title: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 0, 0, 0),
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
                                  color: Colors.blue[700],
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
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red[700],
                                            ),
                                            const SizedBox(width: 8),
                                            const Text("Delete"),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'rename',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.blue[700],
                                            ),
                                            const SizedBox(width: 8),
                                            const Text("Rename"),
                                          ],
                                        ),
                                      ),
                                    ],
                              ),
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
