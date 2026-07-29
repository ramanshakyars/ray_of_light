class ThoughtModel {
  final String id;
  final String content;
  final String createdAt;
  final String? type; // JournalType from backend (e.g. REFLECTION, GRATITUDE)

  ThoughtModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.type,
  });

  factory ThoughtModel.fromJson(Map<String, dynamic> json) {
    return ThoughtModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      type: json['type'],
    );
  }
}
