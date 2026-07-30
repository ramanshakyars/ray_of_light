import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

import '../models/chat_message_model.dart';
import '../provider/chat_provider_v3.dart';

import '../../talk-to-lite-v2/widgets/mono_typing_indicator.dart';
import 'date_separator_v3.dart';
import 'mono_chat_bubble_v3.dart';
import 'mono_input_bar_v3.dart';

// ── A sealed discriminated union for list items ───────────────
abstract class _ListItem {}

class _MessageItem extends _ListItem {
  final ChatMessageModel message;
  final int originalIndex;
  _MessageItem(this.message, this.originalIndex);
}

class _DateItem extends _ListItem {
  final DateTime date;
  _DateItem(this.date);
}

class _LoadMoreItem extends _ListItem {}

class _TypingItem extends _ListItem {}

// ─────────────────────────────────────────────────────────────
class ChatBodyV3 extends StatefulWidget {
  const ChatBodyV3({super.key});

  @override
  State<ChatBodyV3> createState() => _ChatBodyV3State();
}

class _ChatBodyV3State extends State<ChatBodyV3> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ── Build flat item list with date separators ─────────────
  List<_ListItem> _buildItems(
    List<ChatMessageModel> messages,
    bool isLoadingMore,
    bool isTyping,
  ) {
    final items = <_ListItem>[];

    // Load-more spinner always at very top
    if (isLoadingMore) {
      items.add(_LoadMoreItem());
    }

    DateTime? lastDate;

    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final msgDate = _parseDate(msg.timestamp);

      // Insert date separator when date changes
      if (msgDate != null) {
        final day = DateTime(msgDate.year, msgDate.month, msgDate.day);
        if (lastDate == null || day != lastDate) {
          items.add(_DateItem(day));
          lastDate = day;
        }
      }

      items.add(_MessageItem(msg, i));
    }

    if (isTyping) {
      items.add(_TypingItem());
    }

    return items;
  }

  DateTime? _parseDate(String? ts) {
    if (ts == null || ts.isEmpty) return null;
    try {
      return DateTime.parse(ts).toLocal();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProviderV3>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Column(
      children: [
        Expanded(
          child: provider.isLoading
              ? _buildLoadingState(isDark)
              : provider.messages.isEmpty
                  ? _buildWelcomeState(isDark)
                  : _buildMessageList(context, provider, isDark),
        ),

        // ── Input Bar ─────────────────────────────────────
        MonoInputBarV3(
          controller: controller,
          isLoading: provider.isTyping,
          onSend: () {
            final text = controller.text.trim();
            if (text.isEmpty) return;
            provider.sendMessage(text);
            controller.clear();
          },
        ),
      ],
    );
  }

  // ── Loading state — shimmer skeleton bubbles ───────────────
  Widget _buildLoadingState(bool isDark) {
    // Fake bubble layout: true = right (user), false = left (AI)
    const pattern = [false, true, false, false, true];
    const widths = [0.55, 0.45, 0.7, 0.4, 0.6];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pattern.length,
      itemBuilder: (_, i) => _ShimmerBubble(
        isRight: pattern[i],
        widthFactor: widths[i],
        delayMs: i * 120,
        isDark: isDark,
      ),
    );
  }

  // ── Welcome / empty state ────────────────────────────────
  Widget _buildWelcomeState(bool isDark) {
    final suggestions = [
      "How are you feeling today?",
      "I need help relaxing 🌿",
      "Talk me through breathing",
      "I'm feeling anxious",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 16),
      child: Column(
        children: [
          // Avatar with glow
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.getMonoSurface(isDark),
              border: Border.all(
                color: AppColors.getMonoBorder(isDark),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getMonoTextPrimary(isDark)
                      .withValues(alpha: isDark ? 0.15 : 0.07),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/talk-to-light.png',
                color: AppColors.getMonoIcon(isDark),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Hi, I\'m Light ✨',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.getMonoTextPrimary(isDark),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Your personal AI companion.\nI\'m here to listen, support & guide you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 15,
              height: 1.55,
              color: AppColors.getMonoTextSecondary(isDark),
            ),
          ),

          const SizedBox(height: 32),

          // ── "Try asking" divider ────────────────────────
          Row(
            children: [
              Expanded(child: _Divider(isDark: isDark)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Try asking',
                  style: AppTextStyles.monoMuted12(isDark),
                ),
              ),
              Expanded(child: _Divider(isDark: isDark)),
            ],
          ),

          const SizedBox(height: 16),

          // ── Suggestion chips ────────────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: suggestions
                .map(
                  (s) => _SuggestionChip(
                    label: s,
                    isDark: isDark,
                    onTap: () {
                      context.read<ChatProviderV3>().sendMessage(s);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── Message list with WhatsApp-style date separators ─────
  Widget _buildMessageList(
    BuildContext context,
    ChatProviderV3 provider,
    bool isDark,
  ) {
    final items = _buildItems(
      provider.messages,
      provider.isLoadingMoreMessages,
      provider.isTyping,
    );

    return ListView.builder(
      controller: provider.scrollController,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        // ── Load more spinner (top) ─────────────────────
        if (item is _LoadMoreItem) {
          return Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 10),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.getMonoTextSecondary(isDark),
                ),
              ),
            ),
          );
        }

        // ── Date separator pill ─────────────────────────
        if (item is _DateItem) {
          return DateSeparatorV3(date: item.date, isDark: isDark);
        }

        // ── Typing indicator ────────────────────────────
        if (item is _TypingItem) {
          return const Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: MonoTypingIndicator(),
          );
        }

        // ── Chat message bubble ─────────────────────────
        if (item is _MessageItem) {
          final msg = item.message;
          final originalIndex = item.originalIndex;
          final msgs = provider.messages;

          // Group detection: consecutive same-sender bubbles
          final isFirstInGroup = originalIndex == 0 ||
              msgs[originalIndex - 1].isUser != msg.isUser;
          final isLastInGroup = originalIndex == msgs.length - 1 ||
              msgs[originalIndex + 1].isUser != msg.isUser;

          return MonoChatBubbleV3(
            text: msg.content,
            isUser: msg.isUser,
            timestamp: msg.timestamp,
            isFirstInGroup: isFirstInGroup,
            isLastInGroup: isLastInGroup,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.getMonoBorder(isDark));
  }
}

class _SuggestionChip extends StatefulWidget {
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isDark
                ? AppColors.monoDarkSurface
                : AppColors.monoLightSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.getMonoBorder(widget.isDark)),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 13,
              color: AppColors.getMonoTextPrimary(widget.isDark),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shimmer skeleton bubble (loading state) ───────────────────
class _ShimmerBubble extends StatefulWidget {
  final bool isRight;
  final double widthFactor; // fraction of screen width
  final int delayMs;
  final bool isDark;

  const _ShimmerBubble({
    required this.isRight,
    required this.widthFactor,
    required this.delayMs,
    required this.isDark,
  });

  @override
  State<_ShimmerBubble> createState() => _ShimmerBubbleState();
}

class _ShimmerBubbleState extends State<_ShimmerBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacity = Tween<double>(begin: 0.25, end: 0.75).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    // Staggered start
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleWidth = screenWidth * widget.widthFactor;

    final baseColor = widget.isDark
        ? AppColors.monoDarkSurface
        : const Color(0xFFE5E5E5);

    return Padding(
      padding: EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: widget.isRight ? screenWidth * (1 - widget.widthFactor) - 28 : 0,
        right: widget.isRight ? 0 : screenWidth * (1 - widget.widthFactor) - 28,
      ),
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (_, __) => Opacity(
          opacity: _opacity.value,
          child: Column(
            crossAxisAlignment: widget.isRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Main bubble bar
              Container(
                width: bubbleWidth,
                height: 40,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 4),
              // Fake timestamp bar
              Container(
                width: 50,
                height: 8,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
