import 'package:flutter/material.dart';

class TalkToLiteScreen extends StatelessWidget {
  final String userName; // Dynamic username
  
  const TalkToLiteScreen({
    super.key,
    required this.userName, // Required username parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset('assets/logo.png'), // Your logo from assets
          onPressed: () {
            // Handle logo click
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $userName,',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'How\'s your day going?',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            // Add more content here as needed
          ],
        ),
      ),
    );
  }
}