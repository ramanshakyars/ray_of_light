import 'package:flutter/material.dart';
import '../models/post_view_model.dart';
import 'package:provider/provider.dart';
import '../provider/social_feed_provider.dart';

class PostCardV2 extends StatelessWidget {
  final PostViewModel post;

  const PostCardV2({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SocialFeedProvider>();

    return Card(
      child: Column(
        children: [
          Text(post.username),
          Text(post.caption),

          IconButton(
            onPressed: () => provider.toggleLike(post),
            icon: Icon(
              post.liked ? Icons.favorite : Icons.favorite_border,
            ),
          ),
        ],
      ),
    );
  }
}