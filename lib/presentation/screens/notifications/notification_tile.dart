import 'package:flutter/material.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification n;

  const NotificationTile(this.n, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(n.title),
      subtitle: Text(n.message),
      trailing: n.isRead ? null : const Icon(Icons.circle, size: 10),
    );
  }
}