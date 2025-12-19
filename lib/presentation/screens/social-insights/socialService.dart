import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/social-insights/models/comment_model.dart';

class SocialService {

  /// =============================
  /// CREATE POST (Admin only)
  /// =============================
  static Future<Map<String, dynamic>> createPost({
    required String caption,
    File? imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'caption': caption,
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await HttpService.postMultipart(
        PathConfig.postInsight,
        formData,
      );

      return {
        'success': true,
        'data': response,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create post: $e',
      };
    }
  }

  /// =============================
  /// GET ALL POSTS
  /// =============================
  static Future<Map<String, dynamic>> getPostInsights() async {
    try {
      final raw = await HttpService.get(PathConfig.getAllPosts);

      if (raw is List) {
        return {'success': true, 'data': raw};
      }

      return {
        'success': false,
        'message': 'Unexpected response format',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching posts: $e',
      };
    }
  }

  /// =============================
  /// LIKE / UNLIKE POST
  /// =============================
  static Future<Map<String, dynamic>> likePost(String postId) async {
    try {
      final response = await HttpService.post(
        PathConfig.doLikeOnPost,
        {'postId': postId},
      );

      return {'success': true, 'data': response};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to like post: $e',
      };
    }
  }

  /// =============================
  /// COMMENT ON POST
  /// =============================
  static Future<Map<String, dynamic>> commentOnPost({
    required String postId,
    required String comment,
  }) async {
    try {
      final response = await HttpService.post(
        PathConfig.doCommentOnPost,
        {
          'postId': postId,
          'comment': comment,
        },
      );

      return {'success': true, 'data': response};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to comment: $e',
      };
    }
  }

  /// =============================
  /// GET COMMENTS BY POST ID
  /// =============================
 static Future<List<Comment>> getComments(String postId) async {
  final res = await HttpService.get(
    '${PathConfig.getCommentsByPostId}/$postId',
  );

  if (res is List) {
    return res.map((e) => Comment.fromJson(e)).toList();
  }
  return [];
}

}
