class PostViewModel {
  final String id;
  final String caption;
  final List<String> mediaUrls;
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
    required this.createdAt,
    required this.username,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.liked = false,
    this.likeLoading = false,
  });
}