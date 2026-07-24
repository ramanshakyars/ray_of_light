import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class InputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  const InputArea({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.getAppBackgroundColor(isDarkMode),
      child: Container(
        // decoration: BoxDecoration(
        //   color: AppColors.inputFieldBackgroundColor,
        //   borderRadius: BorderRadius.circular(25),
        // ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontSize: AppTextStyles.regular14(isDarkMode).fontSize,
                    fontFamily: "Specimen",
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Ask anything',
                    hintStyle: TextStyle(
                      color: AppColors.getTextPrimaryColor(isDarkMode).withValues(),
                      fontSize: 16,
                      fontFamily: "Specimen",
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppColors.getTalkToLiteButtonBackgroundColor(isDarkMode),
                        width: 1.8,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.getTalkToLiteButtonBackgroundColor(isDarkMode),
                      ),
                      child: IconButton(
                        icon: isLoading
                            ? const Icon(Icons.send, color: Colors.white)
                            : const Icon(Icons.send, color: Colors.white),
                        onPressed: isLoading ? null : onSend,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}