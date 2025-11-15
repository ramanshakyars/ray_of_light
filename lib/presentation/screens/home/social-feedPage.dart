import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/UserMood.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/mood-managment.dart';

// Simple Post model (expand as needed)
class Post {
  final String id;
  final String authorName;
  final String avatarUrl;
  final String tag;
  final String timeAgo;
  final String imageUrl;
  bool liked;
  int likesCount;

  Post({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.tag,
    required this.timeAgo,
    required this.imageUrl,
    this.liked = false,
    this.likesCount = 0,
  });
}

class SocialFeedPage extends StatefulWidget {
  const SocialFeedPage({Key? key}) : super(key: key);

  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage> {
  final TextEditingController _createController = TextEditingController();
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  Future<void> _loadInitialPosts() async {
    // TODO: Replace this mock with an API call to fetch posts.
    // Example: await apiService.fetchPosts();
    setState(() {
      _posts = [
        Post(
          id: '1',
          authorName: 'Ray of Light',
          avatarUrl: '', // empty will fallback to initials
          tag: 'Daily inspiration',
          timeAgo: 'Just now',
          imageUrl:
              'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=1000&q=80',
          liked: false,
          likesCount: 12,
        ),
        Post(
          id: '2',
          authorName: 'Ray of Light',
          avatarUrl: '', // empty will fallback to initials
          tag: 'Daily inspiration',
          timeAgo: 'Just now',
          imageUrl:
              'https://m.media-amazon.com/images/I/61LjnhXXWIL._AC_UF1000,1000_QL80_.jpg',
          liked: false,
          likesCount: 12,
        ),
      ];
    });
  }

  Future<void> _onCreatePost() async {
    final text = _createController.text.trim();
    if (text.isEmpty) return;

    // TODO: Call your create-post API to persist post.
    // On success, add to list or refresh posts.
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'You',
      avatarUrl: '',
      tag: '',
      timeAgo: 'Just now',
      imageUrl:
          'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=1000&q=80', // placeholder
      likesCount: 0,
    );

    setState(() {
      _posts.insert(0, newPost);
      _createController.clear();
    });
  }

  void _toggleLike(Post post) {
    // TODO: Call like/unlike API as required.
    setState(() {
      post.liked = !post.liked;
      post.likesCount += post.liked ? 1 : -1;
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
    final bg = AppColors.getAppBackgroundColor(isDark);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Ray Of Light'),
        centerTitle: true,
        backgroundColor: AppColors.getAppBackgroundColor(isDark),
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              children: [
                _buildCreatePostRow(isDark),
                const SizedBox(height: 12),
                for (final post in _posts) ...[
                  PostCard(
                    post: post,
                    onLike: () => _toggleLike(post),
                    isDarkMode: isDark,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatePostRow(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getFormsCardColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorder(isDark)),
      ),
      child: Row(
        children: [
          _buildAvatar('You', isDark, radius: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _createController,
              style: AppTextStyles.regular16(isDark),
              decoration: InputDecoration(
                hintText: 'Share your daily reflection...',
                hintStyle: AppTextStyles.regular14(isDark).copyWith(
                  color: AppColors.getTextPrimaryColor(isDark).withOpacity(0.6),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getFormSubmitButtonColor(isDark),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _onCreatePost,
            child: Icon(
              Icons.add,
              color: AppColors.getPrimaryForeground(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, bool isDark, {double radius = 18}) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '';
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.getTalkToLiteButtonBackgroundColor(isDark),
      child: Text(
        initials,
        style: AppTextStyles.bold22(isDark).copyWith(fontSize: radius * 0.9),
      ),
    );
  }
}

// Post card widget
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final bool isDarkMode;

  const PostCard({
    Key? key,
    required this.post,
    this.onLike,
    required this.isDarkMode,
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
    final borderColor = AppColors.getBorder(isDarkMode);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                _buildAvatar(post.authorName),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: AppTextStyles.medium18(isDarkMode),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (post.tag.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.getAccent(
                                  isDarkMode,
                                ).withOpacity(0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                post.tag,
                                style: AppTextStyles.regular14(
                                  isDarkMode,
                                ).copyWith(fontSize: 12),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            post.timeAgo,
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
                PopupMenuButton<int>(
                  itemBuilder:
                      (_) => [
                        const PopupMenuItem(value: 1, child: Text('Share')),
                        const PopupMenuItem(value: 2, child: Text('Report')),
                      ],
                ),
              ],
            ),
          ),

          // Image
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (c, e, s) => Container(
                        color: AppColors.getAccent(isDarkMode),
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: AppColors.getIconColor(isDarkMode),
                          ),
                        ),
                      ),
                ),
              ),
            ),

          // Actions row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.liked ? Icons.favorite : Icons.favorite_border,
                    color:
                        post.liked
                            ? Colors.red
                            : AppColors.getIconColor(isDarkMode),
                  ),
                  onPressed: onLike,
                ),
                Text(
                  '${post.likesCount}',
                  style: AppTextStyles.regular14(isDarkMode),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.getIconColor(isDarkMode),
                  ),
                  onPressed: () {
                    // TODO: Navigate to comments screen or open comments bottom sheet
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                    color: AppColors.getIconColor(isDarkMode),
                  ),
                  onPressed: () {
                    // TODO: bookmark API
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Example main to preview the widget and theme integration.
// Remove or adapt if you already have an App scaffold.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyAppPreview(),
    ),
  );
}

class MyAppPreview extends StatelessWidget {
  const MyAppPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.getAppBackgroundColor(isDark),
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.getCard(isDark),
          iconTheme: IconThemeData(color: AppColors.getIconColor(isDark)),
          elevation: 0,
        ),
      ),
      home: const SocialFeedPage(),
    );
  }
}
