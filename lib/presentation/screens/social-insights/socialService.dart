import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/provider/social_feed_provider.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
import 'package:rayoflite/presentation/screens/social-insights/models/comment_model.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/models/post_report_model.dart';

class SocialService {
  /// GET ALL POSTS
  static Future<List<PostModelV2>> getPostInsightsV2() async {
    try {
      final res = await HttpService.get(PathConfig.getAllPosts);
      if (res is List) {
        return res.map((e) => PostModelV2.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
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
    File? imageFile,
  }) async {
    final formData = FormData.fromMap({
      'caption': caption,
      if (imageFile != null)
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
    });
    await HttpService.postMultipart(PathConfig.postInsight, formData);
  }

  static Future<void> createPostV2({
    required String caption,
    required List<File> images,
  }) async {
    final formData = FormData();

    /// caption
    formData.fields.add(MapEntry('caption', caption));

    /// multiple images
    for (final img in images) {
      formData.files.add(
        MapEntry(
          'files', // MUST match Spring @RequestPart("files")
          await MultipartFile.fromFile(
            img.path,
            filename: img.path.split('/').last,
          ),
        ),
      );
    }

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
  static Future<Comment> commentOnPost({
    required String postId,
    required String text,
  }) async {
    final response = await HttpService.post(PathConfig.doCommentOnPost, {
      'postId': postId,
      'text': text,
    });
    return Comment.fromJson(response);
  }

  /// GET COMMENTS
  static Future<List<Comment>> getComments(String postId) async {
    final res = await HttpService.get(
      '${PathConfig.getCommentsByPostId}/$postId',
    );
    if (res is List) {
      return res.map((e) => Comment.fromJson(e)).toList();
    }
    return [];
  }

  /// MODERATE POST (ADMIN ONLY)
  static Future<PostModelV2?> moderatePost({
    required String postId,
    required bool active,
    required String reason,
  }) async {
    try {
      final response = await HttpService.post(PathConfig.moderatePost, {
        'postId': postId,
        'active': active,
        'reason': reason,
      });
      return PostModelV2.fromJson(response);
    } catch (e) {
      print('SocialService.moderatePost error: $e');
      rethrow;
    }
  }

  /// REPORT POST (USER / ADMIN)
  static Future<PostReportResDto> reportPost({
    required String postId,
    required PostReportReason reason,
    String? description,
  }) async {
    try {
      final dto = PostReportReqDto(
        postId: postId,
        reason: reason,
        description: description,
      );
      final response = await HttpService.post(
        PathConfig.reportPost,
        dto.toJson(),
      );
      return PostReportResDto.fromJson(response);
    } catch (e) {
      print('SocialService.reportPost error: $e');
      rethrow;
    }
  }

  /// GET PENDING REPORTS (ADMIN ONLY)
  static Future<PostReportPageResDto> getPendingReports({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await HttpService.get(
        '${PathConfig.getPendingReports}?page=$page&size=$size',
      );
      return PostReportPageResDto.fromJson(response);
    } catch (e) {
      print('SocialService.getPendingReports error: $e');
      rethrow;
    }
  }

  /// REVIEW REPORT (ADMIN ONLY)
  static Future<PostReportResDto> reviewReport({
    required String reportId,
    required PostReportReviewAction action,
    required String adminRemark,
  }) async {
    try {
      final dto = ReviewPostReportReqDto(
        reportId: reportId,
        action: action,
        adminRemark: adminRemark,
      );
      final response = await HttpService.post(
        PathConfig.reviewReport,
        dto.toJson(),
      );
      return PostReportResDto.fromJson(response);
    } catch (e) {
      print('SocialService.reviewReport error: $e');
      rethrow;
    }
  }
}
