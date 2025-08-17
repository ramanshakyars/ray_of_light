import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/talkToLightService.dart';

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
    final data = await Talktolightservice.getChatHistory();
    setState(() {
      chatHistory = data as List;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final item = chatHistory[index];
                final title = item['title'] ?? 'Untitled'; // sirf title show
                return ListTile(
                  title: Text(title),
                  onTap: () {
                    Navigator.pop(context);                    
                  },
                );
              },
            ),
    );
  }
}

