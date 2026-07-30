import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rayoflite/core/services/journalService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

class JournalismDrawer extends StatefulWidget {
  final List<String> postedThoughts;
  final Function(String) onThoughtSelected;
  final ThemeData theme;

  const JournalismDrawer({
    super.key,
    required this.postedThoughts,
    required this.onThoughtSelected,
    required this.theme,
  });

  @override
  State<JournalismDrawer> createState() => _JournalismDrawerState();
}

class _JournalismDrawerState extends State<JournalismDrawer> {
  bool isLoading = false;
  List<Map<String, dynamic>> journalHistory = [];
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJournalsHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJournalsHistory() async {
    setState(() => isLoading = true);
    final response = await JournalService.getJournalsHistory();
    setState(() => isLoading = false);

    if (response['success'] == true && response['data'] != null) {
      setState(() {
        journalHistory = (response['data'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      });
    } else {
      if (mounted) {
        MessageService.showError(context, 'Failed to load journal history.');
      }
    }
  }

  List<Map<String, dynamic>> get filteredHistory {
    if (searchQuery.trim().isEmpty) return journalHistory;
    final q = searchQuery.toLowerCase();
    return journalHistory.where((item) {
      final content = (item['content'] ?? '').toString().toLowerCase();
      final mood = (item['associatedMood'] ?? '').toString().toLowerCase();
      return content.contains(q) || mood.contains(q);
    }).toList();
  }

  void _selectEntry(String content) {
    HapticFeedback.selectionClick();
    widget.onThoughtSelected(content);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.brightness == Brightness.dark;
    final primaryColor = AppColors.getMonoTextPrimary(isDark);
    final secondaryColor = AppColors.getMonoTextSecondary(isDark);
    final surfaceColor = AppColors.getMonoSurface(isDark);
    final borderColor = AppColors.getMonoBorder(isDark);

    return Drawer(
      backgroundColor: AppColors.getMonoBackground(isDark),
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history_rounded, size: 20, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Journal History",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: primaryColor, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ── SEARCH BAR ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => searchQuery = val),
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: primaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search thoughts...",
                    hintStyle: AppTextStyles.monoMuted12(isDark),
                    icon: Icon(Icons.search_rounded, size: 18, color: secondaryColor),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── ENTRIES LIST ───────────────────────────────
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    )
                  : filteredHistory.isEmpty
                      ? _buildEmptyState(isDark, primaryColor, secondaryColor)
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: filteredHistory.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = filteredHistory[index];
                            final content = item['content']?.toString() ?? '';
                            final mood = item['associatedMood']?.toString() ?? 'THOUGHT';

                            return GestureDetector(
                              onTap: () => _selectEntry(content),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: borderColor.withValues(alpha: 0.6)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          mood.toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: secondaryColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        Icon(
                                          Icons.north_west_rounded,
                                          size: 14,
                                          color: secondaryColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        height: 1.4,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color primaryColor, Color secondaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_list_bulleted_rounded,
              size: 36,
              color: secondaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              searchQuery.isNotEmpty ? "No matching entries" : "No entries yet",
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
