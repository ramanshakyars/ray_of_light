import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/comment_sheet.dart';
import '../models/post_view_model.dart';
import '../post/media_carousel.dart';
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
    final colors = context.watch<ThemeProvider>().colors;
    final provider = context.read<SocialFeedProvider>();

    final hasText = post.caption.trim().isNotEmpty;
    final hasMedia = post.mediaUrls.isNotEmpty;
    final hasMood = post.mood != null && post.mood!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.divider,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ================= USER =================
          Row(
            children: [
              Text(
                post.username,
                style: AppTextStyles.cardTitle(colors),
              ),
              const SizedBox(width: 8),
              Text(
                _timeAgo(post.createdAt),
                style: AppTextStyles.hintText(colors),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// ================= MOOD =================
          if (hasMood) ...[
            Center(
              child: Text(
                post.mood!,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 14),
          ],

          /// ================= MEDIA =================
          if (hasMedia) ...[
            MediaCarousel(mediaUrls: post.mediaUrls),
            const SizedBox(height: 14),
          ],

          /// ================= TEXT =================
          if (hasText)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 50,
                  color: colors.border,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.caption,
                    style: AppTextStyles.bodyText(colors),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          /// ================= ACTION ROW =================
          Row(
            children: [
              _action(
                context,
                icon: post.liked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: post.likeCount.toString(),
                colors: colors,
                onTap: () => provider.toggleLike(post),
              ),
              const SizedBox(width: 24),
              _action(
                context,
                icon: Icons.chat_bubble_outline_rounded,
                label: post.commentCount.toString(),
                colors: colors,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CommentSheet(post: post),
                  );
                },
              ),
              const SizedBox(width: 24),
              _action(
                context,
                icon: Icons.ios_share_rounded,
                label: "",
                colors: colors,
                onTap: () {},
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
    required dynamic colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: colors.icon,
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.hintText(colors),
              ),
            ],
          ],
        ),
      ),
    );
  }
}