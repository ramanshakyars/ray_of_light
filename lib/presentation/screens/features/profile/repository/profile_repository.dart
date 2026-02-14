

import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/presentation/screens/features/profile/post_model.dart';
import 'package:rayoflite/presentation/screens/features/profile/thought_model.dart';


class ProfileRepository {
  Future<List<ThoughtModel>> getThoughts() async {
    final res = await HttpService.get(PathConfig.getJournals);

    return (res['data'] as List)
        .map((e) => ThoughtModel.fromJson(e))
        .toList();
  }

  Future<List<PostModel>> getPosts() async {
    final res = await HttpService.get(PathConfig.getAllPosts);

    return (res['data'] as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }
}
