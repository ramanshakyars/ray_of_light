import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🖼️ Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/red-background.png',
            fit: BoxFit.cover,
          ),
        ),

        
        // Positioned.fill(
        //   child: Container(
        //     color: Colors.black.withOpacity(0.4), 
        //   ),
        // ),

        
        child,
      ],
    );
  }
}
