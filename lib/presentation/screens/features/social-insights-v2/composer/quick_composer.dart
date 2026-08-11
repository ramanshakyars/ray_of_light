import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class QuickComposer extends StatelessWidget {
  final VoidCallback onPhotoTap;
  final VoidCallback onMoodTap;
  final VoidCallback onTextTap;

  const QuickComposer({
    super.key,
    required this.onPhotoTap,
    required this.onMoodTap,
    required this.onTextTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: colors.border.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit_rounded,
              size: 18,
              color: colors.icon,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Share something...",
              style: AppTextStyles.bodySecondary(colors).copyWith(fontSize: 15),
            ),
          ),
          _item(Icons.image_outlined, onPhotoTap, colors),
          // Commented out for now
          // const SizedBox(width: 16),
          // _item(Icons.emoji_emotions_outlined, onMoodTap, colors),
          // const SizedBox(width: 16),
          // _item(Icons.text_fields_rounded, onTextTap, colors),
        ],
      ),
    );
  }

  Widget _item(IconData icon, VoidCallback tap, dynamic colors) {
    return GestureDetector(
      onTap: tap,
      child: Icon(icon, color: colors.icon, size: 22),
    );
  }
}