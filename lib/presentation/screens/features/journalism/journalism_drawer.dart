import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/journalService.dart';
import 'package:rayoflite/core/services/messageService.dart';

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
      MessageService.showError(context, 'Error: ${response['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          // Header
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              border: Border(
                bottom: BorderSide(color: colorScheme.outline, width: 1),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Journal History',
                    style: widget.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: isDark ? Colors.grey[900] : Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : journalHistory.isEmpty
                            ? _buildEmptyState()
                            : _buildThoughtsList(),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        final content = item['content'] ?? '';

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
              // Only journal content
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
