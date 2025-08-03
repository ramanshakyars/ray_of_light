import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                // Add your logo image here (make sure it's in your assets folder)
                Image.asset(
                  'assets/logo.png', // Update with your actual image path
                  height: 80, // Adjust size as needed
                ),
                SizedBox(height: 10),
                Text(
                  'Ray of Light',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'We are here to help you to be better than yesterday',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement reset password logic
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
