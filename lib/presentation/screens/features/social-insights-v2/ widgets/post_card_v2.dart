import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/comment_sheet.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/post/media_carousel.dart';
import '../models/post_view_model.dart';
import 'package:provider/provider.dart';
import '../sheets/report_post_sheet.dart';
import '../provider/social_feed_provider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/models/post_report_model.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';
import 'package:rayoflite/core/services/messageService.dart';

class PostCardV2 extends StatefulWidget {
  final PostViewModel post;

  const PostCardV2({super.key, required this.post});

  @override
  State<PostCardV2> createState() => _PostCardV2State();
}

class _PostCardV2State extends State<PostCardV2> with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnimation;
  bool _showHeartOverlay = false;

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _likeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _likeAnimController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

  void _onDoubleTapLike(SocialFeedProvider provider) {
    if (!widget.post.liked) {
      provider.toggleLike(widget.post);
    }
    setState(() {
      _showHeartOverlay = true;
    });
    _likeAnimController.forward(from: 0.0).then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showHeartOverlay = false;
          });
        }
      });
    });
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inHours < 1) return "${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  void _showPostOptionsMenu(BuildContext context, SocialFeedProvider provider, bool isDark, bool isAdmin) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: AppColors.getMonoCard(isDark),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.getMonoBorder(isDark)),
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
                  color: AppColors.getMonoBorder(isDark),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Post Options",
                  style: AppTextStyles.monoMedium18(isDark).copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.getMonoIcon(isDark)),
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
                style: AppTextStyles.monoMedium18(isDark).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Report inappropriate or harmful content",
                style: AppTextStyles.monoMuted12(isDark),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _openReportSheet(context);
              },
            ),
            if (isAdmin) ...[
              Divider(color: AppColors.getMonoBorder(isDark).withOpacity(0.4)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.getMonoTextPrimary(isDark).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.shield_outlined, color: AppColors.getMonoTextPrimary(isDark), size: 20),
                ),
                title: Text(
                  "Moderate Post",
                  style: AppTextStyles.monoMedium18(isDark).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Change visibility or add moderation notes",
                  style: AppTextStyles.monoMuted12(isDark),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showModerationSheet(context, provider, isDark);
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
      builder: (_) => ReportPostSheet(postId: widget.post.id),
    );
    if (reported == true && context.mounted) {
      context.read<SocialFeedProvider>().removePost(widget.post.id);
    }
  }

  void _showModerationSheet(BuildContext context, SocialFeedProvider provider, bool isDark) {
    final reasonController = TextEditingController(text: widget.post.moderationReason ?? '');
    bool isActive = widget.post.active;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 32),
          decoration: BoxDecoration(
            color: AppColors.getMonoCard(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.getMonoBorder(isDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Moderate Post",
                style: AppTextStyles.monoMedium18(isDark).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Visible in Feed", style: AppTextStyles.monoRegular16(isDark)),
                  Switch(
                    value: isActive,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      setModalState(() {
                        isActive = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Moderation Reason",
                style: AppTextStyles.monoSecondary14(isDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                maxLines: 3,
                style: AppTextStyles.monoRegular16(isDark),
                decoration: InputDecoration(
                  hintText: "Provide reason for deactivating or approving...",
                  hintStyle: AppTextStyles.monoMuted12(isDark),
                  filled: true,
                  fillColor: AppColors.getMonoSurface(isDark),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.getMonoBorder(isDark).withOpacity(0.6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.getMonoTextPrimary(isDark)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getMonoTextPrimary(isDark),
                    foregroundColor: AppColors.getMonoBackground(isDark),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await provider.moderatePost(widget.post, isActive, reasonController.text.trim());
                  },
                  child: const Text("Apply Moderation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReportReason(BuildContext context, PostReportReason reason) async {
    try {
      await SocialService.reportPost(
        postId: widget.post.id,
        reason: reason,
      );
      if (mounted) {
        context.read<SocialFeedProvider>().removePost(widget.post.id);
        MessageService.showSuccess(context, 'Report submitted successfully.');
      }
    } catch (e) {
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final provider = context.read<SocialFeedProvider>();
    final auth = context.watch<AuthProvider>();

    final hasText = widget.post.caption.trim().isNotEmpty;
    final hasMedia = widget.post.mediaUrls.isNotEmpty;
    final hasMood = widget.post.mood != null && widget.post.mood!.isNotEmpty;

    final primaryColor = AppColors.getMonoTextPrimary(isDark);
    final initials = widget.post.username.isNotEmpty ? widget.post.username[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= USER ROW =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                /// Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.getMonoBorder(isDark).withOpacity(0.3)),
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
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.post.username.isNotEmpty 
        ? '${widget.post.username[0].toUpperCase()}${widget.post.username.substring(1)}' 
        : '',
                              style: AppTextStyles.monoMedium18(isDark).copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (auth.isAdmin) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "ADMIN",
                                style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            )
                          ]
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _timeAgo(widget.post.createdAt),
                        style: AppTextStyles.monoMuted12(isDark),
                      ),
                    ],
                  ),
                ),
                
                // Three-Dots Menu Icon for Extensible Options
                IconButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.getMonoIcon(isDark).withOpacity(0.7),
                    size: 22,
                  ),
                  onPressed: () => _showPostOptionsMenu(context, provider, isDark, auth.isAdmin),
                ),
              ],
            ),
          ),

          /// ================= MODERATION STATUS (ADMIN ONLY) =================
          if (auth.isAdmin && !widget.post.active) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.getMonoBorder(isDark).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.getMonoBorder(isDark).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.visibility_off_outlined, color: AppColors.getMonoIcon(isDark), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Deactivated: ${widget.post.moderationReason != null && widget.post.moderationReason!.trim().isNotEmpty ? widget.post.moderationReason : 'No reason provided'}",
                      style: AppTextStyles.monoRegular16(isDark).copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          /// ================= MOOD =================
          if (hasMood) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(widget.post.mood!, style: const TextStyle(fontSize: 48)),
              ),
            ),
          ],

          /// ================= MEDIA (Instagram Double Tap) =================
          if (hasMedia) ...[
            GestureDetector(
              onDoubleTap: () => _onDoubleTapLike(provider),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.zero, bottom: Radius.zero),
                    child: MediaCarousel(mediaUrls: widget.post.mediaUrls),
                  ),
                  
                  // Heart Overlay Animation
                  if (_showHeartOverlay)
                    ScaleTransition(
                      scale: _likeScaleAnimation,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 110,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          /// ================= TEXT =================
          if (hasText)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text(
                widget.post.caption,
                style: AppTextStyles.monoRegular16(isDark).copyWith(height: 1.5, fontSize: 15),
              ),
            ),

          /// ================= ACTION ROW =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(
              children: [
                _action(
                  context,
                  icon: widget.post.liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: widget.post.likeCount.toString(),
                  isDark: isDark,
                  onTap: () => provider.toggleLike(widget.post),
                  isActive: widget.post.liked,
                ),
                const SizedBox(width: 28),
                _action(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: widget.post.commentCount.toString(),
                  isDark: isDark,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentSheet(post: widget.post),
                    );
                  },
                  isActive: false,
                ),
              ],
            ),
          ),

          /// ================= CLEAN FEED DIVIDER (X-Style) =================
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.getMonoDivider(isDark),
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
    final activeColor = Colors.redAccent;
    final inactiveColor = AppColors.getMonoIcon(isDark).withOpacity(0.7);
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.monoMuted12(isDark).copyWith(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            )),
          ],
        ],
      ),
    );
  }
}
