import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';

import '../features/ṃood-manager/UserMood.dart';
import '../features/ṃood-manager/mood-managment.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await LocalStorageService.getUser();
    if (user != null && user['name'] != null) {
      setState(() {
        userName = user['name'];
      });
    }
  }

  Future<void> _openMoodDialog() async {
    final updatedMood = await showDialog<UserMood?>(
      context: context,
      builder: (context) => const MoodDropdownDialog(),
      barrierDismissible: false,
    );

    if (updatedMood != null && mounted) {
      MessageService.showSuccess(
        context,
        'Mood updated to ${updatedMood.type.name}',
      );
    }
  }

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
        actions: [
          IconButton(icon: const Icon(Icons.mood), onPressed: _openMoodDialog),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $userName',
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
