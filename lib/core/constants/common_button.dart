import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import '../theme/appcolors.dart';
import '../theme/themeProvider.dart';

enum ButtonSize { small, medium, large }
enum ButtonVariant { filled, outline, ghost }

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  final ButtonSize size;
  final ButtonVariant variant;
  final bool fullWidth;

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.filled,
    this.fullWidth = true,
  });

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final bgColor = variant == ButtonVariant.filled
        ? AppColors.getMonoTextPrimary(isDark)
        : Colors.transparent;

    final txtColor = variant == ButtonVariant.filled
        ? AppColors.getMonoBackground(isDark)
        : AppColors.getMonoTextPrimary(isDark);

    final borderColor = AppColors.getMonoBorder(isDark);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _height,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: (isLoading || onPressed == null) ? null : onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(28),
            border: variant == ButtonVariant.outline
                ? Border.all(color: borderColor)
                : null,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: txtColor,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: txtColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.monoRegular16(isDark)
                            .copyWith(
                          color: txtColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
