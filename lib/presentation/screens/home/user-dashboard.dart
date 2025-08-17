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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi $userName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Here\'s your daily dose of inspiration',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Poem Cards
            _buildStanzaCard(
              context,
              title: 'The Break',
              lines: [
                'In life, we must face the break,',
                'The cracks that cause the soul to ache.',
                'But through the pain, a truth will rise.',
                'Strength is hiding in disguise.',
              ],
              color: Colors.blue[50]!,
              borderColor: Colors.blue,
            ),

            const SizedBox(height: 20),

            _buildStanzaCard(
              context,
              title: 'The Storm',
              lines: [
                'If no storm had ever blown,',
                'You\'d never see how much you\'ve grown.',
                'A heart untested might seem whole,',
                'But trials awaken soul.',
              ],
              color: Colors.green[50]!,
              borderColor: Colors.green,
              icon: Icons.cloud,
            ),

            const SizedBox(height: 20),

            _buildStanzaCard(
              context,
              title: 'The Light Within',
              lines: [
                'In the dark, when hope feels ends,',
                'You\'ll find your Ray of Light within.',
                'A glow that guides you through the night,',
                'Makes the broken edges bright.',
              ],
              color: Colors.orange[50]!,
              borderColor: Colors.orange,
              icon: Icons.lightbulb_outline,
            ),

            const SizedBox(height: 20),

            _buildStanzaCard(
              context,
              title: 'The Art of You',
              lines: [
                'Don\'t fear the times you fall apart,',
                'They carve the courage in your heart.',
                'Each break becomes a sacred start',
                'A stronger you, a work of art.',
              ],
              color: Colors.purple[50]!,
              borderColor: Colors.purple,
              icon: Icons.brush,
            ),

            const SizedBox(height: 24),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.deepPurple.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    '✨ Ray of Light ✨',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Remember: Every challenge is an opportunity to grow',
                    style: TextStyle(fontSize: 14, color: Colors.deepPurple),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStanzaCard(
    BuildContext context, {
    required String title,
    required List<String> lines,
    required Color color,
    required Color borderColor,
    IconData? icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor.withOpacity(0.3), width: 1.5),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(icon, color: borderColor),
                  ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  line,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
