import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class JournalismScreen extends StatefulWidget {
  const JournalismScreen({super.key});

  @override
  State<JournalismScreen> createState() => _JournalismScreenState();
}

class _JournalismScreenState extends State<JournalismScreen> {
  final TextEditingController _thoughtController = TextEditingController();
  final List<String> _postedThoughts = [];
  final List<Map<String, dynamic>> _journalHistory = [];
  
  bool _isPosting = false;
  bool _isLoadingHistory = false;
  int _selectedAffirmationIndex = 0;
  String? _selectedMoodTag;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample mood chips
  final List<Map<String, String>> _moodOptions = const [
    {"label": "Calm", "emoji": "🌿", "code": "CALM"},
    {"label": "Inspired", "emoji": "✨", "code": "INSPIRED"},
    {"label": "Grateful", "emoji": "💙", "code": "GRATEFUL"},
    {"label": "Reflective", "emoji": "☁️", "code": "REFLECTIVE"},
    {"label": "Energized", "emoji": "⚡", "code": "ENERGIZED"},
    {"label": "Overwhelmed", "emoji": "🌧️", "code": "OVERWHELMED"},
  ];

  // Affirmation list
  final List<String> _sampleAffirmations = const [
    "Today, I choose to focus on what matters most.",
    "I am capable of amazing things.",
    "Every challenge is an opportunity to grow.",
    "My thoughts create my reality.",
    "I am grateful for this moment.",
    "Progress, not perfection, is the goal.",
    "I welcome positivity and peace into my life.",
    "My potential is limitless.",
  ];

  @override
  void initState() {
    super.initState();
    // Pick affirmation for today using day-of-year
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    _selectedAffirmationIndex = dayOfYear % _sampleAffirmations.length;
    _fetchJournalHistory();
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  Future<void> _fetchJournalHistory() async {
    if (_isLoadingHistory) return;
    setState(() => _isLoadingHistory = true);
    try {
      final response = await JournalService.getJournalsHistory();
      if (response['success'] == true && response['data'] != null) {
        final list = (response['data'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        setState(() {
          _journalHistory.clear();
          _journalHistory.addAll(list);
        });
      }
    } catch (e) {
      debugPrint("Error fetching journal history: $e");
    } finally {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _postThought() async {
    final thoughtText = _thoughtController.text.trim();
    if (thoughtText.isEmpty) return;

    setState(() => _isPosting = true);

    try {
      final currentMood = _selectedMoodTag ?? await LocalStorageService.getCurrentMoodType();
      final journalData = {
        "content": thoughtText,
        "type": "TEXT",
        "associatedMood": currentMood,
      };

      final response = await JournalService.postJournalThaought(journalData);

      if (response['success'] == true) {
        setState(() {
          _postedThoughts.insert(0, thoughtText);
          _thoughtController.clear();
          _selectedMoodTag = null;
        });

        HapticFeedback.mediumImpact();
        if (mounted) {
          MessageService.showSuccess(
            context,
            response['message'] ?? "Thought saved to your Nest!",
          );
        }

        // Refresh history list
        await _fetchJournalHistory();
      } else {
        if (mounted) {
          MessageService.showError(
            context,
            response['message'] ?? "Failed to save your thought.",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        MessageService.showError(context, "Something went wrong.");
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  void _nextAffirmation() {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedAffirmationIndex =
          (_selectedAffirmationIndex + 1) % _sampleAffirmations.length;
    });
  }

  void _copyAffirmationToInput() {
    HapticFeedback.selectionClick();
    final text = _sampleAffirmations[_selectedAffirmationIndex];
    setState(() {
      _thoughtController.text = '"$text"\n\nReflecting on this: ';
      _thoughtController.selection = TextSelection.fromPosition(
        TextPosition(offset: _thoughtController.text.length),
      );
    });
  }

  void _showEntryDetail(Map<String, dynamic> entry, bool isDark) {
    final content = entry['content']?.toString() ?? '';
    final mood = entry['associatedMood']?.toString() ?? 'REFLECTION';
    final dateStr = _formatTimestamp(entry['createdAt'] ?? entry['date']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: AppColors.getMonoCard(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.getMonoBorder(isDark).withValues(alpha: 0.6),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.getMonoBorder(isDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.getMonoSurface(isDark),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.getMonoBorder(isDark)),
                    ),
                    child: Text(
                      mood.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getMonoTextSecondary(isDark),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    dateStr,
                    style: AppTextStyles.monoMuted12(isDark),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Full content
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.getMonoTextPrimary(isDark),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Copy button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    Navigator.pop(context);
                    MessageService.showSuccess(context, "Copied to clipboard");
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text("Copy Journal Entry"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.getMonoTextPrimary(isDark),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.getMonoBorder(isDark)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(dynamic rawDate) {
    if (rawDate == null) return "Recent";
    try {
      final dt = DateTime.parse(rawDate.toString()).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 2) return "Just now";
      if (diff.inHours < 1) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24 && dt.day == now.day) {
        final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final min = dt.minute.toString().padLeft(2, '0');
        final ampm = dt.hour >= 12 ? 'PM' : 'AM';
        return "Today, $hour:$min $ampm";
      }
      if (diff.inDays < 2) return "Yesterday";
      
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
    } catch (_) {
      return "Recent";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryTextColor = AppColors.getMonoTextPrimary(isDarkMode);
    final secondaryTextColor = AppColors.getMonoTextSecondary(isDarkMode);
    final surfaceColor = AppColors.getMonoSurface(isDarkMode);
    final borderColor = AppColors.getMonoBorder(isDarkMode);

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
        child: RefreshIndicator(
          onRefresh: _fetchJournalHistory,
          color: primaryTextColor,
          backgroundColor: surfaceColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HEADER ─────────────────────────────────────
                AppScreenHeader(
                  title: "Your Nest",
                  subtitle: "A quiet space for thoughts & reflection",
                  leading: GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: AppColors.getMonoIcon(isDarkMode),
                        size: 20,
                      ),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () => context.push('${RouteNames.mainApp}/${RouteNames.home}'),
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Image.asset(
                          'assets/nest-logo.png',
                          height: 22,
                          width: 22,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── DAILY AFFIRMATION CARD ──────────────────────
                _buildAffirmationCard(isDarkMode, surfaceColor, borderColor, primaryTextColor, secondaryTextColor),

                const SizedBox(height: 28),

                // ── INPUT SECTION HEADER & MOOD CHIPS ───────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Express Yourself",
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (_thoughtController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _thoughtController.clear()),
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 13,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Mood selector horizontal scroll
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _moodOptions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final m = _moodOptions[i];
                      final isSelected = _selectedMoodTag == m['code'];
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedMoodTag = isSelected ? null : m['code'];
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryTextColor : surfaceColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? primaryTextColor
                                  : borderColor.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(m['emoji']!, style: const TextStyle(fontSize: 13)),
                              const SizedBox(width: 6),
                              Text(
                                m['label']!,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12.5,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.getMonoBackground(isDarkMode)
                                      : primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // ── TEXT INPUT CARD ─────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                        child: TextField(
                          controller: _thoughtController,
                          onChanged: (_) => setState(() {}),
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 15,
                            height: 1.5,
                            color: primaryTextColor,
                          ),
                          maxLines: 5,
                          minLines: 3,
                          decoration: InputDecoration(
                            hintText: "What's on your mind today? Write freely...",
                            hintStyle: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: AppColors.getMonoTextMuted(isDarkMode),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      
                      const Divider(height: 1),

                      // Footer action bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 14,
                                  color: AppColors.getMonoTextMuted(isDarkMode),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Private & encrypted",
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 11,
                                    color: AppColors.getMonoTextMuted(isDarkMode),
                                  ),
                                ),
                              ],
                            ),

                            // Save button
                            ElevatedButton.icon(
                              onPressed: _isPosting || _thoughtController.text.trim().isEmpty
                                  ? null
                                  : _postThought,
                              icon: _isPosting
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.send_rounded, size: 14),
                              label: Text(
                                _isPosting ? "Saving..." : "Save Entry",
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryTextColor,
                                foregroundColor: AppColors.getMonoBackground(isDarkMode),
                                disabledBackgroundColor:
                                    primaryTextColor.withValues(alpha: 0.3),
                                disabledForegroundColor: AppColors.getMonoBackground(isDarkMode)
                                    .withValues(alpha: 0.6),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── RECENT ENTRIES TIMELINE SECTION ─────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Journal History",
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: primaryTextColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_journalHistory.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              "${_journalHistory.length}",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh_rounded, size: 18, color: secondaryTextColor),
                      onPressed: _fetchJournalHistory,
                      tooltip: "Refresh history",
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // List of past entries
                if (_isLoadingHistory && _journalHistory.isEmpty)
                  _buildHistoryLoadingState(isDarkMode, surfaceColor)
                else if (_journalHistory.isEmpty)
                  _buildEmptyState(isDarkMode, surfaceColor, borderColor, primaryTextColor, secondaryTextColor)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _journalHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _journalHistory[index];
                      return _JournalEntryCard(
                        entry: item,
                        isDark: isDarkMode,
                        onTap: () => _showEntryDetail(item, isDarkMode),
                      );
                    },
                  ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AFFIRMATION CARD WIDGET ──────────────────────────────────
  Widget _buildAffirmationCard(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryColor,
    Color secondaryColor,
  ) {
    final affirmation = _sampleAffirmations[_selectedAffirmationIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "DAILY AFFIRMATION",
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: secondaryColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.refresh_rounded, size: 18, color: secondaryColor),
                    onPressed: _nextAffirmation,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: "New affirmation",
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _copyAffirmationToInput,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit_note_rounded, size: 14, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            "Reflect",
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '"$affirmation"',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // ── EMPTY STATE WIDGET ───────────────────────────────────────
  Widget _buildEmptyState(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.book_outlined,
              size: 26,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "No journal entries yet",
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Write your first thought above to start building your personal Nest history.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 13,
              height: 1.4,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── HISTORY LOADING SHIMMER ─────────────────────────────────
  Widget _buildHistoryLoadingState(bool isDark, Color surfaceColor) {
    return Column(
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// JOURNAL ENTRY CARD
// ─────────────────────────────────────────────────────────────
class _JournalEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final bool isDark;
  final VoidCallback onTap;

  const _JournalEntryCard({
    required this.entry,
    required this.isDark,
    required this.onTap,
  });

  String _formatDate(dynamic rawDate) {
    if (rawDate == null) return "Recent";
    try {
      final dt = DateTime.parse(rawDate.toString()).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 2) return "Just now";
      if (diff.inHours < 1) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24 && dt.day == now.day) {
        final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final min = dt.minute.toString().padLeft(2, '0');
        final ampm = dt.hour >= 12 ? 'PM' : 'AM';
        return "$hour:$min $ampm";
      }
      if (diff.inDays < 2) return "Yesterday";
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${dt.day} ${months[dt.month - 1]}";
    } catch (_) {
      return "Recent";
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = entry['content']?.toString() ?? '';
    final mood = entry['associatedMood']?.toString() ?? 'THOUGHT';
    final dateStr = _formatDate(entry['createdAt'] ?? entry['date']);

    final primaryColor = AppColors.getMonoTextPrimary(isDark);
    final secondaryColor = AppColors.getMonoTextSecondary(isDark);
    final surfaceColor = AppColors.getMonoSurface(isDark);
    final borderColor = AppColors.getMonoBorder(isDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    mood.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 11,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14.5,
                height: 1.45,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
