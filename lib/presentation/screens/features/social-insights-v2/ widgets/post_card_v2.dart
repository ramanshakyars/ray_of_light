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

  void _showModerationSheet(BuildContext context, SocialFeedProvider provider, bool isDark) {
    final reasonController = TextEditingController(text: widget.post.moderationReason ?? '');
    bool isActive = widget.post.active;

    showModalBottomSheet(
      context: context,
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

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final provider = context.read<SocialFeedProvider>();
    final auth = context.watch<AuthProvider>();

    final hasText = widget.post.caption.trim().isNotEmpty;
    final hasMedia = widget.post.mediaUrls.isNotEmpty;
    final hasMood = widget.post.mood != null && widget.post.mood!.isNotEmpty;

    final primaryColor = AppColors.getMonoTextPrimary(isDark);
    final initials = auth.name.isNotEmpty ? auth.name[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.getMonoBorder(isDark).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.05 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= USER ROW =================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
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
                          Text(auth.name, style: AppTextStyles.monoMedium18(isDark).copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
                          if (auth.isAdmin) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "ADMIN",
                                style: TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
                
                // Admin Actions Button
                if (auth.isAdmin) ...[
                  IconButton(
                    icon: Icon(Icons.shield_outlined, color: Colors.amber.shade700, size: 22),
                    onPressed: () => _showModerationSheet(context, provider, isDark),
                    tooltip: "Moderate Post",
                  ),
                ] else ...[
                  Icon(Icons.more_horiz_rounded, color: AppColors.getMonoIcon(isDark).withOpacity(0.4), size: 22),
                ]
              ],
            ),
          ),

          /// ================= MODERATION STATUS (ADMIN ONLY) =================
          if (auth.isAdmin && !widget.post.active) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.remove_moderator_outlined, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Deactivated: ${widget.post.moderationReason ?? 'No reason provided'}",
                      style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Text(
                widget.post.caption,
                style: AppTextStyles.monoRegular16(isDark).copyWith(height: 1.6, fontSize: 15),
              ),
            ),

          /// ================= ACTION ROW =================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
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
