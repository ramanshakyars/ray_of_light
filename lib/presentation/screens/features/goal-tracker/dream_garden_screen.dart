import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker/create_wish_bottom_sheet.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

class DreamGardenScreen extends StatefulWidget {
  final List<Map<String, dynamic>> goals;
  final bool isLoading;
  final Function(Map<String, dynamic>) onCreateWish;
  final Function(String goalId, bool value) onToggle;

  const DreamGardenScreen({
    super.key,
    required this.goals,
    required this.isLoading,
    required this.onCreateWish,
    required this.onToggle,
  });

  @override
  State<DreamGardenScreen> createState() => _DreamGardenScreenState();
}

class _DreamGardenScreenState extends State<DreamGardenScreen> {
  String selectedCategory = "All";
  late List<Map<String, dynamic>> filteredGoals;

  @override
  void initState() {
    super.initState();
    filteredGoals = widget.goals;
  }

  @override
  void didUpdateWidget(covariant DreamGardenScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    filterGoals(selectedCategory);
  }

  void _openCreateWish(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateWishBottomSheet(
        onSubmit: widget.onCreateWish,
      ),
    );
  }

  void filterGoals(String category) {
    setState(() {
      selectedCategory = category;

      if (category == "All") {
        filteredGoals = widget.goals;
      } else {
        filteredGoals = widget.goals.where((goal) {
          final goalCategory = (goal['category'] ?? '').toString().toUpperCase();
          return goalCategory == category.toUpperCase();
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            _Header(
              onCreateWishTap: () => _openCreateWish(context),
            ),
            const SizedBox(height: 16),
            _CategoryRow(
              selectedCategory: selectedCategory,
              onSelect: filterGoals,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: widget.isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    )
                  : filteredGoals.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredGoals.length,
                          itemBuilder: (_, i) => _WishCard(
                            goal: filteredGoals[i],
                            onToggle: widget.onToggle,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onCreateWishTap;

  const _Header({required this.onCreateWishTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppScreenHeader(
        title: "Dream Garden",
        subtitle: "Plant your dreams and watch them grow",
        bottomPadding: 0,
        actions: [
          IconButton(
            onPressed: onCreateWishTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.auto_awesome_outlined,
              color: colors.icon,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onSelect;

  const _CategoryRow({
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    final items = [
      {"label": "All", "value": "All", "icon": null},
      {"label": "Hope", "value": "HOPE", "icon": Icons.star_border},
      {"label": "Dream", "value": "DREAM", "icon": Icons.auto_awesome_outlined},
      {"label": "Gratitude", "value": "GRATITUDE", "icon": Icons.favorite_border},
      {"label": "Intention", "value": "INTENTION", "icon": Icons.track_changes},
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final item = items[i];
          final value = item["value"] as String;
          final selected = selectedCategory == value;

          final bgColor = selected ? colors.primary : colors.surface;
          final textColor = selected ? colors.primaryForeground : colors.textSecondary;

          return GestureDetector(
            onTap: () => onSelect(value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected ? colors.primary : colors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item["icon"] != null) ...[
                    Icon(
                      item["icon"] as IconData,
                      size: 16,
                      color: textColor,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    item["label"] as String,
                    style: AppTextStyles.bodySecondary(colors).copyWith(
                      color: textColor,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WishCard extends StatelessWidget {
  final Map<String, dynamic> goal;
  final Function(String goalId, bool value) onToggle;

  const _WishCard({
    required this.goal,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    String formatDateTime(dynamic dateValue) {
      if (dateValue == null) return "";
      DateTime? date;
      if (dateValue is String) {
        date = DateTime.tryParse(dateValue);
      } else if (dateValue is List) {
        try {
          date = DateTime(
            dateValue[0],
            dateValue[1],
            dateValue[2],
            dateValue.length > 3 ? dateValue[3] : 0,
            dateValue.length > 4 ? dateValue[4] : 0,
          );
        } catch (_) {
          return "";
        }
      }
      if (date == null) return "";
      final d = "${date.day}/${date.month}";
      final t = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
      return "$d $t";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  goal['title'] ?? '',
                  style: AppTextStyles.cardTitle(colors),
                ),
              ),
              Icon(Icons.more_horiz, color: colors.icon),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goal['description'] ?? '',
            style: AppTextStyles.bodySecondary(colors),
          ),
          const SizedBox(height: 15),
          Divider(color: colors.border, thickness: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (goal['reminderAt'] != null) ...[
                    Icon(Icons.notifications, size: 14, color: colors.textMuted),
                    const SizedBox(width: 4),
                    Text(formatDateTime(goal['reminderAt']), style: AppTextStyles.hintText(colors)),
                    const SizedBox(width: 10),
                  ],
                  if (goal['targetDate'] != null) ...[
                    Icon(Icons.flag, size: 14, color: colors.textMuted),
                    const SizedBox(width: 4),
                    Text(formatDateTime(goal['targetDate']), style: AppTextStyles.hintText(colors)),
                  ],
                  if (goal['reminderAt'] == null && goal['targetDate'] == null)
                    Text("Today", style: AppTextStyles.hintText(colors)),
                ],
              ),
              Text("+ Add more to this wish", style: AppTextStyles.bodySecondary(colors)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Center(
      child: Text(
        "No wishes yet 🌱",
        style: AppTextStyles.sectionTitle(colors),
      ),
    );
  }
}