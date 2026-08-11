import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

/// Theme-aware chat bubble.
/// - User (right): primary color pill, inline time + double tick
/// - AI (left):    card/surface pill, inline time + double tick
/// - Grouped bubbles share adjusted border radii
/// - Long-press → copy to clipboard
class MonoChatBubbleV3 extends StatefulWidget {
  final String text;
  final bool isUser;
  final String? timestamp;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  const MonoChatBubbleV3({
    super.key,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
  });

  @override
  State<MonoChatBubbleV3> createState() => _MonoChatBubbleV3State();
}

class _MonoChatBubbleV3State extends State<MonoChatBubbleV3>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _slide = Tween<Offset>(
      begin: widget.isUser ? const Offset(0.25, 0) : const Offset(-0.25, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    if (widget.isLastInGroup) {
      _ctrl.forward();
    } else {
      _ctrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _formatTime(String? ts) {
    if (ts == null || ts.isEmpty) return '';
    try {
      final dt = DateTime.parse(ts).toLocal();
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    } catch (_) {
      return '';
    }
  }

  void _copyText(BuildContext context) {
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: widget.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Copied to clipboard'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final timeStr = _formatTime(widget.timestamp);

    return SlideTransition(
      position: _slide,
      child: ScaleTransition(
        scale: _scale,
        alignment:
            widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.isFirstInGroup ? 8 : 3,
            bottom: widget.isLastInGroup ? 4 : 1,
            left: widget.isUser ? 50 : 0,
            right: widget.isUser ? 0 : 40,
          ),
          child: Align(
            alignment:
                widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: widget.isUser
                ? _buildUserBubble(context, colors, timeStr)
                : _buildBotBubble(context, colors, timeStr),
          ),
        ),
      ),
    );
  }

  Widget _buildUserBubble(BuildContext context, ThemeColors colors, String timeStr) {
    return GestureDetector(
      onLongPress: () => _copyText(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        decoration: BoxDecoration(
          color: const Color(0xFF666666), // Gray bubble for user question
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                fontFamily: 'Specimen',
                color: Colors.white,
                fontSize: 15,
                height: 1.45,
              ),
            ),
            if (timeStr.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontFamily: 'Specimen',
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBotBubble(BuildContext context, ThemeColors colors, String timeStr) {
    return GestureDetector(
      onLongPress: () => _copyText(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBF7), // Warm light card bubble matching Image 2
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFEBE5DF),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _FormattedText(
              text: widget.text,
              style: const TextStyle(
                fontFamily: 'Specimen',
                color: Color(0xFF2C2C2C),
                fontSize: 15,
                height: 1.55,
              ),
            ),
            if (timeStr.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontFamily: 'Specimen',
                      color: Colors.black.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_rounded,
                    size: 12,
                    color: const Color(0xFFD9A76A), // Subtle warm gold check mark
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FormattedText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _FormattedText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final regExp = RegExp(r'\*\*(.*?)\*\*');
    int start = 0;

    for (final match in regExp.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: style.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: style,
        children: spans,
      ),
    );
  }
}

