import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
      color: Color(0xFF16213E),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0F3460),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            // Light Bulb Icon with rotation animation when loading
            Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 176, 188, 190),
                    Color(0xFF0083B0),
                  ],
                ),
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
                              // This will keep the animation looping
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
