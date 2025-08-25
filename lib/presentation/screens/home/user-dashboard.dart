import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
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
        // title: const Text('About us'),
        centerTitle: true,
        backgroundColor: AppColors.appBackgroundColor,
        leading: IconButton(
          icon: Image.asset('assets/logo.png'),
          onPressed: () {
            GoRouter.of(
              context,
            ).push('${RouteNames.mainApp}/${RouteNames.profile}');
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
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Here\'s your daily dose of inspiration',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Single Poem Card
            _buildStanzaCard(
              context,
              title: 'Ray of Light',
              lines: [
                // The Break
                'In life, we must face the break,',
                'The cracks that cause the soul to ache.',
                'But through the pain, a truth will rise,',
                'Strength is hiding in disguise.',
                '',
                // The Storm
                'If no storm had ever blown,',
                'You\'d never see how much you\'ve grown.',
                'A heart untested might seem whole,',
                'But trials awaken soul.',
                '',
                // The Light Within
                'In the dark, when hope feels thin,',
                'You\'ll find your Ray of Light within.',
                'A glow that guides you through the night,',
                'Makes the broken edges bright.',
                '',
                // The Art of You
                'Don\'t fear the times you fall apart,',
                'They carve the courage in your heart.',
                'Each break becomes a sacred start,',
                'A stronger you, a work of art.',
              ],
              color: AppColors.appBackgroundColor,
              borderColor: const Color.fromARGB(255, 131, 130, 134),
              icon: Icons.auto_awesome,
            ),

            const SizedBox(height: 24),
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
