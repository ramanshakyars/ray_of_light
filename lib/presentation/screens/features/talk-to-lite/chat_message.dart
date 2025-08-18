import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final Widget? extraWidget;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildBotAvatar(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFF0083B0) : const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  if (extraWidget != null) ...[
                    const SizedBox(height: 10),
                    extraWidget!, // ✅ shown inline inside the same bubble
                  ],
                ],
              ),
            ),
          ),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: const CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      // Uncomment if you want a user avatar
      // child: const CircleAvatar(
      //   backgroundColor: Color(0xFF00B4DB),
      //   child: Icon(Icons.person, color: Colors.white),
      // ),
    );
  }
}
