import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_outlined,
                size: 38,
                color: colors.primary.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Posts Yet",
              style: AppTextStyles.sectionTitle(colors),
            ),
            const SizedBox(height: 10),
            Text(
              "Be the first to share your light ✨",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary(colors).copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}