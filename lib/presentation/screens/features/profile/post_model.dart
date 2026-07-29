class PostModel {
  final String id;
  final String caption;
  final String? authorId;
  final String? authorName;
  final List<String> mediaUrls;
  final int likeCount;
  final int commentCount;
  final DateTime? createdAt;

  PostModel({
    required this.id,
    required this.caption,
    this.authorId,
    this.authorName,
    required this.mediaUrls,
    required this.likeCount,
    required this.commentCount,
    this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final rawMediaUrls = json['mediaUrls'];
    return PostModel(
      id: json['id'] ?? '',
      caption: json['caption'] ?? '',
      authorId: author?['id'],
      authorName: author?['name'] ?? author?['username'],
      mediaUrls: rawMediaUrls != null
          ? List<String>.from(rawMediaUrls)
          : [],
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
