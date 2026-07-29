import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/journalService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';
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
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryTextColor = AppColors.getMonoTextPrimary(isDarkMode);
    final secondaryTextColor = AppColors.getMonoTextSecondary(isDarkMode);
    final surfaceColor = AppColors.getMonoSurface(isDarkMode);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.getMonoBackground(isDarkMode),

      drawer: Drawer(
        backgroundColor: AppColors.getMonoBackground(isDarkMode),
        child: JournalismDrawer(
          postedThoughts: _postedThoughts,
          onThoughtSelected: (thought) {
            _thoughtController.text = thought;
          },
          theme: Theme.of(context),
        ),
      ),

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              AppScreenHeader(
                title: "Your Nest",
                subtitle: "A safe place for your thoughts",
                leading: GestureDetector(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                    child: Icon(
                      Icons.menu_rounded,
                      color: AppColors.getMonoIcon(isDarkMode),
                      size: 26,
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => context.push('${RouteNames.mainApp}/${RouteNames.home}'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryTextColor.withOpacity(0.04),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/nest-logo.png',
                        height: 26,
                        width: 26,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ===== AFFIRMATION CARD =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: primaryTextColor.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: primaryTextColor.withOpacity(0.15),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _todaysAffirmation,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.monoMedium18(isDarkMode).copyWith(
                        height: 1.5,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // ===== INPUT SECTION =====
              Text(
                "What's on your heart today?",
                style: AppTextStyles.monoMedium18(isDarkMode).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.getMonoDivider(isDarkMode)),
                  boxShadow: [
                    BoxShadow(
                      color: primaryTextColor.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _thoughtController,
                      style: AppTextStyles.monoRegular16(isDarkMode).copyWith(fontSize: 16),
                      maxLines: 4,
                      minLines: 4,
                      decoration: InputDecoration(
                        hintText: "Write your thought...",
                        hintStyle: AppTextStyles.monoSecondary14(isDarkMode),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mood_rounded, color: secondaryTextColor, size: 24),
                              const SizedBox(width: 16),
                              Icon(Icons.lock_rounded, color: secondaryTextColor, size: 22),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _isPosting ? null : _postThought,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryTextColor,
                              foregroundColor: AppColors.getMonoBackground(isDarkMode),
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: _isPosting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.getMonoBackground(isDarkMode),
                                    ),
                                  )
                                : const Text(
                                    "Share",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

}
