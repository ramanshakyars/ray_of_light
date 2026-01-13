import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_controller.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_tile.dart';

class NotificationPage extends StatelessWidget {
  final String userId;
  const NotificationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationController()..load(userId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Notifications")),
        body: Consumer<NotificationController>(
          builder: (_, c, __) {
            if (c.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (c.notifications.isEmpty) {
              return const Center(child: Text("No notifications"));
            }

            return ListView.builder(
              itemCount: c.notifications.length,
              itemBuilder: (_, i) => NotificationTile(c.notifications[i]),
            );
          },
        ),
      ),
    );
  }
}
