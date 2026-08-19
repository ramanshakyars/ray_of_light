import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/comment_sheet.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/sheets/report_post_sheet.dart';
import '../models/post_view_model.dart';
import '../post/media_carousel.dart';
import '../provider/social_feed_provider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/models/post_report_model.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';

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

  void _showReportReasonsMenu(BuildContext context) {
    final colors = context.read<ThemeProvider>().colors;
    final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(MediaQuery.of(context).size.width - 220, 120, 200, 200),
      Offset.zero & (overlay?.size ?? Size.zero),
    );

    showMenu<PostReportReason>(
      context: context,
      position: position,
      color: colors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
      items: [
        PopupMenuItem<PostReportReason>(
          enabled: false,
          height: 32,
          child: Text(
            'SELECT REASON',
            style: AppTextStyles.hintText(colors).copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const PopupMenuDivider(),
        ...PostReportReason.values.map(
          (reason) => PopupMenuItem<PostReportReason>(
            value: reason,
            child: Row(
              children: [
                Icon(
                  reason.icon,
                  size: 18,
                  color: colors.icon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    reason.title,
                    style: AppTextStyles.bodyText(colors).copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).then((reason) {
      if (reason != null && context.mounted) {
        _submitReportReason(context, reason);
      }
    });
  }

  void _showModerateDialog(BuildContext context, SocialFeedProvider provider) {
    final colors = context.read<ThemeProvider>().colors;
    final reasonController = TextEditingController(
      text: post.moderationReason ?? 'Inappropriate content',
    );
    bool newActiveState = !post.active;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            backgroundColor: colors.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Moderate Post',
              style: AppTextStyles.cardTitle(colors),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Status: ', style: AppTextStyles.bodyText(colors)),
                    ChoiceChip(
                      label: Text(newActiveState ? 'Active' : 'Inactive'),
                      selected: newActiveState,
                      selectedColor: Colors.green.withOpacity(0.2),
                      onSelected: (val) {
                        setDlgState(() => newActiveState = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  style: AppTextStyles.bodyText(colors),
                  decoration: InputDecoration(
                    labelText: 'Moderation Reason',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    await provider.moderatePost(
                      post,
                      newActiveState,
                      reasonController.text.trim(),
                    );
                    if (context.mounted) {
                      MessageService.showSuccess(context, 'Post updated successfully.');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      MessageService.showError(context, 'Failed to moderate post: $e');
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitReportReason(BuildContext context, PostReportReason reason) async {
    try {
      await SocialService.reportPost(
        postId: post.id,
        reason: reason,
      );
      if (context.mounted) {
        context.read<SocialFeedProvider>().removePost(post.id);
        MessageService.showSuccess(context, 'Report submitted successfully.');
      }
    } catch (e) {
      if (context.mounted) {
        String errorMsg = 'Failed to submit report';
        if (e is DioException && e.response?.data != null && e.response?.data is Map) {
          errorMsg = e.response?.data['message'] ?? e.response?.data['error'] ?? errorMsg;
        } else {
          errorMsg = e.toString().replaceAll('Exception:', '').trim();
        }
        if (errorMsg.toLowerCase().contains('own post') ||
            errorMsg.toLowerCase().contains('cannot report your own')) {
          errorMsg = 'You cannot report your own post';
        }

        MessageService.showError(context, errorMsg);
      }
    }
  }

  void _showPostOptionsMenu(BuildContext context, SocialFeedProvider provider, bool isAdmin) {
    final colors = context.read<ThemeProvider>().colors;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Post Options",
                  style: AppTextStyles.cardTitle(colors).copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.icon),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.outlined_flag_rounded, color: Colors.redAccent, size: 20),
              ),
              title: Text(
                "Report Post",
                style: AppTextStyles.bodyText(colors).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Report inappropriate or harmful content",
                style: AppTextStyles.hintText(colors),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _openReportSheet(context);
              },
            ),
            if (isAdmin) ...[
              Divider(color: colors.border.withOpacity(0.4)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.textPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.shield_outlined, color: colors.textPrimary, size: 20),
                ),
                title: Text(
                  "Moderate Post",
                  style: AppTextStyles.bodyText(colors).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Change visibility or add moderation notes",
                  style: AppTextStyles.hintText(colors),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showModerateDialog(context, provider);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openReportSheet(BuildContext context) async {
    final reported = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReportPostSheet(postId: post.id),
    );
    if (reported == true && context.mounted) {
      context.read<SocialFeedProvider>().removePost(post.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final auth = context.watch<AuthProvider>();
    final provider = context.read<SocialFeedProvider>();

    final hasText = post.caption.trim().isNotEmpty;
    final hasMedia = post.mediaUrls.isNotEmpty;
    final hasMood = post.mood != null && post.mood!.isNotEmpty;
    final isAdmin = auth.isAdmin;

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
          /// ================= USER & ACTIONS HEADER =================
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
              if (!post.active) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.border.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Deactivated: ${post.moderationReason != null && post.moderationReason!.trim().isNotEmpty ? post.moderationReason : 'No reason provided'}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colors.icon,
                  size: 22,
                ),
                onPressed: () => _showPostOptionsMenu(context, provider, isAdmin),
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