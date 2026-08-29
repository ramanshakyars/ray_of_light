import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_controller.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_tile.dart';

/// Full notification inbox screen.
/// Shows user-specific and broadcast notifications, with unread badge and mark-all-read.
class NotificationPage extends StatelessWidget {
  final String userId;

  const NotificationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationController()..load(userId),
      child: Consumer<NotificationController>(
        builder: (_, controller, __) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Text('Notifications'),
                  if (controller.unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        controller.unreadCount > 99
                            ? '99+'
                            : '${controller.unreadCount}',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (controller.unreadCount > 0)
                  TextButton.icon(
                    onPressed: () => controller.markAllRead(userId),
                    icon: const Icon(Icons.done_all, size: 18),
                    label: const Text('Mark all read'),
                  ),
              ],
            ),
            body: _buildBody(context, controller),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationController controller) {
    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.load(userId),
      child: ListView.builder(
        itemCount: controller.notifications.length,
        itemBuilder: (_, i) => NotificationTile(controller.notifications[i]),
      ),
    );
  }
}
