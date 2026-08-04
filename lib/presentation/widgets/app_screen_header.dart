import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

/// A shared, consistent header used across all main app screens.
///
/// Layout:
///   [leading?]  [title + subtitle]  [actions?]
///
/// Colors and typography are driven from the global ThemeProvider.
class AppScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final double bottomPadding;

  const AppScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottomPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = themeProvider.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.screenTitle(colors),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTextStyles.hintText(colors),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 8),
            ...actions!,
          ],
        ],
      ),
    );
  }

  /// Helper: circular action button (e.g. mood, menu)
  static Widget circleAction({
    required IconData icon,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.getMonoSurface(isDark),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.getMonoBorder(isDark).withValues(alpha: 0.4),
          ),
        ),
        child: Icon(icon, size: 19, color: AppColors.getMonoIcon(isDark)),
      ),
    );
  }
}
