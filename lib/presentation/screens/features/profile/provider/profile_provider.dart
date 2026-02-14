import 'package:flutter/material.dart';
import 'package:rayoflite/presentation/screens/features/profile/post_model.dart';
import 'package:rayoflite/presentation/screens/features/profile/repository/profile_repository.dart';
import 'package:rayoflite/presentation/screens/features/profile/thought_model.dart';
import 'package:rayoflite/presentation/screens/social-insights/Post.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  bool isLoadingThoughts = false;
  bool isLoadingPosts = false;

  List<ThoughtModel> thoughts = [];
  List<PostModel> posts = [];

  // ✅ Thoughts API
  Future<void> loadThoughts() async {
    try {
      isLoadingThoughts = true;
      notifyListeners();

      thoughts = await _repo.getThoughts();
    } catch (e) {
      debugPrint("Thoughts error: $e");
    } finally {
      isLoadingThoughts = false;
      notifyListeners();
    }
  }

  // ✅ Posts API
  Future<void> loadPosts() async {
    try {
      isLoadingPosts = true;
      notifyListeners();

      posts = await _repo.getPosts();
    } catch (e) {
      debugPrint("Posts error: $e");
    } finally {
      isLoadingPosts = false;
      notifyListeners();
    }
  }
}