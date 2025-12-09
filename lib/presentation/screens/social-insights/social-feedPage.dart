import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/UserMood.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/mood-managment.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';

class SocialFeedPage extends StatefulWidget {
  const SocialFeedPage({super.key});

  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage> {
  List<Post> _posts = [];
  String loggedInUserRole = '';

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inHours < 1) return "${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  Future<void> _loadInitialPosts() async {
    final loggedInUser = await LocalStorageService.getUser();
    loggedInUserRole = loggedInUser?['roles'] ?? '';

    try {
      final response = await SocialService.getPostInsights();

      if (response['success'] == true) {
        setState(() {
          _posts =
              (response['data'] as List).map((e) => Post.fromJson(e)).toList();
        });
      }
    } catch (e) {
      MessageService.showError(context, "Error fetching posts");
    }
  }

  void _toggleLike(Post post) {
    setState(() {
      post.liked = !post.liked;
      post.likeCount + (post.liked ? 1 : -1);
    });
  }

  Future<void> _openMoodDialog() async {
    final updatedMood = await showDialog<UserMood?>(
      context: context,
      builder: (context) => const MoodDropdownDialog(),
      barrierDismissible: false,
    );

    if (updatedMood != null && mounted) {
      MessageService.showSuccess(
        context,
        'Mood updated to ${updatedMood.type.name}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ray Of Light'),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset('assets/logo.png'),
          onPressed: () {
            GoRouter.of(
              context,
            ).push('${RouteNames.mainApp}/${RouteNames.profile}');
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.mood), onPressed: _openMoodDialog),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitialPosts,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                PostCard(
                  post: _posts[index],
                  onLike: () => _toggleLike(_posts[index]),
                  isDarkMode: isDark,
                  timeText: timeAgo(_posts[index].createdAt),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final bool isDarkMode;
  final String timeText;

  const PostCard({
    Key? key,
    required this.post,
    this.onLike,
    required this.isDarkMode,
    required this.timeText,
  }) : super(key: key);

  Widget _buildAvatar(String name) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '';
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.getTalkToLiteButtonBackgroundColor(isDarkMode),
      child: Text(
        initials,
        style: AppTextStyles.bold22(isDarkMode).copyWith(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = AppColors.getFormsCardColor(isDarkMode);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorder(isDarkMode)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---- Header ----
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildAvatar(post.author.username),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.username,
                      style: AppTextStyles.medium18(isDarkMode),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeText,
                      style: AppTextStyles.regular14(isDarkMode).copyWith(
                        color: AppColors.getTextPrimaryColor(
                          isDarkMode,
                        ).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ---- Caption ----
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                post.caption,
                style: AppTextStyles.regular16(isDarkMode),
              ),
            ),
          const SizedBox(height: 10),

          /// ---- Image ----
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                height: 260,
                width: double.infinity,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),

          /// ---- Actions ----
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.liked ? Icons.favorite : Icons.favorite_border,
                    color: post.liked ? Colors.red : Colors.grey,
                  ),
                  onPressed: onLike,
                ),
                Text(
                  '${post.likeCount}',
                  style: AppTextStyles.regular14(isDarkMode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
