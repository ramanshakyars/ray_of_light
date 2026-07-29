import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isUser;
  final bool animate;
  final Widget? extraWidget;
  final DateTime? timestamp;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.animate = false,
    this.extraWidget,
    this.timestamp,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  String _displayedText = "";
  int _currentIndex = 0;
  List<String> _textCharacters = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isUser || !widget.animate) {
      // show user text instantly
      _displayedText = widget.text;
    } else {
      // animate bot text
      _textCharacters = widget.text.characters.toList();
      _startTypingEffect();
    }
  }

  void _startTypingEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_currentIndex < _textCharacters.length) {
        setState(() {
          _displayedText += _textCharacters[_currentIndex];
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

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
                color: widget.isUser
                    ? (isDarkMode ? const Color(0xFF005C4B) : const Color(0xFFDCF8C6)) // WhatsApp user bubble colors
                    : (isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFFFFFFF)), // WhatsApp bot bubble colors
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    spreadRadius: 0.5,
                  )
                ],
              ),
              //   color: widget.isUser ? AppColors.getFormsCardColor(isDarkMode): AppColors.getTalkToLiteButtonBackgroundColor(isDarkMode),
              //   borderRadius: BorderRadius.circular(12),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _displayedText,
                    style: AppTextStyles.chatBotText(isDarkMode),
                  ),
                  if (widget.extraWidget != null) ...[
                    const SizedBox(height: 10),
                    widget.extraWidget!,
                  ],
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatTime(widget.timestamp ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday = time.year == now.year && time.month == now.month && time.day == now.day;
    
    int hour = time.hour;
    int minute = time.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String minuteStr = minute.toString().padLeft(2, '0');
    
    String timeStr = "$hour:$minuteStr $period";
    
    if (isToday) {
      return timeStr;
    } else {
      return "${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year} $timeStr";
    }
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
