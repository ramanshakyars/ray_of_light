import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
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

  BorderRadius _radius() {
    const full = Radius.circular(18);
    const tail = Radius.circular(4);

    if (widget.isUser) {
      return BorderRadius.only(
        topLeft: full,
        topRight: full,
        bottomLeft: full,
        bottomRight: widget.isLastInGroup ? tail : full,
      );
    } else {
      return BorderRadius.only(
        topLeft: full,
        topRight: full,
        bottomLeft: widget.isLastInGroup ? tail : full,
        bottomRight: full,
      );
    }
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
            top: widget.isFirstInGroup ? 8 : 2,
            bottom: widget.isLastInGroup ? 2 : 1,
            left: widget.isUser ? 60 : 0,
            right: widget.isUser ? 0 : 60,
          ),
          child: Align(
            alignment:
                widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: GestureDetector(
              onLongPress: () => _copyText(context),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isUser
                      ? colors.primary
                      : colors.surface,
                  borderRadius: _radius(),
                  border: Border.all(
                    color: widget.isUser
                        ? colors.primary
                        : colors.border.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: _BubbleContent(
                  text: widget.text,
                  time: timeStr,
                  isUser: widget.isUser,
                  colors: colors,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final String text;
  final String time;
  final bool isUser;
  final ThemeColors colors;

  const _BubbleContent({
    required this.text,
    required this.time,
    required this.isUser,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isUser
        ? colors.primaryForeground
        : colors.textPrimary;
    final timeColor = isUser
        ? colors.primaryForeground.withValues(alpha: 0.75)
        : colors.textMuted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 7),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextStyles.bodyText(colors).copyWith(
              color: textColor,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          if (time.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: AppTextStyles.hintText(colors).copyWith(
                    color: timeColor,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(
                  Icons.done_all_rounded,
                  size: 13,
                  color: timeColor,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
