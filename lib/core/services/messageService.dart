import 'package:flutter/material.dart';

class MessageService {
  static const Duration _displayDuration = Duration(seconds: 3);

  static void showSuccess(BuildContext context, String message) {
    _showTopSnackBar(context, message, Colors.green, Icons.check_circle);
  }

  static void showInfo(BuildContext context, String message) {
    _showTopSnackBar(context, message, Colors.blue, Icons.info);
  }

  static void showError(BuildContext context, String message) {
    _showTopSnackBar(context, message, Colors.red, Icons.error);
  }

  static void _showTopSnackBar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: _TopSnackBarContent(
                message: message,
                color: color,
                icon: icon,
              ),
            ),
          ),
    );

    // Insert the overlay
    overlay.insert(overlayEntry);

    // Remove the overlay after duration
    Future.delayed(_displayDuration, () {
      overlayEntry.remove();
    });
  }
}

class _TopSnackBarContent extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;

  const _TopSnackBarContent({
    required this.message,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
