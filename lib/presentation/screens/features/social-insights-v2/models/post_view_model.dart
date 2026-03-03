class PostViewModel {
  final String id;
  final String caption;
  final List<String> mediaUrls;
  final String? mood; // ✅ NEW
  final DateTime createdAt;
  final String username;

  int likeCount;
  int commentCount;
  int shareCount;

  bool liked;
  bool likeLoading;

  PostViewModel({
    required this.id,
    required this.caption,
    required this.mediaUrls,
    this.mood,
    required this.createdAt,
    required this.username,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.liked = false,
    this.likeLoading = false,
  });

  bool get hasText => caption.trim().isNotEmpty;
  bool get hasMedia => mediaUrls.isNotEmpty;
  bool get hasMood => mood != null && mood!.isNotEmpty;
}