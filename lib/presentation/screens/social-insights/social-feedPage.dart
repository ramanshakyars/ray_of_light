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
  bool _isPosting = false;
  bool _isLoading = false;

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
  Future<void> _pickImage(
    ImageSource source,
    void Function(void Function()) setModalState,
  ) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setModalState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // ---------------- CREATE POST CARD ----------------
  Widget _buildCreatePostCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCard(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.getPrimary(isDark),
                child: Text(
                  loggedInUserName.isNotEmpty
                      ? loggedInUserName[0].toUpperCase()
                      : 'U',
                  style: AppTextStyles.bold22(isDark).copyWith(
                    fontSize: 14,
                    color: AppColors.getPrimaryForeground(isDark),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showCreatePostModal(isDark);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.getInputBackground(isDark),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.getBorder(isDark),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      "What's on your mind?",
                      style: AppTextStyles.regular16(
                        isDark,
                      ).copyWith(color: AppColors.getMutedForeground(isDark)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // _buildCreateAction(
              //   icon: Icons.photo_library_outlined,
              //   label: 'Photo',
              //   color: Colors.green,
              //   isDark: isDark,
              //   onTap: () => _pickImage(ImageSource.gallery),
              // ),
              // _buildCreateAction(
              //   icon: Icons.videocam_outlined,
              //   label: 'Video',
              //   color: Colors.purple,
              //   isDark: isDark,
              //   onTap: () {},
              // ),
              // _buildCreateAction(
              //   icon: Icons.mood_outlined,
              //   label: 'Feeling',
              //   color: Colors.orange,
              //   isDark: isDark,
              //   onTap: _openMoodDialog,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAction({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.getAccent(isDark),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.regular14(
                isDark,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CREATE POST MODAL ----------------
  void _showCreatePostModal(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: AppColors.getCard(isDark),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.getBorder(isDark),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Post',
                          style: AppTextStyles.bold22(isDark),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: AppColors.getMutedForeground(isDark),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // User info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.getPrimary(isDark),
                          child: Text(
                            loggedInUserName.isNotEmpty
                                ? loggedInUserName[0].toUpperCase()
                                : 'U',
                            style: AppTextStyles.bold22(isDark).copyWith(
                              fontSize: 14,
                              color: AppColors.getPrimaryForeground(isDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loggedInUserName,
                              style: AppTextStyles.medium18(isDark),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.getAccent(isDark),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    size: 14,
                                    color: AppColors.getMutedForeground(isDark),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Public',
                                    style: AppTextStyles.regular14(
                                      isDark,
                                    ).copyWith(
                                      color: AppColors.getMutedForeground(
                                        isDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _createController,
                              maxLines: null,
                              style: AppTextStyles.regular16(isDark),
                              decoration: InputDecoration(
                                hintText: "What's on your mind?",
                                hintStyle: AppTextStyles.regular16(
                                  isDark,
                                ).copyWith(
                                  color: AppColors.getMutedForeground(isDark),
                                ),
                                border: InputBorder.none,
                              ),
                            ),

                            if (_selectedImage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _selectedImage!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            _selectedImage = null;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.getBorder(isDark),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.getAccent(isDark),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add to your post',
                                style: AppTextStyles.regular16(isDark),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.photo_library_outlined,
                                      color: AppColors.getMutedForeground(
                                        isDark,
                                      ),
                                    ),
                                    onPressed:
                                        () => _pickImage(
                                          ImageSource.gallery,
                                          setModalState,
                                        ),
                                  ),
                                  // IconButton(
                                  //   icon: Icon(
                                  //     Icons.tag,
                                  //     color: AppColors.getMutedForeground(isDark),
                                  //   ),
                                  //   onPressed: () {},
                                  // ),
                                  // IconButton(
                                  //   icon: Icon(
                                  //     Icons.mood_outlined,
                                  //     color: AppColors.getMutedForeground(isDark),
                                  //   ),
                                  //   onPressed: _openMoodDialog,
                                  // ),
                                  // IconButton(
                                  //   icon: Icon(
                                  //     Icons.more_horiz,
                                  //     color: AppColors.getMutedForeground(isDark),
                                  //   ),
                                  //   onPressed: () {},
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isPosting ? null : _onCreatePost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.getPrimary(isDark),
                              foregroundColor: AppColors.getPrimaryForeground(
                                isDark,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child:
                                _isPosting
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      'Post',
                                      style: AppTextStyles.button16(isDark),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- LOAD POSTS ----------------
  Future<void> _loadInitialPosts() async {
    setState(() => _isLoading = true);

    final loggedInUser = await LocalStorageService.getUser();
    setState(() {
      loggedInUserRole = loggedInUser?['roles'] ?? '';
      loggedInUserName = loggedInUser?['name'] ?? '';
    });

    try {
      final posts = await SocialService.getPostInsights();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) MessageService.showError(context, "Error fetching posts");
    }
  }

  Future<void> _handleLike(Post post) async {
    final user = await LocalStorageService.getUser();
    final String userId = user?['id'] ?? user?['_id'] ?? user?['userId'] ?? '';
    if (userId.isEmpty) {
      MessageService.showError(
        context,
        "User session expired. Please re-login.",
      );
      return;
    }
    setState(() {
      post.liked = !post.liked;
      post.likeCount += post.liked ? 1 : -1;
    });

    try {
      await SocialService.likePost(post.id, userId);
    } catch (e) {
      setState(() {
        post.liked = !post.liked;
        post.likeCount += post.liked ? 1 : -1;
      });
      MessageService.showError(context, "Failed to update like");
    }
  }

  // ---------------- CREATE POST ----------------
  Future<void> _onCreatePost() async {
    if (loggedInUserRole != 'ROLE_ADMIN') {
      MessageService.showError(context, "Only admin can create posts");
      return;
    }

    if (_selectedImage == null && _createController.text.trim().isEmpty) {
      MessageService.showError(context, "Please add text or image");
      return;
    }

    setState(() => _isPosting = true);

    try {
      await SocialService.createPost(
        caption: _createController.text.trim(),
        imageFile: _selectedImage,
      );
      _createController.clear();
      setState(() {
        _selectedImage = null;
        _isPosting = false;
      });
      Navigator.pop(context); // Close modal
      _loadInitialPosts();
      MessageService.showSuccess(context, 'Post created successfully');
    } catch (e) {
      setState(() => _isPosting = false);
      MessageService.showError(context, 'Post creation failed');
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
      backgroundColor: AppColors.getBackground(isDark),
      appBar: AppBar(
        title: Text('Ray Of Light', style: AppTextStyles.bold22(isDark)),
        centerTitle: true,
        leading: IconButton(
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.getPrimary(isDark),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset('assets/logo.png'),
            ),
          ),
          onPressed: () {
            GoRouter.of(
              context,
            ).push('${RouteNames.mainApp}/${RouteNames.profile}');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mood, color: AppColors.getPrimary(isDark)),
            onPressed: _openMoodDialog,
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.getPrimary(isDark),
            ),
            onPressed: () {
              context.push(
                '${RouteNames.mainApp}/${RouteNames.notification}',
                // todo : pass id here
                extra: '32', // 🔥 pass logged-in userId
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: AppColors.getCard(isDark),
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitialPosts,
        color: AppColors.getPrimary(isDark),
        backgroundColor: AppColors.getCard(isDark),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (loggedInUserRole == 'ROLE_ADMIN') ...[
              _buildCreatePostCard(isDark),
              const SizedBox(height: 16),
            ],

            // Stories/Highlights Section (optional)
            // _buildStoriesSection(isDark),
            const SizedBox(height: 16),

            // Loading indicator
            if (_isLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: AppColors.getPrimary(isDark),
                  ),
                ),
              ),

            // Posts
            if (!_isLoading && _posts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.post_add,
                        size: 60,
                        color: AppColors.getMutedForeground(isDark),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: AppTextStyles.medium18(isDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to create a post!',
                        style: AppTextStyles.regular14(
                          isDark,
                        ).copyWith(color: AppColors.getMutedForeground(isDark)),
                      ),
                    ],
                  ),
                ),
              ),

            // Posts list
            ..._posts.map((post) {
              return Column(
                children: [
                  PostCard(
                    post: post,
                    onLike: () => _handleLike(post),
                    isDarkMode: isDark,
                    timeText: timeAgo(post.createdAt),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesSection(bool isDark) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.getCard(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Stories', style: AppTextStyles.medium18(isDark)),
                Text(
                  'See all',
                  style: AppTextStyles.regular14(
                    isDark,
                  ).copyWith(color: AppColors.getPrimary(isDark)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/talk-to-light.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'User ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// POST CARD (ENHANCED)
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
      radius: 22,
      backgroundColor: AppColors.getPrimary(isDarkMode),
      child: Text(
        initials,
        style: AppTextStyles.bold22(isDarkMode).copyWith(
          fontSize: 16,
          color: AppColors.getPrimaryForeground(isDarkMode),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    Color? activeColor,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 20,
                  color:
                      isActive
                          ? activeColor
                          : AppColors.getMutedForeground(isDarkMode),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.regular14(isDarkMode).copyWith(
                    color:
                        isActive
                            ? activeColor
                            : AppColors.getMutedForeground(isDarkMode),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = AppColors.getCard(isDarkMode);
    final likeColor = Colors.red;
    final commentColor = Colors.blue;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAvatar(post.author.username),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.author.username,
                            style: AppTextStyles.medium18(isDarkMode),
                          ),
                          if (post.author.username == "Admin")
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.getPrimary(isDarkMode),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Verified',
                                style: AppTextStyles.regular14(
                                  isDarkMode,
                                ).copyWith(
                                  fontSize: 10,
                                  color: AppColors.getPrimaryForeground(
                                    isDarkMode,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            timeText,
                            style: AppTextStyles.regular14(isDarkMode).copyWith(
                              color: AppColors.getMutedForeground(isDarkMode),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.public,
                            size: 12,
                            color: AppColors.getMutedForeground(isDarkMode),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppColors.getMutedForeground(isDarkMode),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post.caption,
                style: AppTextStyles.regular16(isDarkMode),
              ),
            ),

          // Image
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GestureDetector(
                onDoubleTap: onLike,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: post.imageUrl!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => Container(
                              height: 300,
                              color: AppColors.getMuted(isDarkMode),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (_, __, ___) => Container(
                              height: 300,
                              color: AppColors.getMuted(isDarkMode),
                              child: const Icon(Icons.broken_image),
                            ),
                      ),
                      Positioned.fill(
                        child: AnimatedOpacity(
                          opacity: 0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                            child: const Center(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: likeColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post.likeCount}',
                      style: AppTextStyles.regular14(isDarkMode).copyWith(
                        color: AppColors.getMutedForeground(isDarkMode),
                      ),
                    ),
                  ],
                ),
                if (post.commentCount > 0)
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => CommentBottomSheet(post: post),
                      );
                    },
                    child: Text(
                      '${post.commentCount} comments',
                      style: AppTextStyles.regular14(isDarkMode).copyWith(
                        color: AppColors.getMutedForeground(isDarkMode),
                      ),
                    ),
                  ),
                if (post.shareCount > 0)
                  Text(
                    '${post.shareCount} shares',
                    style: AppTextStyles.regular14(
                      isDarkMode,
                    ).copyWith(color: AppColors.getMutedForeground(isDarkMode)),
                  ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.getBorder(isDarkMode),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  activeIcon: Icons.favorite,
                  label: 'Like',
                  isActive: post.liked,
                  onTap: onLike ?? () {},
                  activeColor: likeColor,
                ),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Comment',
                  isActive: false,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentBottomSheet(post: post),
                    );
                  },
                  activeColor: commentColor,
                ),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  activeIcon: Icons.share,
                  label: 'Share',
                  isActive: false,
                  onTap: () {},
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
