import 'package:rayoflite/presentation/screens/social-insights/Post.dart';

class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final Author author;

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.author,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      author: Author.fromJson(json['author']),
    );
  }
}
