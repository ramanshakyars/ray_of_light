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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                AppColors.getTalkToLiteButtonBackgroundColor(isDark),
            child: Text(
              comment.author.username[0].toUpperCase(),
              style: AppTextStyles.bold22(isDark).copyWith(fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.getInputBackground(isDark),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.author.username,
                    style: AppTextStyles.medium18(isDark)
                        .copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.text,
                    style: AppTextStyles.regular14(isDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
