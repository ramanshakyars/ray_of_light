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
      color: AppColors.iconWhiteColor,
      child: Container(
        // decoration: BoxDecoration(
        //   color: AppColors.inputFieldBackgroundColor,
        //   borderRadius: BorderRadius.circular(25),
        // ),
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
                    hintText: 'Ask anything',
                    hintStyle: AppTextStyles.regular16.copyWith(
                      color: const Color.fromARGB(
                        137,
                        0,
                        0,
                        0,
                      ), // override only color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color:
                            Colors
                                .grey
                                .shade400, // outline color when not focused
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color:
                            AppColors
                                .talkToLiteButtonBackgroundColor, // outline color when focused
                        width: 1.8,
                      ),
                    ),
                    // filled: true,
                    // fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
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
                    isLoading? RotationTransition(turns: AlwaysStoppedAnimation(45 / 360,), // Initial rotation
                          child: AnimatedRotation(
                            duration: Duration(seconds: 1),
                            turns: 1,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onEnd: () {
                              if (isLoading) {
                                (context as Element).markNeedsBuild();
                              }
                            },
                          ),
                        )
                        : Icon(Icons.send, color: Colors.white),
                onPressed: isLoading ? null : onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
