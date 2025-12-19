import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/UserMood.dart';
import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/mood-managment.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
import 'package:rayoflite/presentation/screens/social-insights/comment_bottom_sheet.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';

class SocialFeedPage extends StatefulWidget {
  const SocialFeedPage({super.key});

  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage> {
  final TextEditingController _createController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<Post> _posts = [];
  String loggedInUserRole = '';
  String loggedInUserName = '';
  File? _selectedImage;
  

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  // ---------------- TIME AGO ----------------
  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inHours < 1) return "${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  // ---------------- IMAGE PICKER ----------------
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // ---------------- CREATE POST CARD ----------------
  Widget _buildCreatePostCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getFormsCardColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorder(isDark)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _createController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Write something...',
              border: InputBorder.none,
            ),
          ),

          if (_selectedImage != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImage!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],

          const SizedBox(height: 8),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _onCreatePost,
                child: const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- LOAD POSTS ----------------
  Future<void> _loadInitialPosts() async {
    final loggedInUser = await LocalStorageService.getUser();
    loggedInUserRole = loggedInUser?['roles'] ?? '';
    loggedInUserName = loggedInUser?['name'] ?? '';
    print('Logged in user role: $loggedInUser');

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

  // ---------------- LIKE ----------------
  void _toggleLike(Post post) {
    setState(() {
      post.liked = !post.liked;
      post.likeCount += post.liked ? 1 : -1;
    });
  }

  // ---------------- CREATE POST ----------------
  Future<void> _onCreatePost() async {
    if (loggedInUserRole != 'ROLE_ADMIN') return;

    if (_selectedImage == null && _createController.text.trim().isEmpty) {
      MessageService.showError(context, 'Add image or caption');
      return;
    }

    try {
      await SocialService.createPost(
        caption: _createController.text.trim(),
        imageFile: _selectedImage,
      );

      _createController.clear();
      _selectedImage = null;

      await _loadInitialPosts();
      MessageService.showSuccess(context, 'Post created');
    } catch (e) {
      MessageService.showError(context, 'Failed to create post');
    }
  }

  // ---------------- MOOD ----------------
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

  // ---------------- UI ----------------
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
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (loggedInUserRole == 'ROLE_ADMIN') ...[
              _buildCreatePostCard(isDark),
              const SizedBox(height: 16),
            ],

            ..._posts.map((post) {
              return Column(
                children: [
                  PostCard(
                    post: post,
                    onLike: () => _toggleLike(post),
                    isDarkMode: isDark,
                    timeText: timeAgo(post.createdAt),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// POST CARD
// ===================================================================
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final bool isDarkMode;
  final String timeText;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    required this.isDarkMode,
    required this.timeText,
  });

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
                      // loggedInUserName,
                      style: AppTextStyles.medium18(isDarkMode),
                    ),
                    Text(
                      timeText,
                      style: AppTextStyles.regular14(
                        isDarkMode,
                      ).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                post.caption,
                style: AppTextStyles.regular16(isDarkMode),
              ),
            ),

          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (_, __) => Image.asset('assets/talk-to-light.png'),
                  errorWidget:
                      (_, __, ___) => Image.asset('assets/talk-to-light.png'),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                /// LIKE
                IconButton(
                  icon: Icon(
                    post.liked ? Icons.favorite : Icons.favorite_border,
                    color: post.liked ? Colors.red : Colors.grey,
                  ),
                  onPressed: onLike,
                ),
                Text('${post.likeCount}'),

                const SizedBox(width: 12),

                /// COMMENT
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentBottomSheet(post: post),
                    );
                  },
                ),

                // Text('${post.commentCount}'),

                /// PUSH SHARE ICON TO END
                const Spacer(),

                /// SHARE (ICON ONLY)
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: Colors.grey),
                  onPressed: () {}, //onShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
