class ThoughtModel {
  final String id;
  final String content;
  final String createdAt;

  ThoughtModel({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  factory ThoughtModel.fromJson(Map<String, dynamic> json) {
    return ThoughtModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
