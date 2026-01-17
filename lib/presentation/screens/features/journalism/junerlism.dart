import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/main-layout.dart';

import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/journalService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'journalism_drawer.dart';
// Make sure this is the ThemeProvider code from your snippet

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

  late final String _todaysAffirmation;

  @override
  void initState() {
    super.initState();
    // Pick affirmation for today using day-of-year
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    _todaysAffirmation =
        _sampleAffirmations[dayOfYear % _sampleAffirmations.length];
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  Future<void> _postThought() async {
    final thoughtText = _thoughtController.text.trim();
    if (thoughtText.isEmpty) return;
    setState(() => _isPosting = true);
    final curruntUserMood = await LocalStorageService.getCurrentMoodType();
    // if(curruntUserMood?.type == null) return;
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      key: _scaffoldKey,
      drawer: Drawer(
        child: JournalismDrawer(
          postedThoughts: _postedThoughts,
          onThoughtSelected: (thought) {
            _thoughtController.text = thought;
          },
          theme: Theme.of(context),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.getCard(isDarkMode),
        elevation: 1,
        title: Text('Nest', style: AppTextStyles.bold22(isDarkMode)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.getIconColor(isDarkMode)),
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
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getMuted(isDarkMode).withOpacity(0.08),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.getBorder(isDarkMode),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(
                      _todaysAffirmation,
                      style: AppTextStyles.regular14(isDarkMode),
                    ),
                    backgroundColor: AppColors.getAccent(isDarkMode),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Write what\'s in your mind. Share your thoughts, affirmations, or motivations.',
                    style: AppTextStyles.regular16(
                      isDarkMode,
                    ).copyWith(color: AppColors.getMutedForeground(isDarkMode)),
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
                              color: AppColors.getMutedForeground(isDarkMode),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No thoughts shared yet.\nBe the first to inspire others!',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.medium18(
                                isDarkMode,
                              ).copyWith(
                                color: AppColors.getMutedForeground(isDarkMode),
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
                              color: AppColors.getCard(isDarkMode),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.getBorder(
                                    isDarkMode,
                                  ).withOpacity(0.13),
                                  blurRadius: 8,
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
                                        backgroundColor: AppColors.getAccent(
                                          isDarkMode,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 16,
                                          color: AppColors.getAccentForeground(
                                            isDarkMode,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Posted ${index + 1} hour${index == 0 ? '' : 's'} ago',
                                        style: AppTextStyles.regular14(
                                          isDarkMode,
                                        ).copyWith(
                                          color: AppColors.getMutedForeground(
                                            isDarkMode,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _postedThoughts[index],
                                    style: AppTextStyles.regular16(isDarkMode),
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
                color: AppColors.getCard(isDarkMode),
                border: Border(
                  top: BorderSide(
                    color: AppColors.getBorder(isDarkMode),
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
                      hintStyle: AppTextStyles.regular14(isDarkMode).copyWith(
                        color: AppColors.getMutedForeground(isDarkMode),
                      ),
                      fillColor: AppColors.getInputBackground(isDarkMode),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.getBorder(isDarkMode),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.getPrimary(isDarkMode),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color:
                              _isPosting
                                  ? AppColors.getBorder(isDarkMode)
                                  : AppColors.getPrimary(isDarkMode),
                        ),
                        onPressed: _isPosting ? null : _postThought,
                      ),
                    ),
                    style: AppTextStyles.regular14(isDarkMode),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPosting ? null : _postThought,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.getFormSubmitButtonColor(
                          isDarkMode,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: AppColors.getPrimaryForeground(
                          isDarkMode,
                        ),
                        elevation: _isPosting ? 0 : 2,
                        textStyle: AppTextStyles.button16(isDarkMode),
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
                                style: AppTextStyles.buttonText(isDarkMode),
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
