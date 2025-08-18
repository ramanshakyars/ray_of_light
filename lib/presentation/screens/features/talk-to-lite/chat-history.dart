import 'package:flutter/material.dart';
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
    {
      "id": 1,
      "title": 'Chat 1',
    },
    {
      "id": 2,
      "title": 'Chat 2',
    },
    {
      "id": 3,
      "title": 'Chat 3',
    }
  ];
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
        chatHistory = result['data']['data'] ?? [];
      } else {
        chatHistory = [];
      }
      isLoading = false;
    });
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
                      Navigator.pop(context); // drawer band
                      GoRouter.of(context).push(
                        "${RouteNames.mainApp}/${RouteNames.talkToLight}", // ✅ apna chat screen route
                      );
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
                  final title = item['title'] ?? 'Untitled';
                  return ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.pop(context);
                      // agar chat detail id ke sath load karni ho toh yaha route add karke pass karo
                      GoRouter.of(
                        context,
                      ).push("${RouteNames.mainApp}/${RouteNames.talkToLight}");
                    },
                  );
                },
              ),
    );
  }
}
