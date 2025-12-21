// ignore: file_names
class Post {
  final String id;
  final String authorName;
  final String avatarUrl;
  final String tag;
  final String timeAgo;
  final String imageUrl;
  bool liked;
  int likesCount;

  Post({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.tag,
    required this.timeAgo,
    required this.imageUrl,
    this.liked = false,
    this.likesCount = 0,
  });
}