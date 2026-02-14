class PostModel {
  final String id;
  final String content;
  final int likes;

  PostModel({
    required this.id,
    required this.content,
    required this.likes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      likes: json['likes'] ?? 0,
    );
  }
}
