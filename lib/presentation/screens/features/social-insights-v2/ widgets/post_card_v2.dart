import 'package:flutter/material.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/comment_sheet.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/post/media_carousel.dart';
import '../models/post_view_model.dart';
import 'package:provider/provider.dart';
import '../provider/social_feed_provider.dart';

class PostCardV2 extends StatelessWidget {
  final PostViewModel post;

  const PostCardV2({super.key, required this.post});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inHours < 1) return "${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final provider = context.read<SocialFeedProvider>();
    final auth = context.watch<AuthProvider>();

    final hasText = post.caption.trim().isNotEmpty;
    final hasMedia = post.mediaUrls.isNotEmpty;
    final hasMood = post.mood != null && post.mood!.isNotEmpty;

    final primaryColor = AppColors.getMonoTextPrimary(isDark);
    final initials = auth.name.isNotEmpty ? auth.name[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.getMonoBorder(isDark).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= USER ROW =================
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                /// Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.getMonoBorder(isDark).withOpacity(0.4)),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: AppTextStyles.monoBold22(isDark).copyWith(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(auth.name, style: AppTextStyles.monoMedium18(isDark).copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                        _timeAgo(post.createdAt),
                        style: AppTextStyles.monoMuted12(isDark),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz_rounded, color: AppColors.getMonoIcon(isDark).withOpacity(0.5), size: 22),
              ],
            ),
          ),

          /// ================= MOOD =================
          if (hasMood) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(post.mood!, style: const TextStyle(fontSize: 48)),
              ),
            ),
          ],

          /// ================= MEDIA =================
          if (hasMedia) ...[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.zero, bottom: Radius.zero),
              child: MediaCarousel(mediaUrls: post.mediaUrls),
            ),
            const SizedBox(height: 14),
          ],

          /// ================= TEXT =================
          if (hasText)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: Text(
                post.caption,
                style: AppTextStyles.monoRegular16(isDark).copyWith(height: 1.6, fontSize: 15),
              ),
            ),

          /// ================= ACTION ROW =================
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: Row(
              children: [
                _action(
                  context,
                  icon: post.liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: post.likeCount.toString(),
                  isDark: isDark,
                  onTap: () => provider.toggleLike(post),
                  isActive: post.liked,
                ),
                const SizedBox(width: 28),
                _action(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: post.commentCount.toString(),
                  isDark: isDark,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentSheet(post: post),
                    );
                  },
                  isActive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final activeColor = AppColors.getMonoTextPrimary(isDark);
    final inactiveColor = AppColors.getMonoIcon(isDark);
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.monoMuted12(isDark).copyWith(
              color: color,
              fontSize: 13,
            )),
          ],
        ],
      ),
    );
  }
}

