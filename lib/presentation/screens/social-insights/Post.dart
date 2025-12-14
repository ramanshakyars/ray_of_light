class Author {
  final String id;
  final String username;

  Author({
    required this.id,
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class Post {
  final String id;
  final String caption;
  final String? imageUrl;
  final DateTime createdAt;
  final Author author;
  int likeCount;
  final int commentCount;
  final int shareCount;

  bool liked; // UI only

  Post({
    required this.id,
    required this.caption,
    this.imageUrl,
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
      imageUrl: json['imageUrl'],
      createdAt: parsedDate,
      author: Author.fromJson(json['author']),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
    );
  }
}
