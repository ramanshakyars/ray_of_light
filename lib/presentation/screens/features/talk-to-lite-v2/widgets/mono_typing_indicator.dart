import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MonoTypingIndicator extends StatefulWidget {
  const MonoTypingIndicator({super.key});

  @override
  State<MonoTypingIndicator> createState() =>
      _MonoTypingIndicatorState();
}

class _MonoTypingIndicatorState
    extends State<MonoTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.watch<ThemeProvider>().isDarkMode;

    final dotColor =
        AppColors.getMonoTextPrimary(isDark);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:
            const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              AppColors.getMonoSurface(isDark),
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0, dotColor),
            const SizedBox(width: 4),
            _buildDot(1, dotColor),
            const SizedBox(width: 4),
            _buildDot(2, dotColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final animationValue =
            (_controller.value + index * 0.2) % 1;

        final opacity =
            animationValue < 0.5
                ? animationValue * 2
                : (1 - animationValue) * 2;

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}