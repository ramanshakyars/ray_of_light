import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';
import '../models/post_view_model.dart';

enum FeedState { initial, loading, loaded, empty, error, noInternet }

class SocialFeedProvider extends ChangeNotifier {
  FeedState state = FeedState.initial;

  List<PostViewModel> posts = [];
  String? errorMessage;

  // ================= LOAD POSTS =================

  Future<void> loadPosts() async {
    try {
      state = FeedState.loading;
      notifyListeners();

      final res = await SocialService.getPostInsights();

      posts = res.map(_mapToVM).toList();

      if (posts.isEmpty) {
        state = FeedState.empty;
      } else {
        state = FeedState.loaded;
      }
    } on SocketException {
      state = FeedState.noInternet;
    } catch (e) {
      errorMessage = e.toString();
      state = FeedState.error;
    }

    notifyListeners();
  }

  // ================= LIKE =================

  Future<void> toggleLike(PostViewModel post) async {
    if (post.likeLoading) return;

    post.likeLoading = true;
    notifyListeners();

    final previousLiked = post.liked;
    final previousCount = post.likeCount;

    // optimistic update
    post.liked = !post.liked;
    post.likeCount += post.liked ? 1 : -1;
    if (post.likeCount < 0) post.likeCount = 0;

    notifyListeners();

    try {
      await SocialService.likePost(post.id, ""); // userId handled in service
    } catch (_) {
      // rollback
      post.liked = previousLiked;
      post.likeCount = previousCount;
    }

    post.likeLoading = false;
    notifyListeners();
  }

  // ================= MAPPER =================

  PostViewModel _mapToVM(Post p) {
    return PostViewModel(
      id: p.id,
      caption: p.caption,
      mediaUrls: p.imageUrl != null ? [p.imageUrl!] : [],
      createdAt: p.createdAt,
      username: p.author.username,
      likeCount: p.likeCount,
      commentCount: p.commentCount,
      shareCount: p.shareCount,
    );
  }
}