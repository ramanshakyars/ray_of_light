import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadJournalsHistory();
  }

  /// Load journal history

  Future<void> _loadJournalsHistory() async {
    setState(() => isLoading = true);
    final response = await JournalService.getJournalsHistory();
    setState(() => isLoading = false);

    if (response['success']) {
      setState(() {
        journalHistory =
            (response['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
        setState(() {});
      });
    } else {
      MessageService.showError(context, 'Failed to load journal history.');
      print('Error fetching journal history: ${response['message']}');
    }
  }

  @override
@override
Widget build(BuildContext context) {
  final isDark =
      widget.theme.brightness == Brightness.dark;

  return Drawer(
    backgroundColor: AppColors.getMonoBackground(isDark),
    width: MediaQuery.of(context).size.width * 0.88,
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Journal History",
                  style: AppTextStyles.monoMedium18(isDark),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color:
                          AppColors.getMonoIcon(isDark)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // ===== LIST =====
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator())
                : journalHistory.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20),
                        itemCount: journalHistory.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final item =
                              journalHistory[index];
                          final content =
                              item['content'] ?? '';

                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                content,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style:
                                    AppTextStyles.monoRegular16(
                                        isDark),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Today",
                                style:
                                    AppTextStyles.monoMuted12(
                                        isDark),
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    ),
  );
}

  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 48,
            color: widget.theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            'No entries yet',
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your shared thoughts will appear here',
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThoughtsList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: journalHistory.length,
      separatorBuilder:
          (context, index) =>
              Divider(height: 1, color: widget.theme.colorScheme.outline),
      itemBuilder: (context, index) {
        final item = journalHistory[index];
        final fullContent = item['content'] ?? '';
        final words = fullContent.split(' ');
        final content =
            words.length <= 4 ? fullContent : '${words.take(4).join(' ')}...';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left colored indicator
              Container(
                width: 4,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: widget.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Truncated journal content
              Expanded(
                child: Text(
                  content,
                  style: widget.theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
