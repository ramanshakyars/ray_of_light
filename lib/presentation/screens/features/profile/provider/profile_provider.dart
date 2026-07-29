import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/features/profile/post_model.dart';
import 'package:rayoflite/presentation/screens/features/profile/repository/profile_repository.dart';
import 'package:rayoflite/presentation/screens/features/profile/thought_model.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  bool isLoadingThoughts = false;
  bool isLoadingPosts = false;
  bool isUploadingPhoto = false;

  String? photoUploadError;
  String? thoughtsError;
  String? postsError;

  List<ThoughtModel> thoughts = [];
  List<PostModel> posts = [];

  // ✅ Thoughts API
  Future<void> fetchThoughts() async {
    isLoadingThoughts = true;
    thoughtsError = null;
    notifyListeners();

    try {
      thoughts = await _repo.getThoughts();
    } catch (e) {
      thoughtsError = 'Could not load thoughts.';
      debugPrint('Thoughts error: $e');
    } finally {
      isLoadingThoughts = false;
      notifyListeners();
    }
  }

  // ✅ Posts API
  Future<void> fetchPosts() async {
    isLoadingPosts = true;
    postsError = null;
    notifyListeners();

    try {
      posts = await _repo.getPosts();
    } catch (e) {
      postsError = 'Could not load posts.';
      debugPrint('Posts error: $e');
    } finally {
      isLoadingPosts = false;
      notifyListeners();
    }
  }

  // ✅ Profile Photo Upload
  /// Returns the new photo URL on success, null on failure.
  Future<String?> uploadProfilePhoto(File imageFile) async {
    isUploadingPhoto = true;
    photoUploadError = null;
    notifyListeners();

    try {
      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final res = await HttpService.postMultipart(
        PathConfig.uploadProfilePhoto,
        formData,
      );

      // Backend returns UserDTO which has profilePhotoUrl
      final url = res['profilePhotoUrl'] as String?;
      return url;
    } catch (e) {
      photoUploadError = 'Could not upload photo. Please try again.';
      debugPrint('Photo upload error: $e');
      return null;
    } finally {
      isUploadingPhoto = false;
      notifyListeners();
    }
  }

  // Legacy method aliases kept for backward compat
  Future<void> loadThoughts() => fetchThoughts();
  Future<void> loadPosts() => fetchPosts();
}