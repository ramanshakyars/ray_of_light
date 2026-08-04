import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/services/journalService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
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
  String? _selectedMoodTag;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> _moodOptions = const [
    {"label": "Calm", "emoji": "🌿", "code": "CALM"},
    {"label": "Inspired", "emoji": "✨", "code": "INSPIRED"},
    {"label": "Grateful", "emoji": "💙", "code": "GRATEFUL"},
    {"label": "Reflective", "emoji": "☁️", "code": "REFLECTIVE"},
    {"label": "Energized", "emoji": "⚡", "code": "ENERGIZED"},
    {"label": "Overwhelmed", "emoji": "🌧️", "code": "OVERWHELMED"},
  ];

  @override
  void initState() {
    super.initState();
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

  void _showEntryDetail(Map<String, dynamic> entry, ThemeColors colors) {
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
            color: colors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.6),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Text(
                      mood.toUpperCase(),
                      style: AppTextStyles.labelSmall(colors).copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    dateStr,
                    style: AppTextStyles.hintText(colors),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    content,
                    style: AppTextStyles.bodyText(colors).copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
                    foregroundColor: colors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: colors.border),
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
    final colors = context.watch<ThemeProvider>().colors;
    final latestFiveHistory = _journalHistory.take(5).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colors.background,

      drawer: Drawer(
        backgroundColor: colors.background,
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
          color: colors.primary,
          backgroundColor: colors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HEADER (No right side icon) ────────────────
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
                        color: colors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.border.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: colors.icon,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── INPUT SECTION HEADER & MOOD CHIPS ───────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Express Yourself",
                      style: AppTextStyles.sectionTitle(colors),
                    ),
                    if (_thoughtController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _thoughtController.clear()),
                        child: Text(
                          "Clear",
                          style: AppTextStyles.hintText(colors),
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
                            color: isSelected ? colors.primary : colors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? colors.primary
                                  : colors.border.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(m['emoji']!, style: const TextStyle(fontSize: 13)),
                              const SizedBox(width: 6),
                              Text(
                                m['label']!,
                                style: AppTextStyles.labelSmall(colors).copyWith(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? colors.primaryForeground
                                      : colors.textPrimary,
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
                    color: colors.inputBackground,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: colors.inputBorder),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.1),
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
                          textCapitalization: TextCapitalization.sentences,
                          style: AppTextStyles.inputText(colors),
                          maxLines: 5,
                          minLines: 3,
                          decoration: InputDecoration(
                            hintText: "What's on your mind today? Write freely...",
                            hintStyle: AppTextStyles.hintText(colors),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      
                      Divider(height: 1, color: colors.border),

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
                                  color: colors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Private & encrypted",
                                  style: AppTextStyles.hintText(colors).copyWith(
                                    fontSize: 11,
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
                                  ? SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colors.primaryForeground,
                                      ),
                                    )
                                  : const Icon(Icons.send_rounded, size: 14),
                              label: Text(
                                _isPosting ? "Saving..." : "Save Entry",
                                style: AppTextStyles.buttonLabel(colors).copyWith(
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.primaryForeground,
                                disabledBackgroundColor:
                                    colors.primary.withValues(alpha: 0.3),
                                disabledForegroundColor: colors.primaryForeground
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

                // ── RECENT 5 ENTRIES TIMELINE SECTION ───────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Journal History",
                          style: AppTextStyles.sectionTitle(colors),
                        ),
                        const SizedBox(width: 8),
                        if (latestFiveHistory.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colors.border),
                            ),
                            child: Text(
                              "${latestFiveHistory.length}",
                              style: AppTextStyles.hintText(colors).copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh_rounded, size: 18, color: colors.textSecondary),
                      onPressed: _fetchJournalHistory,
                      tooltip: "Refresh history",
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // List of past 5 entries
                if (_isLoadingHistory && _journalHistory.isEmpty)
                  _buildHistoryLoadingState(colors)
                else if (_journalHistory.isEmpty)
                  _buildEmptyState(colors)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: latestFiveHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = latestFiveHistory[index];
                      return _JournalEntryCard(
                        entry: item,
                        colors: colors,
                        onTap: () => _showEntryDetail(item, colors),
                      );
                    },
                  ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.book_outlined,
              size: 26,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Your Nest is Empty",
            style: AppTextStyles.sectionTitle(colors),
          ),
          const SizedBox(height: 6),
          Text(
            "Write your first entry above to start building your personal journal timeline.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryLoadingState(ThemeColors colors) {
    return Column(
      children: List.generate(
        3,
        (_) => Container(
          width: double.infinity,
          height: 72,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border.withValues(alpha: 0.4)),
          ),
        ),
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final ThemeColors colors;
  final VoidCallback onTap;

  const _JournalEntryCard({
    required this.entry,
    required this.colors,
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
    final mood = entry['associatedMood']?.toString() ?? 'REFLECTION';
    final timeStr = _formatDate(entry['createdAt'] ?? entry['date']);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mood.toUpperCase(),
                    style: AppTextStyles.labelSmall(colors).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Text(
                  timeStr,
                  style: AppTextStyles.hintText(colors),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: AppTextStyles.bodyText(colors).copyWith(
                height: 1.45,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
