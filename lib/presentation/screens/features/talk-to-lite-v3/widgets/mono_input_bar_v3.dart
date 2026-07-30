import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
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
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getMonoBackground(isDark),
          border: Border(
            top: BorderSide(
              color: AppColors.getMonoBorder(isDark).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ── Text Field (takes 100% width when idle, shrinks on typing) ──
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.getMonoSurface(isDark),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: _hasText
                        ? AppColors.getMonoTextPrimary(isDark).withValues(alpha: 0.35)
                        : AppColors.getMonoBorder(isDark),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  enabled: !widget.isLoading,
                  minLines: 1,
                  maxLines: 5,
                  style: AppTextStyles.monoRegular16(isDark),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: widget.isLoading
                        ? "Light is typing..."
                        : "Message Light...",
                    hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: AppColors.getMonoTextMuted(isDark),
                      fontStyle: widget.isLoading
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),

            // ── Animated Send Button (expands into view when typing) ──
            _buildAnimatedSendButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSendButton(bool isDark) {
    final show = _hasText || widget.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: show ? 46 : 0,
      margin: EdgeInsets.only(left: show ? 10 : 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: show ? 1.0 : 0.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: 46,
            child: widget.isLoading
                ? _SendButtonShell(
                    isDark: isDark,
                    active: false,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.getMonoBackground(isDark),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _handleSend,
                    child: _SendButtonShell(
                      isDark: isDark,
                      active: _hasText,
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.getMonoBackground(isDark),
                        size: 22,
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
  final bool isDark;
  final bool active;
  final Widget child;

  const _SendButtonShell({
    required this.isDark,
    required this.active,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? AppColors.getMonoTextPrimary(isDark)
            : AppColors.getMonoSurface(isDark),
        border: Border.all(
          color: active
              ? Colors.transparent
              : AppColors.getMonoBorder(isDark),
          width: 1.2,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.getMonoTextPrimary(isDark).withValues(alpha: 0.25),
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
