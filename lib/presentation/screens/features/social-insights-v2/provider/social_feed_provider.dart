import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';
import '../models/post_view_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum FeedState { initial, loading, loaded, empty, error, noInternet }

class PostModelV2 {
  final String id;
  final String caption;
  final String? imageUrl;
  final List<String>? mediaUrls; // new field for multiple media
  final DateTime createdAt;
  final Author author;
  int likeCount;
  final int commentCount;
  final int shareCount;

  bool liked; // UI only

  PostModelV2({
    required this.id,
    required this.caption,
    this.imageUrl,
    this.mediaUrls,
    required this.createdAt,
    required this.author,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.liked = false,
  });

  factory PostModelV2.fromJson(Map<String, dynamic> json) {
    final createdList = json['createdAt'] as List?;
    DateTime parsedDate = DateTime.now();
    if (createdList != null && createdList.length >= 6) {
      parsedDate = DateTime(
        createdList[0],
        createdList[1],
        createdList[2],
        createdList[3],
        createdList[4],
        createdList[5],
      );
    }

    return PostModelV2(
      id: json['id'] ?? '',
      caption: json['caption'] ?? '',
      mediaUrls:
          (json['mediaUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: parsedDate,
      author: Author.fromJson(json['author']),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
    );
  }
}

class SocialFeedProvider extends ChangeNotifier {
  FeedState state = FeedState.initial;

  List<PostViewModel> posts = [];
  String? errorMessage;
  SocialFeedProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        state = FeedState.noInternet;
        notifyListeners();
      }
    });
  }

  // ================= LOAD POSTS =================

  Future<void> loadPosts() async {
    try {
      state = FeedState.loading;
      notifyListeners();

      // ✅ STEP 1: CHECK INTERNET FIRST
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        state = FeedState.noInternet;
        notifyListeners();
        return;
      }

      // ✅ STEP 2: API CALL
      final res = await SocialService.getPostInsightsV2();

      posts = res.map(_mapToVM).toList();

      if (posts.isEmpty) {
        state = FeedState.empty;
      } else {
        state = FeedState.loaded;
      }
    } on DioException catch (e) {
      print("DIO ERROR => ${e.type}");

      // ✅ THIS IS THE REAL FIX
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        state = FeedState.noInternet;
      } else {
        state = FeedState.error;
      }
    } catch (e) {
      print("GENERIC ERROR => $e");
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

  PostViewModel _mapToVM(PostModelV2 p) {
    return PostViewModel(
      id: p.id,
      caption: p.caption,
      mediaUrls: p.mediaUrls ?? [],
      createdAt: p.createdAt,
      username: p.author.username,
      likeCount: p.likeCount,
      commentCount: p.commentCount,
      shareCount: p.shareCount,
    );
  }
}
