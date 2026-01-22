import 'package:flutter/material.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
import 'package:rayoflite/presentation/screens/social-insights/models/author.dart';
import 'package:rayoflite/presentation/screens/social-insights/models/comment_model.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';
import 'package:rayoflite/presentation/screens/social-insights/widgets/comment_tile.dart';

class CommentBottomSheet extends StatefulWidget {
  final Post post;

  const CommentBottomSheet({super.key, required this.post});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<Comment> _comments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final comments = await SocialService.getComments(widget.post.id);
      if (mounted) {
        setState(() {
          _comments = comments;
          _loading = false;
        });
      }
    } catch (e) {
      print("Error parsing comments: $e");
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Parsing Error: Check data format")),
        );
      }
    }
  }

  Future<void> _postComment() async {
    if (_controller.text.trim().isEmpty) return;
    
    final text = _controller.text.trim();
    _controller.clear();
    
    // Add temporary comment
    final tempComment = Comment(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      createdAt: DateTime.now(),
      postId: widget.post.id,
      author: Author(
        id: 'temp',
        username: 'You', // This should be actual username from local storage
      ),
    );
    
    setState(() {
      _comments.insert(0, tempComment);
    });

    try {
      final newComment = await SocialService.commentOnPost(
        postId: widget.post.id,
        text: text,
      );
      
      // Replace temp comment with actual one
      setState(() {
        _comments.removeAt(0);
        _comments.insert(0, newComment);
      });
    } catch (e) {
      // Remove temp comment on error
      setState(() {
        _comments.removeAt(0);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to post comment")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.getCard(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
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
                  'Comments',
                  style: AppTextStyles.bold22(isDark),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.getMutedForeground(isDark),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Comments count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: AppColors.getMutedForeground(isDark),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_comments.length} comments',
                  style: AppTextStyles.regular14(isDark).copyWith(
                    color: AppColors.getMutedForeground(isDark),
                  ),
                ),
              ],
            ),
          ),
          
          // Comments list
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _comments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 60,
                              color: AppColors.getMutedForeground(isDark),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No comments yet',
                              style: AppTextStyles.regular16(isDark),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to comment!',
                              style: AppTextStyles.regular14(isDark).copyWith(
                                color: AppColors.getMutedForeground(isDark),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) => CommentTile(
                          comment: _comments[index],
                          isDark: isDark,
                        ),
                      ),
          ),
          
          // Input area
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
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.getPrimary(isDark),
                  child: Text(
                    'Y', // Should be user's first letter
                    style: AppTextStyles.bold22(isDark).copyWith(
                      fontSize: 12,
                      color: AppColors.getPrimaryForeground(isDark),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                
                // Text field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.getInputBackground(isDark),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        border: InputBorder.none,
                        hintStyle: AppTextStyles.regular14(isDark).copyWith(
                          color: AppColors.getMutedForeground(isDark),
                        ),
                      ),
                      onSubmitted: (_) => _postComment(),
                    ),
                  ),
                ),
                
                // Send button
                IconButton(
                  onPressed: _postComment,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.getPrimary(isDark),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color: AppColors.getPrimaryForeground(isDark),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}