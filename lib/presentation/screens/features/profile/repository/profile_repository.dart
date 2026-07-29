import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/features/profile/post_model.dart';
import 'package:rayoflite/presentation/screens/features/profile/thought_model.dart';

class ProfileRepository {
  /// Fetches the logged-in user's journal/thought entries.
  Future<List<ThoughtModel>> getThoughts() async {
    final res = await HttpService.get(PathConfig.getJournals);
    final data = res is List ? res : (res['data'] as List? ?? []);
    return data.map((e) => ThoughtModel.fromJson(e)).toList();
  }

  /// Fetches only the posts created by the logged-in user.
  Future<List<PostModel>> getPosts() async {
    final res = await HttpService.get(PathConfig.getMyPosts);
    final data = res is List ? res : (res['data'] as List? ?? []);
    return data.map((e) => PostModel.fromJson(e)).toList();
  }
}
