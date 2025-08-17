import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to login page when tapped anywhere
        GoRouter.of(context).push('/login');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ), // Added horizontal padding
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Align text to start
              children: [
                // Your logo from assets
                Image.asset('assets/logo.png', width: 80, height: 80),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Ray of Light',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic, // Added italic
                  ),
                ),

                const SizedBox(height: 30),

                // Subtitle
                const Text(
                  'We are here to help you to be',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic, // Added italic
                  ),
                ),

                const SizedBox(height: 10),

                // Main message
                Text(
                  'better than yesterday',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                    fontStyle: FontStyle.italic, 
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
