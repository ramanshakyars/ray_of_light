import 'dart:convert';

/// Notification model matching the backend NotificationResDto.
class AppNotification {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String? type;
  final String? priority;
  final String? deepLink;
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    this.type,
    this.priority,
    this.deepLink,
    this.data,
    this.createdAt,
    this.expiresAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['status'] == 'READ',
      type: json['type'],
      priority: json['priority'],
      deepLink: json['deepLink'],
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
    );
  }
}
