import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.appBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputFieldBackgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: TextField(
                  controller: controller,
                  style: AppTextStyles.regular16, 
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: AppTextStyles.regular16.copyWith(
                      color: const Color.fromARGB(
                        137,
                        0,
                        0,
                        0,
                      ), // override only color
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.talkToLiteButtonBackgroundColor,
              ),
              child: IconButton(
                icon:
                    isLoading
                        ? RotationTransition(
                          turns: AlwaysStoppedAnimation(
                            45 / 360,
                          ), // Initial rotation
                          child: AnimatedRotation(
                            duration: Duration(seconds: 1),
                            turns: 1,
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white,
                            ),
                            onEnd: () {
                              if (isLoading) {
                                (context as Element).markNeedsBuild();
                              }
                            },
                          ),
                        )
                        : Icon(Icons.sunny, color: Colors.white),
                onPressed: isLoading ? null : onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
