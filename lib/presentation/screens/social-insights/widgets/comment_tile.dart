import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/presentation/screens/social-insights/models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final bool isDark;

  const CommentTile({super.key, required this.comment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.getPrimary(isDark),
            child: Text(
              comment.author.username[0].toUpperCase(),
              style: AppTextStyles.bold22(isDark).copyWith(
                fontSize: 12,
                color: AppColors.getPrimaryForeground(isDark),
              ),
            ),
          ),
          const SizedBox(width: 10),
          
          // Comment content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.getMuted(isDark),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment.author.username,
                        style: AppTextStyles.medium18(isDark)
                            .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _formatTime(comment.createdAt),
                        style: AppTextStyles.regular14(isDark).copyWith(
                          fontSize: 12,
                          color: AppColors.getMutedForeground(isDark),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    comment.text,
                    style: AppTextStyles.regular14(isDark),
                  ),
                  const SizedBox(height: 8),
                  
                  // Actions row
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.thumb_up_alt_outlined,
                        label: 'Like',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.reply_outlined,
                        label: 'Reply',
                        isDark: isDark,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.more_horiz,
                        size: 18,
                        color: AppColors.getMutedForeground(isDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.getMutedForeground(isDark),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.regular14(isDark).copyWith(
            fontSize: 12,
            color: AppColors.getMutedForeground(isDark),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}