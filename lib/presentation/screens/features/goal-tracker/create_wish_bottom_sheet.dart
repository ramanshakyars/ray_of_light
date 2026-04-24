import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class CreateWishBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const CreateWishBottomSheet({super.key, required this.onSubmit});

  @override
  State<CreateWishBottomSheet> createState() => _CreateWishBottomSheetState();
}

class _CreateWishBottomSheetState extends State<CreateWishBottomSheet> {
  final _descController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? reminderDate;
  DateTime? targetDate;

  String selectedType = "HOPE";

  final List<_WishType> types = const [
    _WishType("HOPE", Icons.star_border),
    _WishType("DREAM", Icons.auto_awesome_outlined),
    _WishType("GRATITUDE", Icons.favorite_border),
    _WishType("INTENTION", Icons.track_changes),
  ];

  String formatDateTime(DateTime? date) {
    if (date == null) return "";

    final d = "${date.day}/${date.month}/${date.year}";
    final t = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

    return "$d  $t";
  }

  Future<void> pickReminder() async {
    // STEP 1: Pick Date
    final isDark = context.read<ThemeProvider>().isDarkMode;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.getMonoTextPrimary(isDark), // selected date
              onPrimary: isDark ? Colors.black : Colors.white,
              surface: AppColors.getMonoCard(isDark), // background
              onSurface: AppColors.getMonoTextPrimary(isDark),
            ),
            dialogBackgroundColor: AppColors.getMonoCard(isDark),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    // STEP 2: Pick Time
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      builder: (context, child) {
        final isDark = context.read<ThemeProvider>().isDarkMode;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                isDark
                    ? ColorScheme.dark(
                      primary: AppColors.getMonoTextPrimary(isDark),
                      onPrimary: Colors.black,
                      surface: AppColors.getMonoCard(isDark),
                      onSurface: AppColors.getMonoTextPrimary(isDark),
                    )
                    : ColorScheme.light(
                      primary: AppColors.getMonoTextPrimary(isDark),
                      onPrimary: Colors.white,
                      surface: AppColors.getMonoCard(isDark),
                      onSurface: AppColors.getMonoTextPrimary(isDark),
                    ),

            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.getMonoCard(isDark),

              /// 🔥 FIX THIS PART
              hourMinuteColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.getMonoTextPrimary(
                    isDark,
                  ); // selected bg (black)
                }
                return AppColors.getMonoSurface(
                  isDark,
                ); // normal bg (light grey)
              }),

              hourMinuteTextColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return isDark ? Colors.black : Colors.white; // selected text
                }
                return AppColors.getMonoTextPrimary(isDark); // normal text
              }),

              /// Clock
              dialBackgroundColor: AppColors.getMonoSurface(isDark),
              dialHandColor: AppColors.getMonoTextPrimary(isDark),

              /// AM PM (already fixed)
              dayPeriodColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.getMonoTextPrimary(isDark);
                }
                return AppColors.getMonoSurface(isDark);
              }),

              dayPeriodTextColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return isDark ? Colors.black : Colors.white;
                }
                return AppColors.getMonoTextPrimary(isDark);
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    // STEP 3: Combine Date + Time
    final finalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      reminderDate = finalDateTime;
    });
  }

  Future<void> pickTargetDate() async {
    final isDark = context.read<ThemeProvider>().isDarkMode;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.getMonoTextPrimary(isDark), // selected date
              onPrimary: isDark ? Colors.black : Colors.white,
              surface: AppColors.getMonoCard(isDark), // background
              onSurface: AppColors.getMonoTextPrimary(isDark),
            ),
            dialogBackgroundColor: AppColors.getMonoCard(isDark),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => targetDate = date);
    }
  }

  @override
  void initState() {
    super.initState();

    _descController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final surface = AppColors.getMonoSurface(isDark);
    final card = AppColors.getMonoCard(isDark);
    final border = AppColors.getMonoBorder(isDark);
    final textSecondary = AppColors.getMonoTextSecondary(isDark);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// drag handle
          Center(
            child: Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Create a Wish", style: AppTextStyles.monoBold22(isDark)),
              IconButton(
                splashRadius: 20,
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: AppColors.getMonoIcon(isDark)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// choose type
          Text("Choose a type", style: AppTextStyles.monoSecondary14(isDark)),

          const SizedBox(height: 14),

          /// TYPE GRID (⭐ matches image)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                types.map((t) {
                  final selected = selectedType == t.label;

                  return GestureDetector(
                    onTap: () => setState(() => selectedType = t.label),
                    child: Container(
                      width: 78,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color:
                            selected
                                ? AppColors.getMonoTextPrimary(isDark)
                                : surface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            t.icon,
                            size: 22,
                            color:
                                selected
                                    ? (isDark ? Colors.black : Colors.white)
                                    : textSecondary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatLabel(t.label),
                            style: AppTextStyles.monoMuted12(isDark).copyWith(
                              color:
                                  selected
                                      ? (isDark ? Colors.black : Colors.white)
                                      : textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 22),

          /// DESCRIPTION BOX
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextField(
              controller: _descController,
              maxLines: 4,
              style: AppTextStyles.monoRegular16(isDark),
              decoration: InputDecoration(
                hintText: "Write your wish here...",
                hintStyle: AppTextStyles.monoSecondary14(isDark),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// TITLE BOX
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: _titleController,
              style: AppTextStyles.monoRegular16(isDark),
              decoration: InputDecoration(
                hintText: "Title (optional)",
                hintStyle: AppTextStyles.monoSecondary14(isDark),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // / OPTIONS
          Text("Options", style: AppTextStyles.monoSecondary14(isDark)),

          const SizedBox(height: 10),

          _OptionTile(
            icon: Icons.notifications_none,
            title: "Set reminder",
            trailing:
                reminderDate != null
                    ? formatDateTime(reminderDate)
                    : "Set time",
            onTap: pickReminder,
          ),

          const SizedBox(height: 10),

          _OptionTile(
            icon: Icons.calendar_today_outlined,
            title: "Target date",
            trailing:
                targetDate != null
                    ? targetDate.toString().split(" ")[0]
                    : "Set date",
            onTap: pickTargetDate,
          ),

          const Spacer(),

          /// CREATE BUTTON (disabled look like image)
          _PrimaryButton(
            label: "Create Wish",
            enabled:
                _descController.text.trim().isNotEmpty &&
                selectedType.isNotEmpty,
            onTap: () {
              final description = _descController.text.trim();
              if (description.isEmpty) return;
              widget.onSubmit({
                "title":
                    _titleController.text.trim().isEmpty
                        ? description
                        : _titleController.text.trim(),
                "description": description,
                "category": selectedType,
                "reminderAt": reminderDate?.toIso8601String(),
                "targetDate": targetDate?.toIso8601String(),
              });

              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 10),

          /// CANCEL BUTTON
          _SecondaryButton(
            label: "Cancel",
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _formatLabel(String raw) {
    return raw[0] + raw.substring(1).toLowerCase();
  }
}

/// ===============================
/// MODELS
/// ===============================

class _WishType {
  final String label;
  final IconData icon;

  const _WishType(this.label, this.icon);
}

/// ===============================
/// OPTION TILE
/// ===============================

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.getMonoSurface(isDark),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.getMonoTextSecondary(isDark)),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            Text(trailing),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// PRIMARY BUTTON
/// ===============================

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              enabled
                  ? AppColors.getMonoTextPrimary(isDark)
                  : AppColors.getMonoSurface(isDark),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          style: AppTextStyles.monoMedium18(isDark).copyWith(
            color:
                enabled
                    ? (isDark ? Colors.black : Colors.white)
                    : AppColors.getMonoTextMuted(isDark),
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// SECONDARY BUTTON
/// ===============================

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.getMonoSurface(isDark),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(label, style: AppTextStyles.monoMedium18(isDark)),
      ),
    );
  }
}
