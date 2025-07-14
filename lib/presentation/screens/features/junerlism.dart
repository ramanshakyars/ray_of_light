import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/messageService.dart';

class JournalismScreen extends StatefulWidget {
  const JournalismScreen({super.key});

  @override
  State<JournalismScreen> createState() => _JournalismScreenState();
}

class _JournalismScreenState extends State<JournalismScreen> {
  final TextEditingController _thoughtController = TextEditingController();
  final List<String> _postedThoughts = [];
  bool _isPosting = false;

  // Sample affirmations to inspire users
  final List<String> _sampleAffirmations = [
    "Today, I choose to focus on what matters most.",
    "I am capable of amazing things.",
    "Every challenge is an opportunity to grow.",
    "My thoughts create my reality.",
    "I am grateful for this moment.",
    "Progress, not perfection, is the goal.",
    "I welcome positivity into my life.",
    "My potential is limitless.",
  ];

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  Future<void> _postThought() async {
    if (_thoughtController.text.trim().isEmpty) return;
    setState(() => _isPosting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _postedThoughts.insert(0, _thoughtController.text.trim());
      _thoughtController.clear();
      _isPosting = false;
    });
    MessageService.showSuccess(
      context,
      "Your thought has been shared with the universe",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journalism', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 4,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed:
                () => GoRouter.of(
                  context,
                ).push('${RouteNames.mainApp}/${RouteNames.home}'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Inspiration section with constrained height
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '"Journalism "',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Write what\'s in your mind. Share your thoughts, affirmations, or motivations.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120, // Fixed height for the chips
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              _sampleAffirmations.map((affirmation) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _thoughtController.text = affirmation;
                                    },
                                    child: Chip(
                                      label: Text(affirmation),
                                      backgroundColor: Colors.blue[50],
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Thought input section

            // Divider to separate sections
            const Divider(height: 1),

            // Posted thoughts section with flexible space
            Expanded(
              child:
                  _postedThoughts.isEmpty
                      ? const Center(
                        child: Text(
                          'No thoughts shared yet.\nBe the first to inspire others!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 60,
                        ), // Space for bottom nav
                        itemCount: _postedThoughts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        child: Icon(Icons.person, size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Posted ${index + 1} hour${index == 0 ? '' : 's'} ago',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _postedThoughts[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _thoughtController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write your thought or affirmation here...',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _isPosting ? null : _postThought,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPosting ? null : _postThought,
                      child:
                          _isPosting
                              ? const CircularProgressIndicator()
                              : const Text('Share Your Thought'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
