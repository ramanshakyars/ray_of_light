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
  final isDarkMode =
      Provider.of<ThemeProvider>(context).isDarkMode;

  return Scaffold(
    key: _scaffoldKey,
    backgroundColor: AppColors.getMonoBackground(isDarkMode),

    // ================= APP BAR =================
    appBar: AppBar(
      backgroundColor: AppColors.getMonoBackground(isDarkMode),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu,
            color: AppColors.getMonoIcon(isDarkMode)),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        IconButton(
          icon: Image.asset('assets/logo.png', height: 26),
          onPressed: () => context.push(
            '${RouteNames.mainApp}/${RouteNames.home}',
          ),
        ),
      ],
    ),

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ===== TITLE =====
            Text(
              "Nest",
              style: AppTextStyles.monoBold22(isDarkMode)
                  .copyWith(fontSize: 34),
            ),

            const SizedBox(height: 6),

            Text(
              "A safe place for your thoughts",
              style: AppTextStyles.monoSecondary14(isDarkMode),
            ),

            const SizedBox(height: 40),

            // ===== AFFIRMATION =====
            Text(
              _todaysAffirmation,
              textAlign: TextAlign.center,
              style: AppTextStyles.monoMedium18(isDarkMode)
                  .copyWith(height: 1.5),
            ),

            const Spacer(),

            // ===== BLACK LOGO CIRCLE =====
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black, // intentional
              ),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 36,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Your nest is quiet right now",
              style: AppTextStyles.monoSecondary14(isDarkMode),
            ),

            const Spacer(),

            // ===== INPUT LABEL =====
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What's on your heart today?",
                style: AppTextStyles.monoSecondary14(isDarkMode),
              ),
            ),

            const SizedBox(height: 8),

            // ===== INPUT =====
            TextField(
              controller: _thoughtController,
              style: AppTextStyles.monoRegular16(isDarkMode),
              decoration: InputDecoration(
                hintText: "Write your thought...",
                hintStyle:
                    AppTextStyles.monoSecondary14(isDarkMode),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.getMonoDivider(isDarkMode),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.getMonoTextPrimary(isDarkMode),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== BUTTON =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPosting ? null : _postThought,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isPosting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Share your thought"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

}
