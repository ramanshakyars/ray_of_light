import 'package:flutter/material.dart';

class MessageService {
  static const Duration _displayDuration = Duration(seconds: 3);
  static const Duration _animDuration = Duration(milliseconds: 320);

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, const Color(0xFF34C759), Icons.check_circle_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, const Color(0xFF007AFF), Icons.info_rounded);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, const Color(0xFFFF3B30), Icons.cancel_rounded);
  }

  static void _show(
    BuildContext context,
    String message,
    Color accentColor,
    IconData icon,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _PhoneSnackBar(
        message: message,
        accentColor: accentColor,
        icon: icon,
        displayDuration: _displayDuration,
        animDuration: _animDuration,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone-style animated snackbar (bottom pill, slide-up + fade)
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneSnackBar extends StatefulWidget {
  final String message;
  final Color accentColor;
  final IconData icon;
  final Duration displayDuration;
  final Duration animDuration;
  final VoidCallback onDismiss;

  const _PhoneSnackBar({
    required this.message,
    required this.accentColor,
    required this.icon,
    required this.displayDuration,
    required this.animDuration,
    required this.onDismiss,
  });

  @override
  State<_PhoneSnackBar> createState() => _PhoneSnackBarState();
}

class _PhoneSnackBarState extends State<_PhoneSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: widget.animDuration);

    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();
    Future.delayed(widget.displayDuration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: bottomInset + 80,
      left: 48,   // narrower pill
      right: 48,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: GestureDetector(
            onTap: _dismiss,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  // Lighter mid-grey — readable but not heavy
                  color: const Color(0xFF3A3A3C),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.22),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Small accent dot / icon
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Message text
                    Flexible(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.92),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                          fontFamily: 'Arial',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
