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
    String formattedDate = '';
    final rawDate = json['createdAt'];
    if (rawDate is List && rawDate.length >= 3) {
      formattedDate =
          '${rawDate[0]}-${rawDate[1].toString().padLeft(2, '0')}-${rawDate[2].toString().padLeft(2, '0')}';
    } else if (rawDate != null) {
      formattedDate = rawDate.toString();
    }

    return ThoughtModel(
      id: (json['id'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: formattedDate,
      type: json['type']?.toString(),
    );
  }
}
