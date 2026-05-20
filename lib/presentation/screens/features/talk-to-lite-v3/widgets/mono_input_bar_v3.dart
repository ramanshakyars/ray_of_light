import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MonoInputBarV3 extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  const MonoInputBarV3({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        color: AppColors.getMonoBackground(isDark),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isLoading,
                minLines: 1,
                maxLines: 4,
                style: AppTextStyles.monoRegular16(isDark),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (!isLoading) onSend();
                },
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: AppTextStyles.monoSecondary14(isDark),
                  filled: true,
                  fillColor: AppColors.getMonoSurface(isDark),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isLoading ? null : onSend,
              child: CircleAvatar(
                radius: 22,
                backgroundColor:
                    isLoading
                        ? AppColors.getMonoBorder(isDark)
                        : AppColors.getMonoTextPrimary(isDark),
                child: Icon(
                  Icons.send,
                  color: AppColors.getMonoBackground(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
