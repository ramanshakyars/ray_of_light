import 'package:rayoflite/presentation/screens/social-insights/models/author.dart';

class Post {
  final String id;
  final String caption;
  final List<String> mediaUrls;
  final DateTime createdAt;
  final Author author;
  int likeCount;
  final int commentCount;
  final int shareCount;

  bool liked; // UI only

  Post({
    required this.id,
    required this.caption,
    required this.mediaUrls,
    required this.createdAt,
    required this.author,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.liked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
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

    return Post(
      id: json['id'] ?? '',
      caption: json['caption'] ?? '',
      mediaUrls: (json['mediaUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: parsedDate,
      author: Author.fromJson(json['author']),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
    );
  }
}
