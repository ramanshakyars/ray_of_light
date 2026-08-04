import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool? isDark;

  const PostCard({super.key, required this.post, this.isDark});

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final hasCaption = post.caption.trim().isNotEmpty;
    final hasMedia = post.mediaUrls.isNotEmpty;
    final authorName = post.authorName ?? 'You';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Author row ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      authorName.isNotEmpty ? authorName[0].toUpperCase() : 'Y',
                      style: AppTextStyles.cardTitle(colors).copyWith(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: AppTextStyles.cardTitle(colors).copyWith(fontSize: 14),
                      ),
                      Text(
                        _timeAgo(post.createdAt),
                        style: AppTextStyles.hintText(colors),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.public_rounded,
                  size: 16,
                  color: colors.textMuted,
                ),
              ],
            ),
          ),

          // ─── Media ───
          if (hasMedia) ...[
            _MediaGrid(mediaUrls: post.mediaUrls, colors: colors),
            const SizedBox(height: 12),
          ],

          // ─── Caption ───
          if (hasCaption)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                post.caption,
                style: AppTextStyles.bodyText(colors).copyWith(
                  height: 1.55,
                  fontSize: 15,
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // ─── Engagement row ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(
              children: [
                _engagementChip(
                  icon: Icons.favorite_border_rounded,
                  count: post.likeCount,
                  colors: colors,
                ),
                const SizedBox(width: 20),
                _engagementChip(
                  icon: Icons.chat_bubble_outline_rounded,
                  count: post.commentCount,
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _engagementChip({
    required IconData icon,
    required int count,
    required ThemeColors colors,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.icon),
        const SizedBox(width: 5),
        Text(
          count.toString(),
          style: AppTextStyles.hintText(colors),
        ),
      ],
    );
  }
}

// ─── Media grid: shows 1 or 2 images neatly ───
class _MediaGrid extends StatelessWidget {
  final List<String> mediaUrls;
  final ThemeColors colors;

  const _MediaGrid({required this.mediaUrls, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (mediaUrls.length == 1) {
      return _imgTile(mediaUrls[0], height: 220);
    }
    return Row(
      children: [
        Expanded(child: _imgTile(mediaUrls[0], height: 160)),
        const SizedBox(width: 2),
        Expanded(child: _imgTile(mediaUrls[1], height: 160)),
      ],
    );
  }

  Widget _imgTile(String url, {required double height}) {
    return SizedBox(
      height: height,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          color: colors.surface,
          child: Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: colors.primary)),
        ),
        errorWidget: (_, __, ___) => Container(
          color: colors.surface,
          child: Icon(Icons.broken_image_outlined,
              color: colors.textMuted),
        ),
      ),
    );
  }
}
