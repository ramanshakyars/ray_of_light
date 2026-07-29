import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/presentation/screens/features/profile/thought_model.dart';

class ThoughtCard extends StatelessWidget {
  final ThoughtModel thought;
  final bool isDark;

  const ThoughtCard({super.key, required this.thought, required this.isDark});

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

  Color _typeColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'GRATITUDE':
        return const Color(0xFF22C55E);
      case 'REFLECTION':
        return const Color(0xFF6366F1);
      case 'MOOD':
        return const Color(0xFFF59E0B);
      case 'ANXIETY':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getMonoBorder(isDark).withOpacity(0.5),
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
                    color: _typeColor(thought.type).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _typeColor(thought.type).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    thought.type!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _typeColor(thought.type),
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
                style: AppTextStyles.monoMuted12(isDark),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─── Content ───
          Text(
            thought.content,
            style: AppTextStyles.monoRegular16(isDark).copyWith(
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
