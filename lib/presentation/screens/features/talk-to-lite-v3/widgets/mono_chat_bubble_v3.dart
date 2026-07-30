import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

/// WhatsApp-style chat bubble.
/// - User (right): dark pill, inline time + single tick
/// - AI (left):    surface pill, inline time, no tick
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

    // Animate only newest bubble in a group for performance
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

  // ── Time string:  "3:45 PM"
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
      // User: tail at bottom-right only on last bubble
      return BorderRadius.only(
        topLeft: full,
        topRight: full,
        bottomLeft: full,
        bottomRight: widget.isLastInGroup ? tail : full,
      );
    } else {
      // AI: tail at bottom-left only on last bubble
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
    final isDark = context.watch<ThemeProvider>().isDarkMode;
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
                      ? AppColors.getMonoTextPrimary(isDark)
                      : AppColors.getMonoSurface(isDark),
                  borderRadius: _radius(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: isDark ? 0.25 : 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: _BubbleContent(
                  text: widget.text,
                  time: timeStr,
                  isUser: widget.isUser,
                  isDark: isDark,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bubble content (text + inline time, WhatsApp style) ──────
class _BubbleContent extends StatelessWidget {
  final String text;
  final String time;
  final bool isUser;
  final bool isDark;

  const _BubbleContent({
    required this.text,
    required this.time,
    required this.isUser,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isUser
        ? AppColors.getMonoBackground(isDark)
        : AppColors.getMonoTextPrimary(isDark);
    final timeColor = isUser
        ? AppColors.getMonoBackground(isDark).withValues(alpha: 0.55)
        : AppColors.getMonoTextMuted(isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 7),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Message text ───────────────────────────────
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Arial',
              fontSize: 15,
              height: 1.5,
            ),
          ),

          // ── Time + tick row ────────────────────────────
          if (time.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: timeColor,
                    fontSize: 10,
                    fontFamily: 'Arial',
                    letterSpacing: 0.2,
                  ),
                ),
                // Double ticks (done_all) for both user and AI messages
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
