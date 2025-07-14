import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  final String userName;

  const UserDashboard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset('assets/logo.png'),
          onPressed: () {
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'How\'s your day going?',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
