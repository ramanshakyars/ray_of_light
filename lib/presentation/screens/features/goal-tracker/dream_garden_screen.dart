import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker/create_wish_bottom_sheet.dart';

class DreamGardenScreen extends StatelessWidget {
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

  void _openCreateWish(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateWishBottomSheet(onSubmit: onCreateWish),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.getPrimary(isDark),
      //   onPressed: () => _openCreateWish(context),
      //   child: const Icon(Icons.add),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _Header(onCreateWishTap: () => _openCreateWish(context)),
            const SizedBox(height: 16),
            const _CategoryRow(),
            const SizedBox(height: 12),

            /// LIST
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : goals.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: goals.length,
                        itemBuilder:
                            (_, i) =>
                                _WishCard(goal: goals[i], onToggle: onToggle),
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
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Icon(Icons.menu, color: AppColors.getMonoIcon(isDark)),
          // const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dream Garden", style: AppTextStyles.monoBold22(isDark)),
                const SizedBox(height: 2),
                Text(
                  "Plant your dreams and watch them grow",
                  style: AppTextStyles.monoSecondary14(isDark),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onCreateWishTap,
            icon: Icon(
              Icons.auto_awesome_outlined,
              color: AppColors.getMonoIcon(isDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final items = [
      {"label": "All", "icon": null},
      {"label": "Hope", "icon": Icons.star_border},
      {"label": "Dream", "icon": Icons.auto_awesome_outlined},
      {"label": "Gratitude", "icon": Icons.favorite_border},
      {"label": "Intention", "icon": Icons.track_changes},
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == 0;
          final item = items[i];

          final bgColor = selected
              ? AppColors.getMonoTextPrimary(isDark)
              : AppColors.getMonoSurface(isDark);

          final textColor = selected
              ? (isDark ? Colors.black : Colors.white)
              : AppColors.getMonoTextSecondary(isDark);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.getMonoBorder(isDark),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ✅ ICON (except All)
                if (item["icon"] != null) ...[
                  Icon(
                    item["icon"] as IconData,
                    size: 16,
                    color: textColor,
                  ),
                  const SizedBox(width: 6),
                ],

                /// TEXT
                Text(
                  item["label"] as String,
                  style: AppTextStyles.monoSecondary14(isDark)
                      .copyWith(color: textColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<Map<String, dynamic>> goals;
  final bool isLoading;
  final Function(String goalId, bool value) onToggle;

  const _Body({
    required this.goals,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (goals.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: goals.length,
      itemBuilder: (_, i) => _WishCard(goal: goals[i], onToggle: onToggle),
    );
  }
}

class _WishCard extends StatelessWidget {
  final Map<String, dynamic> goal;
  final Function(String goalId, bool value) onToggle;

  const _WishCard({required this.goal, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final isCompleted = goal['status'] == 'COMPLETED';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getMonoBorder(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.getMonoSurface(isDark),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: AppColors.getMonoIcon(isDark),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  goal['title'] ?? '',
                  style: AppTextStyles.monoMedium18(isDark),
                ),
              ),

              Icon( 
                Icons.more_horiz,
                color: AppColors.getMonoIcon(isDark),
              ),

              // Checkbox(
              //   value: isCompleted,
              //   onChanged: (v) {
              //     if (v != null) {
              //       onToggle(goal['id'], v);
              //     }
              //   },
              // ),
            ],
          ),

          const SizedBox(height: 8),

          /// DESCRIPTION
          Text(
            goal['description'] ?? '',
            style: AppTextStyles.monoSecondary14(isDark),
          ),

          const SizedBox(height: 15),

          Divider(color: AppColors.getMonoBorder(isDark),thickness: 1,), 

          const SizedBox(height: 15),
          /// FOOTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today", style: AppTextStyles.monoMuted12(isDark)),
              Text(
                "+ Add more to this wish",
                style: AppTextStyles.monoSecondary14(isDark),
              ),
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
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Center(
      child: Text(
        "No wishes yet 🌱",
        style: AppTextStyles.monoMedium18(isDark),
      ),
    );
  }
}
