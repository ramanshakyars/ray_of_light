import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/thought_model.dart';

class ThoughtCard extends StatelessWidget {
  final ThoughtModel thought;
  final bool? isDark;

  const ThoughtCard({super.key, required this.thought, this.isDark});

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      if (diff.inDays < 1) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  Color _typeColor(String? type, ThemeColors colors) {
    switch (type?.toUpperCase()) {
      case 'GRATITUDE':
        return colors.success;
      case 'REFLECTION':
        return colors.primary;
      case 'MOOD':
        return colors.warning;
      case 'ANXIETY':
        return colors.error;
      default:
        return colors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final badgeColor = _typeColor(thought.type, colors);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header row ───
          Row(
            children: [
              // Type badge
              if (thought.type != null && thought.type!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    thought.type!.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Specimen',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
              ] else
                const Spacer(),

              // Date
              Text(
                _formatDate(thought.createdAt),
                style: AppTextStyles.hintText(colors),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─── Content ───
          Text(
            thought.content,
            style: AppTextStyles.bodyText(colors).copyWith(
              height: 1.55,
              fontSize: 15,
            ),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
