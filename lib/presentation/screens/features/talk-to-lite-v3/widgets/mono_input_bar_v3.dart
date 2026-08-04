import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MonoInputBarV3 extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  const MonoInputBarV3({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  State<MonoInputBarV3> createState() => _MonoInputBarV3State();
}

class _MonoInputBarV3State extends State<MonoInputBarV3> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) {
      setState(() => _hasText = has);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _handleSend() {
    if (widget.isLoading || !_hasText) return;
    HapticFeedback.lightImpact();
    widget.onSend();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final hasKeyboard = bottomInset > 0;

    return Container(
      color: colors.background,
      padding: EdgeInsets.only(
        bottom: hasKeyboard ? 8 : 76, // 76px clears floating bottom navbar neatly without overlap
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(
            top: BorderSide(
              color: colors.border.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Text Field ──
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.inputBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _hasText
                        ? colors.primary.withValues(alpha: 0.6)
                        : colors.inputBorder,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  enabled: !widget.isLoading,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences, // First letter always capitalized
                  style: AppTextStyles.inputText(colors),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: widget.isLoading
                        ? "Light is typing..."
                        : "Message Light...",
                    hintStyle: AppTextStyles.hintText(colors).copyWith(
                      fontStyle: widget.isLoading
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),

            // ── Animated Send Button ──
            _buildAnimatedSendButton(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSendButton(ThemeColors colors) {
    final show = _hasText || widget.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: show ? 42 : 0,
      margin: EdgeInsets.only(left: show ? 8 : 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: show ? 1.0 : 0.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: 42,
            child: widget.isLoading
                ? _SendButtonShell(
                    colors: colors,
                    active: false,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primaryForeground,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _handleSend,
                    child: _SendButtonShell(
                      colors: colors,
                      active: _hasText,
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: colors.primaryForeground,
                        size: 20,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SendButtonShell extends StatelessWidget {
  final ThemeColors colors;
  final bool active;
  final Widget child;

  const _SendButtonShell({
    required this.colors,
    required this.active,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? colors.primary : colors.surface,
        border: Border.all(
          color: active ? Colors.transparent : colors.border,
          width: 1.2,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Center(child: child),
    );
  }
}
