import 'package:flutter/material.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
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
      setState(() {
        _comments = comments;
        _loading = false;
      });
    } catch (e) {
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _comments.isEmpty
              ? const Center(child: Text('No comments yet'))
              : ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    return CommentTile(
                      comment: _comments[index],
                      isDark: isDark,
                    );
                  },
                ),
    );
  }
}
