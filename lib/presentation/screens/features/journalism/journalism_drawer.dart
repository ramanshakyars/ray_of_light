import 'package:flutter/material.dart';

class JournalismDrawer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          // Custom header that mimics AppBar
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(),
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Journal History',
                    style: theme.textTheme.titleLarge?.copyWith(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Your Thoughts Archive',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(),
                      ),
                    ),
                  ),
                  Expanded(child:postedThoughts.isEmpty ? _buildEmptyState(): _buildThoughtsList()),
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
            color: theme.colorScheme.onSurface.withValues(),
          ),
          const SizedBox(height: 16),
          Text(
            'No entries yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your shared thoughts will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThoughtsList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: postedThoughts.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(),
          ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pop(context);
            onThoughtSelected(postedThoughts[index]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postedThoughts[index],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${index + 1} day${index == 0 ? '' : 's'} ago',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withValues(),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
