import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/journalService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'journalism_drawer.dart';

class JournalismScreen extends StatefulWidget {
  const JournalismScreen({super.key});

  @override
  State<JournalismScreen> createState() => _JournalismScreenState();
}

class _JournalismScreenState extends State<JournalismScreen> {
  final TextEditingController _thoughtController = TextEditingController();
  final List<String> _postedThoughts = [];
  bool _isPosting = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final thoughtText = _thoughtController.text.trim();
    if (thoughtText.isEmpty) return;
    setState(() => _isPosting = true);
    final curruntUserMood = await LocalStorageService.getCurrentMood();
    print(curruntUserMood);
    if(curruntUserMood == null) return;
    final journalData = {
      "content": thoughtText,
      "type": "TEXT",
      "associatedMood": curruntUserMood,
    };
    final response = await JournalService.postJournalThaought(journalData);
    setState(() => _isPosting = false);
    if (response['success'] == true) {
      setState(() {
        _postedThoughts.insert(0, thoughtText);
        _thoughtController.clear();
      });
      MessageService.showSuccess(
        context,
        response['message'] ?? "Your thought has been posted!",
      );
    } else {
      MessageService.showError(
        context,
        response['message'] ?? "Failed to post your thought.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: JournalismDrawer(
          postedThoughts: _postedThoughts,
          onThoughtSelected: (thought) {
            _thoughtController.text = thought;
          },
          theme: theme,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Journalism',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 1,
        shadowColor: Colors.black.withValues(),
        leading: IconButton(
          icon: Icon(Icons.menu, color: colorScheme.onSurface),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed:
                () => GoRouter.of(
                  context,
                ).push('${RouteNames.mainApp}/${RouteNames.home}'),
            iconSize: 32,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Inspiration section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright.withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"Journalism"',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Write what\'s in your mind. Share your thoughts, affirmations, or motivations.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
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
                                    label: Text(
                                      affirmation,
                                      style: theme.textTheme.labelMedium,
                                    ),
                                    backgroundColor:
                                        colorScheme.primaryContainer,
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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

            // Posted thoughts section
            Expanded(
              child:
                  _postedThoughts.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 48,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No thoughts shared yet.\nBe the first to inspire others!',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _postedThoughts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            colorScheme.primaryContainer,
                                        child: Icon(
                                          Icons.person,
                                          size: 16,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Posted ${index + 1} hour${index == 0 ? '' : 's'} ago',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _postedThoughts[index],
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),

            // Input section
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _thoughtController,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Write your thought or affirmation here...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color:
                              _isPosting
                                  ? colorScheme.onSurface.withOpacity(0.5)
                                  : colorScheme.primary,
                        ),
                        onPressed: _isPosting ? null : _postThought,
                      ),
                    ),
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isPosting ? null : _postThought,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isPosting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Share Your Thought',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
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
