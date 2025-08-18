import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatHistory> {
  List<dynamic> chatHistory = [
    {"id": 1, "title": "Chat 1"},
    {"id": 2, "title": "Chat 2"},
    {"id": 3, "title": "Chat 3"},
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // 👇 future me jab API connect ho jaye to ye call uncomment kar dena
    // loadHistory();
  }

  Future<void> loadHistory() async {
    final result = await Talktolightservice.getChatHistory();
    setState(() {
      if (result['success'] == true && result['data'] != null) {
        chatHistory = result['data']['data'] ?? [];
      } else {
        chatHistory = [];
      }
      isLoading = false;
    });
  }

  /// ✅ Delete (dummy implementation abhi ke liye)
  Future<void> deleteChat(String chatId) async {
      final result = await Talktolightservice.deleteChatHistory(chatId);
    setState(() {
      chatHistory.removeWhere((item) => item['id'].toString() == chatId);
    });
    MessageService.showSuccess(context, 'Chat deleted successfully');
  }

  Future<void> renameChat(String chatId, String newTitle) async {
      final result = await Talktolightservice.renameChatHistory(newTitle,chatId);
    setState(() {
      final index = chatHistory.indexWhere(
        (item) => item['id'].toString() == chatId,
      );
      if (index != -1) {
        chatHistory[index]['title'] = newTitle;
      }
    });
    MessageService.showSuccess(context, 'Chat renamed successfully');
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
              decoration: const InputDecoration(hintText: "Enter new name"),
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
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : chatHistory.isEmpty
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 60, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    "No history found",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      GoRouter.of(
                        context,
                      ).push("${RouteNames.mainApp}/${RouteNames.talkToLight}");
                    },
                    icon: const Icon(Icons.add_comment),
                    label: const Text("Start New Chat"),
                  ),
                ],
              )
              : ListView.builder(
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final item = chatHistory[index];
                  final chatId = item['id'].toString();
                  final title = item['title'] ?? 'Untitled';

                  return ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.pop(context);
                      GoRouter.of(
                        context,
                      ).push("${RouteNames.mainApp}/${RouteNames.talkToLight}");
                    },
                    trailing: PopupMenuButton<String>(
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
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'rename',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
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
    );
  }
}
