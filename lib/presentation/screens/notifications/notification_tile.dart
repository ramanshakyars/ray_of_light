import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/presentation/screens/notifications/notification_model.dart';

/// Notification list tile with type icon, priority indicator, relative timestamp,
/// and deep-link tap navigation.
class NotificationTile extends StatelessWidget {
  final AppNotification n;

  const NotificationTile(this.n, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: () {
        // Navigate to deepLink if present
        final route = n.deepLink ??
            (n.data != null ? n.data!['deepLink']?.toString() : null);
        if (route != null && route.isNotEmpty) {
          context.go(route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: n.isRead
              ? colors.surface
              : colors.primary.withOpacity(0.06),
          border: Border(
            bottom: BorderSide(
              color: colors.outline.withOpacity(0.15),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _iconBackgroundColor(n.type, colors),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _typeIcon(n.type),
                size: 20,
                color: _iconColor(n.type, colors),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: n.isRead
                                ? FontWeight.w400
                                : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!n.isRead) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    n.message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withOpacity(0.65),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (n.createdAt != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      _relativeTime(n.createdAt!),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Priority indicator (only for HIGH)
            if (n.priority == 'HIGH') ...[
              const SizedBox(width: 8),
              Icon(Icons.priority_high, size: 16, color: colors.error),
            ],
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────────────

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'CHAT_MESSAGE':
        return Icons.chat_bubble_outline_rounded;
      case 'REMINDER':
      case 'GOAL_REMINDER':
        return Icons.alarm_rounded;
      case 'MOOD_CHECK_IN':
        return Icons.mood_rounded;
      case 'JOURNAL_PROMPT':
        return Icons.edit_note_rounded;
      case 'PROMOTION':
      case 'COUPON':
        return Icons.local_offer_outlined;
      case 'PAYMENT_SUCCESS':
        return Icons.check_circle_outline_rounded;
      case 'PAYMENT_FAILED':
        return Icons.cancel_outlined;
      case 'SYSTEM':
        return Icons.settings_outlined;
      case 'BROADCAST':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _iconBackgroundColor(String? type, ColorScheme colors) {
    switch (type) {
      case 'PAYMENT_SUCCESS':
        return Colors.green.shade50;
      case 'PAYMENT_FAILED':
        return Colors.red.shade50;
      case 'PROMOTION':
      case 'COUPON':
        return Colors.orange.shade50;
      case 'CHAT_MESSAGE':
        return colors.primary.withOpacity(0.1);
      default:
        return colors.secondaryContainer.withOpacity(0.5);
    }
  }

  Color _iconColor(String? type, ColorScheme colors) {
    switch (type) {
      case 'PAYMENT_SUCCESS':
        return Colors.green.shade700;
      case 'PAYMENT_FAILED':
        return Colors.red.shade700;
      case 'PROMOTION':
      case 'COUPON':
        return Colors.orange.shade700;
      case 'CHAT_MESSAGE':
        return colors.primary;
      default:
        return colors.onSecondaryContainer;
    }
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}