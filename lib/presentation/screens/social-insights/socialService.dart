import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
import 'package:rayoflite/presentation/screens/social-insights/models/comment_model.dart';

class SocialService {
  /// GET ALL POSTS
  static Future<List<Post>> getPostInsights() async {
    try {
      final res = await HttpService.get(PathConfig.getAllPosts);
      if (res is List) {
        return res.map((e) => Post.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// CREATE POST
  /// Note: key is 'file' to match Spring Boot @RequestPart("file")
 static Future<void> createPost({
  required String caption,
  required List<File> images,
}) async {
  final formData = FormData.fromMap({
    'caption': caption,
    'files': [
      for (final img in images)
        await MultipartFile.fromFile(img.path, filename: img.path.split('/').last),
    ],
  });

  await HttpService.postMultipart(PathConfig.postInsight, formData);
}

  /// LIKE POST
 static Future<void> likePost(String postId, String userId) async {
  try {
    await HttpService.post(PathConfig.doLikeOnPost, {
      'postId': postId,
      'userId': userId,
    });
  } catch (e, st) {
    // Print full error & stack to console to see server response body / status
    print('SocialService.likePost error: $e\n$st');
    rethrow;
  }
}

  /// COMMENT ON POST
  static Future<Comment> commentOnPost({required String postId, required String text}) async {
    final response = await HttpService.post(PathConfig.doCommentOnPost, {
      'postId': postId,
      'text': text,
    });
    return Comment.fromJson(response);
  }

  /// GET COMMENTS
  static Future<List<Comment>> getComments(String postId) async {
    final res = await HttpService.get('${PathConfig.getCommentsByPostId}/$postId');
    if (res is List) {
      return res.map((e) => Comment.fromJson(e)).toList();
    }
    return [];
  }
}