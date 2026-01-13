class AppNotification {
  final String id;
  final String title;
  final String message;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['status'] == 'READ',
    );
  }
}
