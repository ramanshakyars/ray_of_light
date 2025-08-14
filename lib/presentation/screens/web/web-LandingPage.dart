import 'package:flutter/material.dart';

class WebLandingPage extends StatelessWidget {
  const WebLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Web Landing Page"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.web, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Welcome to the Web Version of Ray of Lite",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "You are currently viewing this on a browser.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Example: Navigate to some other route
                Navigator.pushNamed(context, '/someRoute');
              },
              child: const Text("Explore Features"),
            ),
          ],
        ),
      ),
    );
  }
}
