import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import '../models/post_view_model.dart';
import '../post/media_carousel.dart';
import '../provider/social_feed_provider.dart';
import '../sheets/share_light_sheet.dart';

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

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getMonoBorder(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Text(
                post.username,
                style: AppTextStyles.monoMedium18(isDark),
              ),
              const SizedBox(width: 6),
              Text(
                _timeAgo(post.createdAt),
                style: AppTextStyles.monoMuted12(isDark),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// MEDIA
          if (post.mediaUrls.isNotEmpty)
            MediaCarousel(mediaUrls: post.mediaUrls),

          const SizedBox(height: 12),

          /// QUOTE STYLE CAPTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 3,
                height: 40,
                color: AppColors.getMonoBorder(isDark),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  post.caption,
                  style: AppTextStyles.monoRegular16(isDark),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ACTIONS
          Row(
            children: [
              _action(
                context,
                icon: post.liked
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: "${post.likeCount}",
                onTap: () => provider.toggleLike(post),
                isDark: isDark,
              ),
              _action(
                context,
                icon: Icons.chat_bubble_outline,
                label: "Comment",
                onTap: () {},
                isDark: isDark,
              ),
              _action(
                context,
                icon: Icons.share_outlined,
                label: "Share",
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const ShareLightSheet(),
                  );
                },
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.monoMuted12(isDark)),
          ],
        ),
      ),
    );
  }
}