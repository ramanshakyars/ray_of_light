import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final Widget? extraWidget; // ✅ optional extra widget

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.extraWidget, // ✅ now optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildBotAvatar(),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF0083B0)
                        : const Color(0xFF0F3460),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isUser ? 12 : 0),
                      topRight: Radius.circular(isUser ? 0 : 12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (extraWidget != null) ...[
                  const SizedBox(height: 8),
                  extraWidget!, // ✅ show only if passed
                ],
              ],
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
        child: Icon(Icons.auto_awesome, color: Colors.white),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      // Uncomment if you want user avatar
      // child: CircleAvatar(
      //   backgroundColor: Color(0xFF00B4DB),
      //   child: Icon(Icons.person, color: Colors.white),
      // ),
    );
  }
}
