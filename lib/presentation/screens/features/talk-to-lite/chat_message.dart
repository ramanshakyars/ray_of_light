import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isUser;
  final bool animate;
  final Widget? extraWidget;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.animate = false,
    this.extraWidget,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  String _displayedText = "";
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isUser || !widget.animate) {
      // show user text instantly
      _displayedText = widget.text;
    } else {
      // animate bot text
      _startTypingEffect();
    }
  }

  void _startTypingEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
        //  if (!widget.isUser) _buildBotAvatar(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isUser ? AppColors.formsCardColor: AppColors.iconWhiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _displayedText,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  if (widget.extraWidget != null) ...[
                    const SizedBox(height: 10),
                    widget.extraWidget!,
                  ],
                ],
              ),
            ),
          ),
          if (widget.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: const CircleAvatar(
       // backgroundColor: Colors.blueAccent,
      //  child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
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
